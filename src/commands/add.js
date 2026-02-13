const GitUtils = require('../utils/git');
const SymlinkUtils = require('../utils/symlinks');
const UI = require('../utils/ui');

async function add(repo, options) {
  const git = new GitUtils();
  const symlinks = new SymlinkUtils();

  try {
    // Step 1: Verify environment
    UI.header('STEP 1/5: Verify Environment');

    const spinner = UI.spinner('Checking Git repository...').start();

    const isRepo = await git.isGitRepo();
    if (!isRepo) {
      spinner.fail();
      UI.error('Not a Git repository!');
      UI.newline();
      UI.box('ERROR', [
        'BALDART requires your project to be a Git repository.',
        '',
        'Solution:',
        '  1. Initialize Git: git init',
        '  2. Or navigate to your project directory'
      ]);
      process.exit(1);
    }

    spinner.succeed('Git repository verified');

    // Step 2: Check for existing framework
    UI.header('STEP 2/5: Check Existing Installation');

    const exists = await git.frameworkExists();
    if (exists) {
      UI.warning('Framework already installed!');
      const shouldReinstall = await UI.confirm(
        'Remove and reinstall? (You will lose customizations)',
        false
      );

      if (!shouldReinstall) {
        UI.info('Installation cancelled. Use "baldart update" to update.');
        process.exit(0);
      }

      UI.warning('Removing existing framework...');
      const fs = require('fs');
      fs.rmSync('.framework', { recursive: true, force: true });
    }

    UI.success('Ready for installation');

    // Step 3: Explain what will be installed
    UI.header('STEP 3/5: Installation Overview');

    UI.box('WHAT WILL BE INSTALLED', [
      '• Core Protocol: AGENTS.md (coordination rules)',
      '• 17 Agent Modules: architecture, workflows, testing...',
      '• 9 AI Agents: coder, code-reviewer, doc-reviewer...',
      '• 3 Commands: /new, /design-review, /issue-review',
      '• Templates: backlog cards, specs, UI guidelines',
      '• Pre-commit hooks (customizable)',
      '',
      'Framework will be installed in .framework/ directory',
      'Symlinks created for auto-updateable files',
      'Templates copied for customization'
    ]);

    const proceed = await UI.confirm('Install framework?', true);
    if (!proceed) {
      UI.info('Installation cancelled');
      process.exit(0);
    }

    // Step 4: Download framework
    UI.header('STEP 4/5: Download Framework');

    const downloadSpinner = UI.spinner(`Downloading from ${repo}...`).start();

    try {
      await git.addSubtree(repo, options.branch);
      downloadSpinner.succeed('Framework downloaded');

      const version = await git.getFrameworkVersion();
      UI.success(`Version installed: ${version}`);
    } catch (error) {
      downloadSpinner.fail();
      UI.error('Failed to download framework!');
      UI.newline();
      UI.box('ERROR', [
        'Possible causes:',
        '  • No internet connection',
        '  • Repository not accessible',
        `  • Invalid repository: ${repo}`,
        '',
        'Solution:',
        '  • Check your internet connection',
        '  • Verify repository exists',
        '  • Try again later'
      ]);
      throw error;
    }

    // Step 5: Setup structure
    UI.header('STEP 5/5: Setup Project Structure');

    UI.info('Creating directories...');
    symlinks.ensureDirectory('.claude');
    symlinks.ensureDirectory('docs/references');
    symlinks.ensureDirectory('templates');
    symlinks.ensureDirectory('backlog');
    UI.success('Directories created');

    UI.newline();
    symlinks.createAllSymlinks();

    UI.newline();
    symlinks.copyCustomizableFiles();

    // Configure Git aliases
    UI.section('Configuring Git Aliases');

    const configureAliases = await UI.confirm('Configure git aliases (fw-version, fw-update, fw-push)?', true);

    if (configureAliases) {
      await git.git.addConfig('alias.fw-version', '!cat .framework/VERSION');
      await git.git.addConfig('alias.fw-update', '!npx baldart update');
      await git.git.addConfig('alias.fw-push', '!npx baldart push');
      UI.success('Git aliases configured');
    }

    // Success summary
    UI.header('✓ INSTALLATION COMPLETE');

    UI.box('NEXT STEPS', [
      '1. Customize pre-commit hook:',
      '   • Edit .claude/hooks/lint-before-commit.sh.template',
      '   • Rename to lint-before-commit.sh',
      '   • Make executable: chmod +x .claude/hooks/lint-before-commit.sh',
      '',
      '2. Customize UI guidelines:',
      '   • Edit docs/references/ui-guidelines.template.md',
      '   • Define colors, typography, spacing',
      '',
      '3. Create backlog cards:',
      '   • Copy templates/feature-card.template.yml',
      '   • Use /new command to implement',
      '',
      '4. Read documentation:',
      '   • cat AGENTS.md'
    ]);

    UI.newline();
    UI.section('Available Commands');
    UI.list([
      'baldart version  - Show framework version',
      'baldart update   - Update framework',
      'baldart push     - Contribute improvements',
      'baldart status   - Check installation status'
    ], 'cyan');

    UI.newline();
    UI.success('Framework ready to use!');

  } catch (error) {
    UI.error(`Installation failed: ${error.message}`);
    process.exit(1);
  }
}

module.exports = add;
