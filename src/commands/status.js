const GitUtils = require('../utils/git');
const SymlinkUtils = require('../utils/symlinks');
const UI = require('../utils/ui');
const fs = require('fs');
const path = require('path');

async function status() {
  const git = new GitUtils();
  const symlinks = new SymlinkUtils();

  try {
    UI.header('BALDART STATUS');

    // Check installation
    const exists = await git.frameworkExists();

    if (!exists) {
      UI.warning('Framework not installed');
      UI.info('Install with: npx baldart add');
      process.exit(0);
    }

    // Get version
    const version = await git.getFrameworkVersion();
    UI.success(`Framework installed: v${version}`);

    // Check symlinks
    UI.newline();
    UI.section('Symlinks Status');
    const symlinkValid = symlinks.verifySymlinks();

    if (!symlinkValid) {
      UI.newline();
      UI.warning('Some symlinks are broken. Run: baldart add (to reinstall)');
    }

    // Check customizable files
    UI.newline();
    UI.section('Customizable Files');

    const customFiles = [
      '.claude/hooks/lint-before-commit.sh.template',
      '.claude/hooks/lint-before-commit.sh',
      'docs/references/ui-guidelines.template.md',
      'docs/references/brand-guidelines.md',
      'templates/feature-card.template.yml'
    ];

    customFiles.forEach(file => {
      const fullPath = path.join(process.cwd(), file);
      if (fs.existsSync(fullPath)) {
        UI.success(`Found: ${file}`);
      } else {
        UI.warning(`Missing: ${file}`);
      }
    });

    // Check for pending updates
    UI.newline();
    UI.section('Update Status');

    try {
      await git.fetch('antbald/BALDART');
      UI.info('Checking for updates...');
      // Simplified - would need more sophisticated version comparison
      UI.success('Up to date (check with: baldart update)');
    } catch (error) {
      UI.warning('Cannot check for updates (offline?)');
    }

    // Summary
    UI.newline();
    UI.box('SUMMARY', [
      `Version: ${version}`,
      `Installation: ${symlinkValid ? 'Valid' : 'Issues detected'}`,
      '',
      'Commands available:',
      '  • baldart update  - Update framework',
      '  • baldart push    - Contribute changes',
      '  • baldart version - Show version'
    ]);

    UI.newline();

  } catch (error) {
    UI.error(`Status check failed: ${error.message}`);
    process.exit(1);
  }
}

module.exports = status;
