# BALDART - Claude Agent Framework

A comprehensive, reusable framework for coordinating AI agents and human developers in software projects. Install via npm/npx - no bash scripts needed.

## What Is This?

BALDART provides a portable system for:

- **Agent Coordination**: Clear protocols (AGENTS.md) defining how AI agents and humans work together
- **AI Agents**: Pre-built specialized agents (coder, code-reviewer, doc-reviewer, etc.)
- **Commands**: Batch orchestration (/new), design reviews, issue analysis
- **Templates**: Backlog cards, PRDs, specs, breaking change checklists
- **Documentation Structure**: Standard layouts for API docs, data models, UI specs

## Quick Start

### Installation

```bash
# In your project directory
npx baldart add
```

That's it! The framework is installed via Git subtree, symlinks created, and you're ready to go.

### Usage

```bash
# Show version
npx baldart version

# Check status
npx baldart status

# Update framework
npx baldart update

# Contribute improvements
npx baldart push
```

## Features

### Core Protocol

- **AGENTS.md**: Mandatory coordination rules (MUST/SHOULD/OPTIONAL)
- **agents/**: 17 domain modules (architecture, workflows, testing, security, etc.)
- **Routing**: If you touch X, read Y - minimize context loading

### AI Agents (9 generic agents)

1. **codebase-architect**: MANDATORY before planning/implementation - understands codebase structure
2. **coder**: Writes production code with build/test/lint verification
3. **code-reviewer**: Reviews for bugs, security, quality, maintainability
4. **doc-reviewer**: Audits and writes documentation
5. **prd**: Creates Product Requirement Documents and backlog cards
6. **plan-auditor**: MANDATORY after planning - rigorous plan review before coding
7. **senior-researcher**: Technology comparisons and evidence-based decisions
8. **api-perf-cost-auditor**: API performance and cost analysis

### Commands

- **/new**: Batch orchestrator for backlog cards (codebase-architect → coder → code-reviewer → doc-reviewer → commit)
- **/design-review**: UI/UX design review workflow
- **/issue-review**: GitHub issue analysis and context capture

### Templates

- `feature-card.template.yml`: Backlog card structure
- `spec.template.md`: Technical specifications
- `breaking-change-checklist.md`: API/schema migration checklist
- `ui-guidelines.template.md`: UI/UX guidelines template
- `brand-guidelines.md`: Brand identity template

## What Gets Installed

```
your-project/
├── .framework/              # Framework source (via Git subtree)
├── AGENTS.md               # Symlink → .framework/AGENTS.md
├── agents/                  # Symlink → .framework/agents/
├── .claude/
│   ├── agents/             # Symlink → .framework/.claude/agents/
│   ├── commands/           # Symlink → .framework/.claude/commands/
│   └── hooks/              # Customizable copies
├── docs/references/
│   ├── ui-guidelines.template.md    # Customize for your project
│   └── brand-guidelines.md          # Customize for your project
└── templates/               # Customizable backlog/spec templates
```

## Daily Workflow

### 1. Create Backlog Card

```bash
# Copy template
cp templates/feature-card.template.yml backlog/FEAT-001.yml

# Edit card with your requirements
```

### 2. Implement with Framework

```bash
# Framework guides agent coordination automatically
# Use /new command for batch implementation
/new FEAT-001
```

### 3. Update Framework

```bash
# Check for updates
npx baldart status

# Update to latest
npx baldart update
```

### 4. Contribute Back

```bash
# Made improvements? Share them!
npx baldart push
```

## Customization

### Files You SHOULD Customize

1. **`.claude/hooks/lint-before-commit.sh.template`**
   - Replace commands with your project's tools
   - Rename to `lint-before-commit.sh`
   - Make executable: `chmod +x .claude/hooks/lint-before-commit.sh`

2. **`docs/references/ui-guidelines.template.md`**
   - Define brand colors, typography, spacing
   - Document component patterns
   - Rename to `ui-guidelines.md`

3. **`docs/references/brand-guidelines.md`**
   - Add logo specifications
   - Define brand voice and tone
   - Document imagery guidelines

4. **`templates/*.yml`**
   - Adapt backlog card template
   - Add project-specific fields

### Files You SHOULD NOT Modify

Files with symlinks auto-update when framework updates:

- `AGENTS.md`
- `agents/`
- `.claude/agents/`
- `.claude/commands/`

## Commands Reference

### `npx baldart add [repo]`

Install framework in your project.

- `repo`: Optional. Default: `antbald/BALDART`
- `--branch`: Branch to use. Default: `main`

**Example:**
```bash
npx baldart add              # Install from default repo
npx baldart add owner/repo   # Install from custom repo
```

### `npx baldart update`

Update framework to latest version.

- Shows changelog
- Creates backup tag
- Updates via Git subtree
- Verifies symlinks

### `npx baldart push`

Contribute improvements back to framework.

- Reviews your changes
- Classifies change type (MAJOR/MINOR/PATCH)
- Pushes via Git subtree
- Guides VERSION/CHANGELOG update

### `npx baldart version`

Show installed framework version.

### `npx baldart status`

Check installation status:
- Framework version
- Symlink validity
- Customizable files presence
- Update availability

## Architecture

### Git Subtree Strategy

BALDART uses Git subtree for bidirectional sync:

- **Pull updates**: `npx baldart update` pulls new versions
- **Push improvements**: `npx baldart push` contributes back
- **Local copy**: Framework lives in `.framework/` directory
- **Symlinks**: Auto-updated files link to `.framework/`
- **Copies**: Customizable files copied from `.framework/`

### Why NPX?

- **No global install**: Use latest version every time
- **Cross-platform**: Works on Windows/Mac/Linux
- **Standard**: Familiar to all Node.js developers
- **Simple**: One command to rule them all

## Versioning

BALDART follows [Semantic Versioning](https://semver.org/):

- **MAJOR** (X.0.0): Breaking changes (incompatible updates)
- **MINOR** (0.X.0): New features (backwards compatible)
- **PATCH** (0.0.X): Bug fixes (backwards compatible)

Check version:
```bash
npx baldart version
```

## Troubleshooting

### "Framework not installed" error

```bash
# Install framework first
npx baldart add
```

### Symlinks broken after update

```bash
# Reinstall to recreate symlinks
npx baldart add
```

### Conflicts during update

```bash
# Check conflicting files
git status

# Choose resolution
git checkout --ours <file>    # Keep your version
git checkout --theirs <file>  # Use framework version

# Complete merge
git add <resolved-files>
git commit -m "Resolved framework update conflicts"
```

### Rollback after bad update

```bash
# Find backup tag (created by update)
git tag | grep backup/

# Rollback
git checkout backup/YYYY-MM-DD-HH-MM-SS
git checkout -b recovery-branch
```

## Requirements

- **Node.js**: >= 18.0.0
- **Git**: >= 2.0.0
- **npm**: >= 8.0.0

## License

MIT

## Contributing

Contributions welcome!

1. Make improvements in your project
2. Test thoroughly
3. Run `npx baldart push`
4. Classify change type (MAJOR/MINOR/PATCH)
5. Update VERSION and CHANGELOG in framework repo

## Repository

- **GitHub**: https://github.com/antbald/BALDART
- **npm**: `baldart` (publishing soon)
- **Issues**: https://github.com/antbald/BALDART/issues

## Credits

Created for coordinating AI agents and humans in software development.

## Support

- **Documentation**: `cat .framework/README.md`
- **Changelog**: `cat .framework/CHANGELOG.md`
- **Status**: `npx baldart status`
- **Version**: `npx baldart version`
