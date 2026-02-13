#!/usr/bin/env node

const { Command } = require('commander');
const chalk = require('chalk');
const packageJson = require('../package.json');

const program = new Command();

program
  .name('baldart')
  .description('Claude Agent Framework - AI agent coordination for software projects')
  .version(packageJson.version);

program
  .command('add [repo]')
  .description('Install the framework in your project')
  .option('-b, --branch <branch>', 'Branch to use', 'main')
  .action(async (repo, options) => {
    const addCommand = require('../src/commands/add');
    await addCommand(repo || 'antbald/BALDART', options);
  });

program
  .command('update')
  .description('Update the framework to the latest version')
  .action(async () => {
    const updateCommand = require('../src/commands/update');
    await updateCommand();
  });

program
  .command('push')
  .description('Push your improvements back to the framework')
  .action(async () => {
    const pushCommand = require('../src/commands/push');
    await pushCommand();
  });

program
  .command('version')
  .description('Show installed framework version')
  .action(async () => {
    const versionCommand = require('../src/commands/version');
    await versionCommand();
  });

program
  .command('status')
  .description('Show framework installation status')
  .action(async () => {
    const statusCommand = require('../src/commands/status');
    await statusCommand();
  });

// Error handling
program.exitOverride();

program.parse(process.argv);

// Show help if no command provided
if (!process.argv.slice(2).length) {
  program.outputHelp();
}
