const GitUtils = require('../utils/git');
const UI = require('../utils/ui');

async function push() {
  const git = new GitUtils();
  const repo = 'antbald/BALDART';

  try {
    // Step 1: Check for changes
    UI.header('STEP 1/4: Check for Changes');

    const exists = await git.frameworkExists();
    if (!exists) {
      UI.error('Framework not installed!');
      process.exit(1);
    }

    const hasChanges = await git.hasChangesToPush();
    if (!hasChanges) {
      UI.warning('No changes to push!');
      UI.info('Your framework version matches the remote.');
      process.exit(0);
    }

    UI.success('Changes found - ready to contribute!');

    // Step 2: Review changes
    UI.header('STEP 2/4: Review Changes');

    const { log, stat } = await git.getChangesSummary();

    UI.section('Commits to Push');
    console.log(log || 'No commits');

    UI.newline();
    UI.section('Files Modified');
    console.log(stat || 'No changes');

    const showDiff = await UI.confirm('Show detailed diff?', false);
    if (showDiff) {
      const diff = await git.diffWithRemote();
      console.log(diff);
    }

    const proceed = await UI.confirm('Push these changes?', true);
    if (!proceed) {
      UI.info('Push cancelled');
      process.exit(0);
    }

    // Step 3: Classify change type
    UI.header('STEP 3/4: Classify Change Type');

    UI.box('SEMANTIC VERSIONING', [
      'MAJOR (X.0.0): Breaking changes',
      '  • Removed agent or command',
      '  • Changed directory structure',
      '  • Incompatible protocol changes',
      '',
      'MINOR (0.X.0): New features',
      '  • New agent',
      '  • New command',
      '  • New module',
      '',
      'PATCH (0.0.X): Bug fixes',
      '  • Documentation fixes',
      '  • Script improvements',
      '  • Bug fixes'
    ]);

    const changeType = await UI.select('Change type?', [
      { name: 'MAJOR - Breaking change', value: 'MAJOR' },
      { name: 'MINOR - New feature', value: 'MINOR' },
      { name: 'PATCH - Bug fix', value: 'PATCH' }
    ]);

    const description = await UI.input('Brief description of change:');

    if (!description) {
      UI.error('Description required!');
      process.exit(1);
    }

    // Step 4: Push changes
    UI.header('STEP 4/4: Push to Repository');

    const pushSpinner = UI.spinner('Pushing changes...').start();

    try {
      await git.pushSubtree(repo);
      pushSpinner.succeed('Changes pushed successfully!');
    } catch (error) {
      pushSpinner.fail();

      if (error.message.includes('Permission denied') || error.message.includes('403')) {
        UI.error('Permission denied!');
        UI.newline();
        UI.box('AUTHENTICATION ERROR', [
          'You do not have write access to the repository.',
          '',
          'Solutions:',
          '  1. Fork the repository',
          '  2. Push to your fork',
          '  3. Create a pull request',
          '',
          'Or configure authentication:',
          '  • SSH key: ssh-keygen and add to GitHub',
          '  • Personal Access Token (PAT)'
        ]);
      } else if (error.message.includes('conflict') || error.message.includes('non-fast-forward')) {
        UI.error('Remote has updates you don\'t have!');
        UI.newline();
        UI.box('SYNC REQUIRED', [
          'Update first, then push:',
          '  1. baldart update',
          '  2. Resolve conflicts if any',
          '  3. baldart push'
        ]);
      }

      throw error;
    }

    // Success
    UI.header('✓ PUSH COMPLETE');

    UI.box('NEXT STEPS', [
      `Change type: ${changeType}`,
      `Description: ${description}`,
      '',
      'Manual steps required:',
      '  1. Update VERSION file in repository',
      '  2. Add entry to CHANGELOG.md',
      '  3. Create git tag: git tag vX.Y.Z',
      '',
      'Thank you for contributing!'
    ]);

    UI.newline();
    UI.success('Contribution pushed successfully!');

  } catch (error) {
    UI.error(`Push failed: ${error.message}`);
    process.exit(1);
  }
}

module.exports = push;
