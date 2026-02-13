const GitUtils = require('../utils/git');
const UI = require('../utils/ui');

async function version() {
  const git = new GitUtils();

  try {
    const exists = await git.frameworkExists();

    if (!exists) {
      UI.warning('Framework not installed');
      UI.info('Install with: npx baldart add');
      process.exit(0);
    }

    const frameworkVersion = await git.getFrameworkVersion();

    UI.newline();
    UI.box('BALDART VERSION', [
      `Framework version: ${frameworkVersion}`,
      `CLI version: ${require('../../package.json').version}`,
      '',
      'Repository: https://github.com/antbald/BALDART'
    ]);
    UI.newline();

  } catch (error) {
    UI.error(`Failed to get version: ${error.message}`);
    process.exit(1);
  }
}

module.exports = version;
