const GitUtils = require('../utils/git');
const SymlinkUtils = require('../utils/symlinks');
const UI = require('../utils/ui');

async function update() {
  const git = new GitUtils();
  const symlinks = new SymlinkUtils();
  const repo = 'antbald/BALDART'; // Default repo

  try {
    // Step 1: Verify installation
    UI.header('STEP 1/5: Verify Installation');

    const exists = await git.frameworkExists();
    if (!exists) {
      UI.error('Framework not installed!');
      UI.newline();
      UI.box('ERROR', [
        'Framework directory .framework/ not found.',
        '',
        'Solution:',
        '  Install first: npx baldart add'
      ]);
      process.exit(1);
    }

    const currentVersion = await git.getFrameworkVersion();
    UI.success(`Current version: ${currentVersion}`);

    // Step 2: Check for updates
    UI.header('STEP 2/5: Check for Updates');

    const spinner = UI.spinner('Connecting to repository...').start();

    try {
      await git.fetch(repo);
      spinner.succeed('Connected to repository');
    } catch (error) {
      spinner.fail();
      UI.error('Cannot connect to repository!');
      UI.newline();
      UI.box('ERROR', [
        'Possible causes:',
        '  • No internet connection',
        '  • Repository not accessible',
        '',
        'Solution:',
        '  • Check internet connection',
        '  • Try again later'
      ]);
      process.exit(1);
    }

    // Compare versions (simplified - in real scenario would fetch VERSION from remote)
    UI.info('Checking for updates...');

    const hasChanges = await git.hasChangesToPush();
    if (!hasChanges) {
      UI.success('Already up to date!');
      process.exit(0);
    }

    UI.warning('Updates available!');

    // Step 3: Show changes preview
    UI.header('STEP 3/5: Preview Changes');

    const diff = await git.diffWithRemote();
    if (diff) {
      UI.info('Changes detected. Review recommended.');
      const showDiff = await UI.confirm('Show detailed diff?', false);

      if (showDiff) {
        console.log(diff);
      }
    }

    const proceedUpdate = await UI.confirm('Proceed with update?', true);
    if (!proceedUpdate) {
      UI.info('Update cancelled');
      process.exit(0);
    }

    // Step 4: Create backup
    UI.header('STEP 4/5: Create Backup');

    const backupSpinner = UI.spinner('Creating backup tag...').start();
    const backupTag = await git.createBackupTag();
    backupSpinner.succeed(`Backup created: ${backupTag}`);

    UI.newline();
    UI.box('ROLLBACK INFO', [
      'If something goes wrong, rollback with:',
      `  git checkout ${backupTag}`,
      '  git checkout -b recovery-branch'
    ]);

    // Step 5: Update framework
    UI.header('STEP 5/5: Update Framework');

    const updateSpinner = UI.spinner('Updating framework...').start();

    try {
      await git.updateSubtree(repo);
      updateSpinner.succeed('Framework updated');

      const newVersion = await git.getFrameworkVersion();
      UI.success(`New version: ${newVersion}`);
    } catch (error) {
      updateSpinner.fail();
      UI.error('Update failed!');

      if (error.message.includes('conflict')) {
        UI.newline();
        UI.box('MERGE CONFLICT', [
          'Git found conflicts during update.',
          '',
          'Resolution:',
          '  1. Check conflicts: git status',
          '  2. For each conflict file:',
          '     • Keep yours: git checkout --ours <file>',
          '     • Use new: git checkout --theirs <file>',
          '     • Edit manually to resolve',
          '  3. After resolving:',
          '     git add <files>',
          '     git commit -m "Resolved update conflicts"',
          '  4. Retry: baldart update',
          '',
          'Or rollback:',
          `  git checkout ${backupTag}`
        ]);
      }

      throw error;
    }

    // Verify symlinks
    UI.newline();
    UI.section('Verifying Symlinks');

    const symlinkValid = symlinks.verifySymlinks();
    if (!symlinkValid) {
      const recreate = await UI.confirm('Recreate broken symlinks?', true);
      if (recreate) {
        symlinks.createAllSymlinks();
      }
    }

    // Success
    UI.header('✓ UPDATE COMPLETE');

    UI.box('WHAT CHANGED', [
      `Version: ${currentVersion} → ${newVersion}`,
      '',
      'Review CHANGELOG:',
      '  cat .framework/CHANGELOG.md',
      '',
      'Check template updates:',
      '  diff .framework/.claude/hooks/*.template .claude/hooks/',
      '',
      `Backup available: ${backupTag}`,
      `Remove when confident: git tag -d ${backupTag}`
    ]);

    UI.newline();
    UI.success('Framework updated successfully!');

  } catch (error) {
    UI.error(`Update failed: ${error.message}`);
    process.exit(1);
  }
}

module.exports = update;
