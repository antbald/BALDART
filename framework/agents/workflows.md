# Workflows

## Purpose

Define how agents plan, track, and complete work safely.

## Scope

**In**: Backlog workflow, Active Code Context, handoffs, conflict resolution, commits.
**Out**: Testing specifics (see agents/testing.md).

## Do

- Work from a single backlog card at a time.
- Keep Active Code Context updated before and after changes.

## Do Not

- Start work without a card or without setting context.

## Violations (Invalid Work)

- Code change without doc update is invalid.
- Doc update without code implementation is incomplete.
- Work without a backlog card is unauthorized.

## Backlog Workflow

1. List cards in `/backlog/*.yml`.
2. Select one card with status `TODO` or `READY`.
3. Set card to `IN_PROGRESS`, assign yourself, and set `execution_mode` (`local` or `cloud`).
4. Claim ownership for touched areas via `claimed_paths` in the card.
5. Update `docs/references/project-status.md` -> Active Code Context.

## During Work

- Update card tasks and notes as you go.
- Record unknowns and assumptions in the card.
- Do not touch files claimed by another in-progress card.

## Finish Work

1. Verify Definition of Done in the card.
2. Set status to `DONE` (or `BLOCKED`).
3. Update `docs/references/project-status.md` (Current Status, Known Issues, Active Code Context).
4. Add ADRs for architectural decisions.

## Status Tracking

- Valid statuses: `TODO`, `READY`, `IN_PROGRESS`, `BLOCKED`, `DONE`.
- `IN_PROGRESS` requires Active Code Context set.
- `BLOCKED` requires blocker documented in card and status file.

## Deploys and Publications

- Production deploys and publications must follow `agents/deployment-protocol.md` if it exists.
- Treat deploy work as backlog-driven work with full testing gates and documented rollback intent.

## Handoff Protocol

Use Active Code Context format from `docs/references/project-status.md` and set Status to `HANDOFF_READY`.
Record `handoff.from`, `handoff.to`, `handoff.summary`, and `handoff.next_steps` in the card.
The receiver must acknowledge, keep claims aligned, and set `IN_PROGRESS`.

## Unknowns and Assumptions

- Missing info: mark UNKNOWN in the backlog card and ask the user.
- Assumptions: mark ASSUMED with rationale, and add an ADR if permanent.

## Forbidden Assumptions

- Switching external providers without ADR.
- Switching Auth providers without ADR.
- Changing database structure without updating data model reference.
- Adding external dependencies without documentation.
- Changing API contracts without updating API reference.

## Conflict Resolution

1. Stop if docs conflict with code.
2. Determine which is newer and update the other.
3. Record the resolution in an ADR.

## Commit Hygiene

- Commit format: `[FEAT-XXX] Brief description` or adapt to your project convention.
- Keep commits small and traceable.
- Do not commit without updated docs.

Example:
```
[FEAT-001] Add user management endpoints

- Created /api/users endpoints (GET, POST, PATCH, DELETE)
- Updated docs/references/data-model.md
- Added users to seed script
```

## Pre-commit Hooks (Automated Quality Gates)

**What Runs**: Every commit should trigger automated checks via git hooks (e.g., Husky + lint-staged):

1. **Linting**: Auto-fix + zero-warnings on staged files
2. **Type Checking**: Type-check entire project (if applicable)
3. **Format Checking**: Auto-fix formatting on staged files
4. **Fast Build Check**: Quick compilation/type check without full build

**Timing**: Target <10 seconds (optimized for speed)

**Enforcement**: BLOCKING - Commit fails if any check fails

### When Checks Fail

1. **Review the error output** - Pre-commit hooks show exactly what failed
2. **Fix the issue** - Most common:
   - Linting errors: Run your lint command to see full report
   - Type errors: Check file and line number in error output
   - Format errors: Run your format command
   - Build errors: Run your build command for detailed trace
3. **Retry commit** - Hooks run again automatically

### Emergency Bypass (Use Sparingly)

**When to use**:

- Emergency hotfix needed immediately
- External blocker (CI down, registry issues)
- Working on draft/WIP commit that will be amended

**How to bypass**:

```bash
git commit --no-verify -m "[EMERGENCY] Brief reason for bypass"
```

**Rules**:

- Document reason in commit message
- Fix issues in next commit
- Add note to backlog card explaining bypass

**Example valid bypass**:

```bash
git commit --no-verify -m "[EMERGENCY] Hotfix production outage - will fix linting in next commit"
```

**Example invalid bypass**:

```bash
git commit --no-verify -m "wip"  # ❌ No reason, not emergency
```

### Troubleshooting

**Issue**: Hook takes >10 seconds
- **Cause**: Large number of staged files or slow type checking
- **Fix**: Commit smaller batches, or optimize type checking configuration

**Issue**: Hook fails on files that look correct
- **Cause**: Linter/formatter rules are strict
- **Fix**: Follow linter suggestions or configure rules if too strict

**Issue**: Type error in file I didn't touch
- **Cause**: Type checking checks whole project (type dependencies)
- **Fix**: Fix the error or bypass if unrelated to your work (then fix separately)

## Repo State and Branch Hygiene (MUST)

Follow this protocol to prevent local/remote drift.

## Pre-Work Sync

1. Run `git fetch origin`.
2. Run `git status -sb` and verify a clean working tree.
3. Confirm you are on the intended branch.
4. Sync from `origin/main` with fast-forward policy (`git pull --ff-only`) when required by your mode.

## Destructive Operations (Owner Approval Required)

- Force push, reset, or branch deletion requires explicit owner approval and a backlog note.
- Before destructive changes, create a safety tag:
  - `git tag backup/<YYYYMMDD>-<reason>` and note it in the card.

## Branch Policy (Mode-Based)

- `local` mode: may work on `main` only with owner approval.
- `cloud` mode: always create branch-per-card from `main` (`codex/<CARD-ID>-<slug>` or `claude/<CARD-ID>-<slug>`).
- Cloud agents must never commit directly to `main`; PR review + green CI are required before merge.
- Delete merged feature branches only when owner instructs.

## Post-Work Sync

1. Ensure `git status -sb` is clean.
2. Push your working branch and open/update PR with test evidence.
3. Merge to `main` is owner-controlled after approval and CI success.
4. If instructed, prune remote branches.

## Testing Gates (Mode-Based)

- Required for all modes: run tests (if exist), run build, pre-commit hooks, and passing CI checks.
- `local` mode: manual validation is mandatory and must be logged in card notes.
- `cloud` mode: manual validation is advisory unless explicitly requested; prefer CI and automated checks.

## Provider Changes (ADR Required)

- External provider changes.
- Auth provider changes.
- Database changes.
- External API or deployment target changes.

## Emergency Protocols

- If blocked: set card to `BLOCKED`, record blocker, update status file, ask user.
- If context lost: read AGENTS + project-status + your card, then ask for priority.
