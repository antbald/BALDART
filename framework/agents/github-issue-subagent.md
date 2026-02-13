# GitHub Issue Workflow

## Purpose

Define how to create, update, and manage GitHub issues.

## Scope

**In**: Issue creation, labeling, status tracking, resolution workflow.
**Out**: Project management (see agents/workflows.md).

## Do

- Create issues for bugs, features, and tasks
- Use clear, descriptive titles
- Add appropriate labels
- Link to related PRs/issues
- Update status regularly

## Do Not

- Close issues prematurely
- Skip reproduction steps for bugs
- Use vague titles

## Issue Types

### Bug Report

**Title format**: `[BUG] Brief description of the issue`

**Template**:

```markdown
## Description
[Clear description of the bug]

## Steps to Reproduce
1. [Step 1]
2. [Step 2]
3. [Step 3]

## Expected Behavior
[What should happen]

## Actual Behavior
[What actually happens]

## Environment
- OS: [e.g., macOS 13.0]
- Browser: [e.g., Chrome 120]
- Version: [e.g., 1.2.3]

## Screenshots/Logs
[If applicable]

## Additional Context
[Any other relevant information]
```

### Feature Request

**Title format**: `[FEATURE] Brief description of the feature`

**Template**:

```markdown
## Problem Statement
[What problem does this solve?]

## Proposed Solution
[How should it work?]

## Alternatives Considered
[Other approaches considered]

## Additional Context
[Any other relevant information]
```

### Task

**Title format**: `[TASK] Brief description of the task`

**Template**:

```markdown
## Description
[What needs to be done?]

## Acceptance Criteria
- [ ] [Criterion 1]
- [ ] [Criterion 2]
- [ ] [Criterion 3]

## Related Issues/PRs
[Links to related items]
```

## Labels

### Type Labels

- `bug`: Something isn't working
- `feature`: New feature request
- `enhancement`: Improvement to existing feature
- `documentation`: Documentation updates
- `refactor`: Code refactoring
- `test`: Test-related changes

### Priority Labels

- `priority: critical`: Requires immediate attention
- `priority: high`: Important, address soon
- `priority: medium`: Normal priority
- `priority: low`: Nice to have

### Status Labels

- `status: todo`: Not started
- `status: in-progress`: Being worked on
- `status: blocked`: Blocked by another issue
- `status: review`: Ready for review
- `status: done`: Completed

### Area Labels

- `area: frontend`: Frontend code
- `area: backend`: Backend code
- `area: api`: API changes
- `area: database`: Database changes
- `area: devops`: DevOps/infrastructure

### Special Labels

- `good first issue`: Good for newcomers
- `help wanted`: Looking for contributors
- `vibe review`: Fixed, needs user verification
- `qa`: QA/testing issue
- `wontfix`: Will not be fixed
- `duplicate`: Duplicate of another issue

## Issue Workflow

### 1. Creation

- Use appropriate template
- Fill in all sections
- Add relevant labels
- Assign if known

### 2. Triage

- Review new issues
- Add/update labels
- Set priority
- Assign to milestone if applicable

### 3. Development

- Link issue in commit: `Fixes #123`
- Link issue in PR description
- Update issue with progress
- Add `status: in-progress` label

### 4. Review

- Reference issue in PR
- Wait for CI/CD checks
- Get approval
- Merge PR

### 5. Verification

- Add `vibe review` label
- Leave issue open
- User/QA verifies fix
- Add verification comment
- Only close after verification

## Issue Resolution

### For Bug Fixes

1. Implement fix
2. Add tests
3. Create PR referencing issue
4. Merge PR
5. Add `vibe review` label
6. Leave issue open
7. Verify in production
8. Add verification comment
9. Leave open for tracking

### For Features

1. Implement feature
2. Add tests and docs
3. Create PR referencing issue
4. Merge PR
5. Deploy to production
6. Update issue with deployment info
7. Can close after successful deployment

## Linking Issues and PRs

### In Commit Messages

```bash
git commit -m "Fix login bug

Fixes #123
Closes #456"
```

### In PR Descriptions

```markdown
## Description
[PR description]

## Related Issues
Fixes #123
Relates to #456
Blocks #789
```

## Issue Search

Use GitHub search to find issues:

- `is:open is:issue label:bug` - Open bugs
- `is:closed is:issue label:feature` - Closed features
- `is:issue author:@me` - Your issues
- `is:issue assignee:@me` - Assigned to you

## Issue Templates

Create `.github/ISSUE_TEMPLATE/` directory with:

- `bug_report.md`
- `feature_request.md`
- `task.md`

## Automation

Consider GitHub Actions for:

- Auto-labeling based on title
- Stale issue management
- PR/issue linking validation
- Automatic milestone assignment
