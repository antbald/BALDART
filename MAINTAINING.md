# BALDART Framework Maintenance Protocol

This document defines the protocol for maintaining and versioning the BALDART framework. **ALL agents** (Claude, Codex, humans) must follow this protocol when making improvements to the framework.

## Table of Contents

1. [Version Management](#version-management)
2. [Making Improvements](#making-improvements)
3. [Classifying Changes](#classifying-changes)
4. [Release Process](#release-process)
5. [Testing Changes](#testing-changes)
6. [Documentation Requirements](#documentation-requirements)

---

## Version Management

### Current Version

The current framework version is stored in the VERSION file at the repository root.

Check current version: cat VERSION

### Semantic Versioning

BALDART follows Semantic Versioning 2.0.0 (https://semver.org/):

Format: MAJOR.MINOR.PATCH

- MAJOR (X.0.0): Breaking changes
  - Incompatible API updates
  - Directory structure changes
  - Removed agents or commands
  - Changed installation process
  - Incompatible protocol changes

- MINOR (0.X.0): New features (backwards compatible)
  - New agents
  - New commands
  - New modules
  - New templates
  - Enhanced functionality

- PATCH (0.0.X): Bug fixes (backwards compatible)
  - Documentation fixes
  - Script improvements
  - Bug fixes
  - Security patches

---

## Making Improvements

### Workflow for Framework Improvements

1. Work in a Project Using the Framework

Make improvements while working on real projects. The best framework improvements come from actual usage.

2. Document the Improvement

Before pushing, document:
- What problem does this solve?
- What changes were made?
- Is this backwards compatible?

3. Use the Push Command

Run: npx baldart push

This will:
- Show you what changed
- Ask you to classify the change type (MAJOR/MINOR/PATCH)
- Push changes to the framework repository
- Guide you through version bump and changelog update

4. Version Bump (Required After Push)

After npx baldart push completes, navigate to framework repo and:
- Edit VERSION file (bump according to change type)
- Update CHANGELOG.md
- Commit version bump
- Create git tag
- Push main + tag

---

## Classifying Changes

### Decision Tree

Did you remove or break existing functionality?
- YES → MAJOR
- NO → Did you add new functionality?
  - YES → MINOR
  - NO → PATCH

### Examples by Type

MAJOR (Breaking Changes):
- Removed an agent
- Changed directory structure
- Changed installation command
- Removed a command
- Changed API contracts
- Changed required dependencies

MINOR (New Features):
- Added a new agent
- Added a new command
- Added a new module
- Enhanced existing agent with new capabilities
- Added new template
- Added new utility functions

PATCH (Bug Fixes):
- Fixed typos in documentation
- Fixed script bugs
- Improved error messages
- Security patches
- Performance improvements (non-breaking)
- Clarified documentation

---

## Release Process

### Complete Release Checklist

When you have pushed improvements, follow this checklist:

Step 1: Push Improvements
  npx baldart push
  Follow prompts, classify change type

Step 2: Update VERSION File
  cd /path/to/BALDART
  nano VERSION
  Update version number according to change type

Step 3: Update CHANGELOG.md
  Add entry under [Unreleased] section with your changes

Step 4: Move Unreleased to Version
  Move changes from [Unreleased] to new version section

Step 5: Commit Version Bump
  git add VERSION CHANGELOG.md
  git commit -m "chore: bump version to X.Y.Z"

Step 6: Create Git Tag
  git tag -a vX.Y.Z -m "Release vX.Y.Z"

Step 7: Push Everything
  git push origin main
  git push origin vX.Y.Z

Step 8: Verify Release
  cat VERSION
  git tag | grep vX.Y.Z
  head -n 30 CHANGELOG.md

---

## Testing Changes

### Before Pushing Improvements

Test in a Real Project:

1. Install framework in test project
2. Verify installation (npx baldart status, npx baldart version)
3. Test the improvement
4. Test update process
5. Verify no breakage

---

## Documentation Requirements

### Required Documentation Updates

When making framework changes, you MUST update documentation:

For New Agents:
- Add agent file to framework/.claude/agents/
- Update README.md agent count
- Add to CHANGELOG.md under Added

For New Commands:
- Add command file to framework/.claude/commands/
- Update README.md commands section
- Add to CHANGELOG.md under Added

For New Modules:
- Add module file to framework/agents/
- Update framework/agents/index.md routing
- Add to CHANGELOG.md under Added

For Breaking Changes:
- Document migration path in CHANGELOG.md
- Update README.md with new instructions
- Add warning in commit message
- Consider adding migration guide

For Bug Fixes:
- Document what was fixed in CHANGELOG.md
- Update relevant documentation if needed

---

## Emergency Rollback

### If Something Goes Wrong

1. Find the Last Good Version:
   git tag

2. Rollback:
   git checkout vX.Y.Z
   git checkout -b rollback-from-vA.B.C

3. Create Rollback Release with bumped version and documentation

---

## Agent Protocol Summary

### Quick Reference for Agents

When working on framework improvements:

1. Make improvements in a real project
2. Test thoroughly before pushing
3. Run npx baldart push
4. Classify change type (MAJOR/MINOR/PATCH)
5. Update VERSION file
6. Update CHANGELOG.md
7. Commit version bump
8. Create git tag
9. Push main + tag
10. Verify release

### Files to Check After Every Change

- VERSION - Must be bumped
- CHANGELOG.md - Must have new entry
- README.md - Update if user-facing changes
- Documentation - Update if behavior changes

---

## Questions?

If you are an agent and uncertain about:
- How to classify a change → Use the decision tree
- What version to use → Check VERSION file and bump appropriately
- How to document → Follow CHANGELOG format
- Testing requirements → Test in real project first

If still uncertain, create an issue in the repository for clarification.
