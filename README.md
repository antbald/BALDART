# Claude Agent Framework

A comprehensive, reusable framework for coordinating AI agents and human developers in software projects. Provides protocols, agents, commands, and templates for structured, documented, and maintainable development workflows.

## What Is This?

The Claude Agent Framework is a portable system for:

- **Agent Coordination**: Clear protocols (AGENTS.md) defining how AI agents and humans work together
- **AI Agents**: Pre-built specialized agents (coder, code-reviewer, doc-reviewer, etc.)
- **Commands**: Batch orchestration (/new), design reviews, issue analysis
- **Templates**: Backlog cards, PRDs, specs, breaking change checklists
- **Documentation Structure**: Standard layouts for API docs, data models, UI specs

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

### Pre-commit Hooks

- `lint-before-commit.sh.template`: Customizable pre-commit checks

## Installation

### Prerequisites

- Git repository
- Bash shell
- Internet connection (for initial download)

### Quick Start

```bash
# Clone or download the framework
git clone https://github.com/yourusername/claude-agent-framework.git /tmp/framework

# Run installation script
cd /your/project
bash /tmp/framework/install-framework.sh
```

The installer will:

1. Verify environment
2. Download framework via Git subtree
3. Create symlinks for auto-updateable files
4. Copy templates for customization
5. Configure Git aliases (`fw-version`, `fw-update`, `fw-push`)

### What Gets Installed

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

## Usage

### Daily Workflow

1. **Start new feature**:
   ```bash
   # Read protocol
   cat AGENTS.md

   # Create backlog card from template
   cp templates/feature-card.template.yml backlog/FEAT-001.yml

   # Edit card, then implement
   # Framework guides agent coordination automatically
   ```

2. **Batch implementation**:
   ```bash
   # Implement multiple cards
   /new FEAT-001 FEAT-002 FEAT-003

   # Framework orchestrates:
   # - codebase-architect (understand code)
   # - coder (implement)
   # - code-reviewer (review)
   # - doc-reviewer (document)
   # - commit (with proper format)
   ```

### Updating the Framework

```bash
# Check current version
git fw-version

# Update to latest version
git fw-update
# or: ./update-framework.sh

# Script will:
# - Show changelog
# - Preview changes
# - Create backup
# - Update framework
# - Verify symlinks
```

### Contributing Improvements

```bash
# Push your improvements back to the framework
git fw-push
# or: ./push-improvements.sh

# Script will:
# - Review your changes
# - Classify change type (MAJOR/MINOR/PATCH)
# - Guide version update
# - Push to central repository
```

## Customization

### Files You SHOULD Customize

1. **`.claude/hooks/lint-before-commit.sh`**
   - Replace `npm run lint` with your project's lint command
   - Replace `npm run build` with your project's build command
   - Make executable: `chmod +x .claude/hooks/lint-before-commit.sh`

2. **`docs/references/ui-guidelines.template.md`**
   - Define brand colors, typography, spacing
   - Document component patterns
   - Save as `docs/references/ui-guidelines.md`

3. **`docs/references/brand-guidelines.md`**
   - Add logo specifications
   - Define brand voice and tone
   - Document imagery guidelines

4. **`templates/*.yml`**
   - Adapt backlog card template for your project
   - Add project-specific fields

### Files You SHOULD NOT Modify

Files with symlinks auto-update when framework updates:

- `AGENTS.md`
- `agents/`
- `.claude/agents/`
- `.claude/commands/`

If you modify these, your changes will be overwritten on next update.

## Project-Specific Agents

Add custom agents to your project:

```bash
# Create custom agent
cat > .claude/agents/my-custom-agent.md << 'EOF'
---
name: my-custom-agent
description: "Custom agent for my project"
model: opus
color: blue
---

[Agent instructions here]
EOF

# Update registry (optional)
# Add to .claude/agents/REGISTRY.md
```

## Versioning

The framework follows [Semantic Versioning](https://semver.org/):

- **MAJOR** (X.0.0): Breaking changes (incompatible updates)
- **MINOR** (0.X.0): New features (backwards compatible)
- **PATCH** (0.0.X): Bug fixes (backwards compatible)

Check current version:

```bash
cat .framework/VERSION
# or: git fw-version
```

## Architecture

### Git Subtree Strategy

The framework uses Git subtree for bidirectional sync:

- **Pull updates**: `./update-framework.sh` pulls new versions
- **Push improvements**: `./push-improvements.sh` contributes back
- **Local copy**: Framework lives in `.framework/` directory
- **Symlinks**: Auto-updated files link to `.framework/`
- **Copies**: Customizable files copied from `.framework/`

### Why Symlinks?

Symlinks enable:

- Automatic updates when framework updates
- No manual file copying
- Clear separation: framework vs project-specific

### Why Copies?

Copies enable:

- Project-specific customization (hooks, UI guidelines)
- No conflicts with framework updates
- Flexibility for your needs

## Troubleshooting

### "Framework not found" error

```bash
# Reinstall framework
./install-framework.sh
```

### Symlinks broken after update

```bash
# Recreate symlinks
ln -sf .framework/AGENTS.md AGENTS.md
ln -sf .framework/agents agents
ln -sf ../.framework/.claude/agents .claude/agents
ln -sf ../.framework/.claude/commands .claude/commands
```

### Conflits during update

```bash
# See conflicting files
git status

# Choose resolution:
git checkout --ours <file>    # Keep your version
git checkout --theirs <file>  # Use framework version

# Or edit manually and resolve markers (<<<<, ====, >>>>)

# Complete merge
git add <resolved-files>
git commit -m "Resolved framework update conflicts"
```

### Rollback after bad update

```bash
# Find backup tag (created by update-framework.sh)
git tag | grep backup/

# Rollback to backup
git checkout backup/YYYYMMDD-HHMMSS
git checkout -b recovery-branch

# Fix issues, then retry update
./update-framework.sh
```

## License

[Specify your license here]

## Contributing

Contributions welcome! To contribute:

1. Make improvements in your project
2. Test thoroughly
3. Run `./push-improvements.sh`
4. Classify change type (MAJOR/MINOR/PATCH)
5. Update VERSION and CHANGELOG in framework repo
6. Create pull request (if using PR workflow)

## Credits

Created for coordinating AI agents and humans in software development.

## Support

- Documentation: `cat .framework/README.md`
- Changelog: `cat .framework/CHANGELOG.md`
- Issues: [GitHub Issues](https://github.com/yourusername/claude-agent-framework/issues)
