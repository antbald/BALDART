const simpleGit = require('simple-git');
const path = require('path');
const fs = require('fs');

const FRAMEWORK_DIR = '.framework';

class GitUtils {
  constructor(cwd = process.cwd()) {
    this.cwd = cwd;
    this.git = simpleGit(cwd);
  }

  async isGitRepo() {
    try {
      await this.git.status();
      return true;
    } catch (error) {
      return false;
    }
  }

  async hasCleanWorkingTree() {
    const status = await this.git.status();
    return status.isClean();
  }

  async frameworkExists() {
    const frameworkPath = path.join(this.cwd, FRAMEWORK_DIR);
    return fs.existsSync(frameworkPath);
  }

  async addSubtree(repo, branch = 'main') {
    const repoUrl = this.normalizeRepoUrl(repo);

    await this.git.raw([
      'subtree',
      'add',
      '--prefix',
      FRAMEWORK_DIR,
      repoUrl,
      branch,
      '--squash'
    ]);
  }

  async updateSubtree(repo, branch = 'main') {
    const repoUrl = this.normalizeRepoUrl(repo);

    await this.git.raw([
      'subtree',
      'pull',
      '--prefix',
      FRAMEWORK_DIR,
      repoUrl,
      branch,
      '--squash'
    ]);
  }

  async pushSubtree(repo, branch = 'main') {
    const repoUrl = this.normalizeRepoUrl(repo);

    await this.git.raw([
      'subtree',
      'push',
      '--prefix',
      FRAMEWORK_DIR,
      repoUrl,
      branch
    ]);
  }

  async getFrameworkVersion() {
    const versionFile = path.join(this.cwd, FRAMEWORK_DIR, 'VERSION');
    if (fs.existsSync(versionFile)) {
      return fs.readFileSync(versionFile, 'utf8').trim();
    }
    return 'unknown';
  }

  async createBackupTag() {
    const timestamp = new Date().toISOString().replace(/[:.]/g, '-').slice(0, 19);
    const tagName = `backup/${timestamp}`;
    await this.git.addTag(tagName);
    return tagName;
  }

  async getRemoteVersion(repo, branch = 'main') {
    const repoUrl = this.normalizeRepoUrl(repo);

    try {
      const versionContent = await this.git.raw([
        'show',
        `${repoUrl}/${branch}:VERSION`
      ]);
      return versionContent.trim();
    } catch (error) {
      return 'unknown';
    }
  }

  async hasChangesToPush() {
    try {
      const log = await this.git.raw([
        'log',
        'origin/main..HEAD',
        '--oneline',
        '--',
        FRAMEWORK_DIR
      ]);
      return log.trim().length > 0;
    } catch (error) {
      return false;
    }
  }

  async getChangesSummary() {
    try {
      const log = await this.git.raw([
        'log',
        'origin/main..HEAD',
        '--oneline',
        '--',
        FRAMEWORK_DIR
      ]);

      const stat = await this.git.raw([
        'diff',
        'origin/main..HEAD',
        '--stat',
        '--',
        FRAMEWORK_DIR
      ]);

      return { log: log.trim(), stat: stat.trim() };
    } catch (error) {
      return { log: '', stat: '' };
    }
  }

  normalizeRepoUrl(repo) {
    // Handle different formats:
    // - "owner/repo" -> "https://github.com/owner/repo.git"
    // - "https://github.com/owner/repo" -> "https://github.com/owner/repo.git"
    // - "https://github.com/owner/repo.git" -> unchanged

    if (repo.startsWith('http://') || repo.startsWith('https://')) {
      return repo.endsWith('.git') ? repo : `${repo}.git`;
    }

    // Assume GitHub shorthand
    return `https://github.com/${repo}.git`;
  }

  async commitChanges(message) {
    await this.git.add(FRAMEWORK_DIR);
    await this.git.commit(message);
  }

  async fetch(repo, branch = 'main') {
    const repoUrl = this.normalizeRepoUrl(repo);
    await this.git.fetch(repoUrl, branch);
  }

  async diffWithRemote() {
    try {
      const diff = await this.git.raw([
        'diff',
        'HEAD',
        'FETCH_HEAD',
        '--',
        FRAMEWORK_DIR
      ]);
      return diff;
    } catch (error) {
      return '';
    }
  }
}

module.exports = GitUtils;
