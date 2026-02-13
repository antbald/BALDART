const chalk = require('chalk');
const ora = require('ora');
const inquirer = require('inquirer');

class UI {
  static header(text) {
    console.log('');
    console.log(chalk.cyan('━'.repeat(60)));
    console.log(chalk.cyan.bold(text));
    console.log(chalk.cyan('━'.repeat(60)));
    console.log('');
  }

  static step(number, text) {
    console.log(chalk.green(`✓ STEP ${number}:`) + ` ${text}`);
  }

  static info(text) {
    console.log(chalk.blue('→') + ` ${text}`);
  }

  static success(text) {
    console.log(chalk.green('✓') + ` ${text}`);
  }

  static warning(text) {
    console.log(chalk.yellow('⚠') + ` ${text}`);
  }

  static error(text) {
    console.log(chalk.red('✗') + ` ${text}`);
  }

  static spinner(text) {
    return ora({
      text,
      color: 'cyan'
    });
  }

  static async confirm(message, defaultValue = true) {
    const answers = await inquirer.prompt([
      {
        type: 'confirm',
        name: 'confirmed',
        message,
        default: defaultValue
      }
    ]);
    return answers.confirmed;
  }

  static async select(message, choices) {
    const answers = await inquirer.prompt([
      {
        type: 'list',
        name: 'selected',
        message,
        choices
      }
    ]);
    return answers.selected;
  }

  static async input(message, defaultValue = '') {
    const answers = await inquirer.prompt([
      {
        type: 'input',
        name: 'value',
        message,
        default: defaultValue
      }
    ]);
    return answers.value;
  }

  static box(title, lines) {
    console.log('');
    console.log(chalk.cyan('╔' + '═'.repeat(58) + '╗'));
    console.log(chalk.cyan('║') + chalk.bold(` ${title}`.padEnd(58)) + chalk.cyan('║'));
    console.log(chalk.cyan('╠' + '═'.repeat(58) + '╣'));

    lines.forEach(line => {
      // Wrap long lines
      const maxWidth = 56;
      const chunks = [];
      let current = '';

      line.split(' ').forEach(word => {
        if ((current + ' ' + word).length <= maxWidth) {
          current += (current ? ' ' : '') + word;
        } else {
          if (current) chunks.push(current);
          current = word;
        }
      });
      if (current) chunks.push(current);

      chunks.forEach(chunk => {
        console.log(chalk.cyan('║') + ` ${chunk}`.padEnd(58) + chalk.cyan('║'));
      });
    });

    console.log(chalk.cyan('╚' + '═'.repeat(58) + '╝'));
    console.log('');
  }

  static section(title) {
    console.log('');
    console.log(chalk.bold.white(title));
    console.log(chalk.gray('─'.repeat(title.length)));
  }

  static code(command, description) {
    console.log('');
    console.log(chalk.cyan('Command:'), chalk.white(command));
    if (description) {
      console.log(chalk.gray(description));
    }
  }

  static list(items, color = 'white') {
    items.forEach(item => {
      console.log(chalk[color]('  •'), item);
    });
  }

  static newline() {
    console.log('');
  }
}

module.exports = UI;
