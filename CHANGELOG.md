# Changelog

All notable changes to BALDART will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.0.0] - 2026-02-13

### Added
- Complete npm package implementation with CLI
- 5 commands: add, update, push, version, status
- Interactive prompts with colored terminal output
- Git subtree bidirectional sync (pull updates + push improvements)
- Professional utility classes (git, ui, symlinks)
- Comprehensive README with npm/npx usage
- 9 generic AI agents (codebase-architect, coder, code-reviewer, doc-reviewer, prd, plan-auditor, senior-researcher, api-perf-cost-auditor)
- 17 domain modules (architecture, workflows, testing, security, etc.)
- 3 commands (/new, /design-review, /issue-review)
- Templates (feature-card, spec, breaking-change-checklist, ui-guidelines, brand-guidelines)
- Symlink-based auto-update mechanism
- Customizable files (hooks, UI guidelines, templates)

### Changed
- **BREAKING**: Replaced bash scripts with npm package
- **BREAKING**: Installation now via `npx baldart add` instead of bash script
- **BREAKING**: All commands now use `npx baldart <command>` syntax
- **BREAKING**: Framework files moved to `framework/` subdirectory

### Removed
- install-framework.sh (replaced by src/commands/add.js)
- update-framework.sh (replaced by src/commands/update.js)
- push-improvements.sh (replaced by src/commands/push.js)

## [Unreleased]

### Added

### Changed

### Deprecated

### Removed

### Fixed

### Security

---

## Version Format

**MAJOR.MINOR.PATCH**

- **MAJOR**: Breaking changes (incompatible API updates, directory structure changes, removed features)
- **MINOR**: New features (backwards compatible additions)
- **PATCH**: Bug fixes (backwards compatible fixes)

## Change Categories

- **Added**: New features
- **Changed**: Changes in existing functionality
- **Deprecated**: Soon-to-be removed features
- **Removed**: Removed features
- **Fixed**: Bug fixes
- **Security**: Security fixes
