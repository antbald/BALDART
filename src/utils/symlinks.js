const fs = require('fs');
const path = require('path');
const UI = require('./ui');

const FRAMEWORK_DIR = '.framework';

class SymlinkUtils {
  constructor(cwd = process.cwd()) {
    this.cwd = cwd;
  }

  createSymlink(target, linkPath, relative = false) {
    const fullLinkPath = path.join(this.cwd, linkPath);
    const fullTarget = relative
      ? path.relative(path.dirname(fullLinkPath), path.join(this.cwd, target))
      : path.join(this.cwd, target);

    // Backup existing file/directory
    if (fs.existsSync(fullLinkPath) && !fs.lstatSync(fullLinkPath).isSymbolicLink()) {
      const backupPath = `${fullLinkPath}.backup`;
      UI.warning(`Backing up existing: ${linkPath} → ${linkPath}.backup`);
      fs.renameSync(fullLinkPath, backupPath);
    }

    // Remove existing symlink
    if (fs.existsSync(fullLinkPath) && fs.lstatSync(fullLinkPath).isSymbolicLink()) {
      fs.unlinkSync(fullLinkPath);
    }

    // Create symlink
    fs.symlinkSync(fullTarget, fullLinkPath);
    UI.success(`Symlink created: ${linkPath} → ${target}`);
  }

  createAllSymlinks() {
    UI.section('Creating Symlinks');

    // AGENTS.md
    this.createSymlink(
      path.join(FRAMEWORK_DIR, 'AGENTS.md'),
      'AGENTS.md'
    );

    // agents/
    this.createSymlink(
      path.join(FRAMEWORK_DIR, 'agents'),
      'agents'
    );

    // .claude/agents/
    this.ensureDirectory('.claude');
    this.createSymlink(
      path.join('..', FRAMEWORK_DIR, '.claude', 'agents'),
      path.join('.claude', 'agents'),
      true
    );

    // .claude/commands/
    this.createSymlink(
      path.join('..', FRAMEWORK_DIR, '.claude', 'commands'),
      path.join('.claude', 'commands'),
      true
    );

    UI.newline();
  }

  verifySymlinks() {
    const symlinks = [
      'AGENTS.md',
      'agents',
      '.claude/agents',
      '.claude/commands'
    ];

    let allValid = true;

    symlinks.forEach(link => {
      const fullPath = path.join(this.cwd, link);

      if (!fs.existsSync(fullPath)) {
        UI.warning(`Missing: ${link}`);
        allValid = false;
      } else if (!fs.lstatSync(fullPath).isSymbolicLink()) {
        UI.warning(`Not a symlink: ${link}`);
        allValid = false;
      } else if (!fs.existsSync(fs.readlinkSync(fullPath))) {
        UI.warning(`Broken symlink: ${link}`);
        allValid = false;
      } else {
        UI.success(`Valid: ${link}`);
      }
    });

    return allValid;
  }

  ensureDirectory(dir) {
    const fullPath = path.join(this.cwd, dir);
    if (!fs.existsSync(fullPath)) {
      fs.mkdirSync(fullPath, { recursive: true });
    }
  }

  copyFile(source, dest) {
    const fullSource = path.join(this.cwd, source);
    const fullDest = path.join(this.cwd, dest);

    // Ensure destination directory exists
    const destDir = path.dirname(fullDest);
    if (!fs.existsSync(destDir)) {
      fs.mkdirSync(destDir, { recursive: true });
    }

    // Don't overwrite existing files
    if (fs.existsSync(fullDest)) {
      UI.warning(`Skipped (already exists): ${dest}`);
      return false;
    }

    fs.copyFileSync(fullSource, fullDest);
    UI.success(`Copied: ${dest}`);
    return true;
  }

  copyCustomizableFiles() {
    UI.section('Copying Customizable Templates');

    // Hooks
    this.ensureDirectory('.claude/hooks');
    this.copyFile(
      path.join(FRAMEWORK_DIR, '.claude', 'hooks', 'lint-before-commit.sh.template'),
      path.join('.claude', 'hooks', 'lint-before-commit.sh.template')
    );

    // UI guidelines
    this.ensureDirectory('docs/references');
    this.copyFile(
      path.join(FRAMEWORK_DIR, 'docs', 'references', 'ui-guidelines.template.md'),
      path.join('docs', 'references', 'ui-guidelines.template.md')
    );

    this.copyFile(
      path.join(FRAMEWORK_DIR, 'docs', 'references', 'brand-guidelines.md'),
      path.join('docs', 'references', 'brand-guidelines.md')
    );

    // Templates
    this.ensureDirectory('templates');
    const templateFiles = fs.readdirSync(path.join(this.cwd, FRAMEWORK_DIR, 'templates'));

    templateFiles.forEach(file => {
      this.copyFile(
        path.join(FRAMEWORK_DIR, 'templates', file),
        path.join('templates', file)
      );
    });

    UI.newline();
  }
}

module.exports = SymlinkUtils;
