# Agent Protocol (AGENTS.md)

Mandatory coordination rules for all agents (Codex/Claude/humans).
Applies before, during, and after any work in this repo.
If context is limited, follow MUST rules and Routing first.

## Pre-Commit Checks

Always run project-specific lint and build commands before attempting any git commit. Fix all errors before staging files.

Examples (customize for your project):
- Linting: `npm run lint`, `pytest --flake8`, `rubocop`, etc.
- Type checking: `npx tsc --noEmit`, `mypy .`, etc.
- Build: `npm run build`, `cargo build`, `go build`, etc.

## File Navigation

When searching for files, use Glob/Grep to find actual file paths before reading. Never guess file paths based on naming conventions.

## Git Workflow

Before committing, ensure only files related to the current task are staged. Run `git status` and `git diff --staged` to verify. Never bundle unrelated changes into a commit.

## Investigation Guidelines

When investigating whether a feature has been implemented, always check git history (`git log --oneline --all --grep`) and actual source code before claiming it exists or doesn't exist.

## Implementation Completeness

When implementing a backlog card or feature plan, verify ALL items from the plan are wired up and functional before marking complete. Cross-check each acceptance criterion against the actual code.

## Testing Conventions

When tests exist, always run the full test suite after implementation to check for regressions. If a test fails, fix the code — not the test — unless the test itself is wrong. When writing new features with tests, write failing tests first, then implement the minimum code to pass them.

## 2) Priority order & conflict policy

Priority order for conflicts:
- Agent rules: `AGENTS.md`.
- Routing: `agents/index.md`.
- Domain references: `docs/references/*` (data-model, api/, ui-pages, product-scope, project-status).
- Decisions: `docs/decisions/ADR-YYYYMMDD-*.md`.
- Legacy: `archive/project_full_legacy.md`.

Conflict steps (must follow in order):
1. Stop and read both sources.
2. Decide which is newer and update the other.
3. Record the decision in an ADR and the backlog card.

## 3) Repo map (compact)

- `AGENTS.md` (agent rules) + `agents/index.md` (routing).
- `/backlog/*.yml` (required work cards).
- `/docs/references/*` (API, data model, UI routes, status).
- `/docs/decisions/` (ADRs).
- `/templates/` (card/spec templates).
- `/src/` or `/app/` or project-specific source directory (application code).

## 4) Non-negotiables (MUST)

- MUST treat `AGENTS.md` as authoritative for agent rules.
- MUST invoke `codebase-architect` agent (via Task tool) whenever you need to understand codebase structure, existing patterns, or code architecture before planning or implementing changes; do not proceed with planning or implementation without first understanding the existing system through codebase-architect.
- MUST update `docs/references/project-status.md` Active Code Context before work; multiple agents allowed if working on independent areas.
- MUST pick one backlog card (TODO/READY), set `IN_PROGRESS`, and assign yourself before work.
- MUST ask the user which git strategy to use when creating a backlog card and record it in `git_strategy`; if the user requires cloud-agent execution, use a non-main feature branch.
- MUST use worktree isolation for all card implementations (see section 5.2); one worktree per card group (shared `group.parent`) or per standalone card; never work directly on `main`.
- MUST populate the `group` field when creating backlog cards; child cards set `group.parent` and `group.sequence`, epic cards set `group.is_epic: true` and `group.children`.
- MUST NOT work on files/components already claimed by another agent; multiple cards can be IN_PROGRESS if working on independent areas.
- MUST keep backlog tasks/notes/status current and log decisions.
- MUST perform a mandatory clarity analysis before fixing any issue labeled `bug`; confirm that the issue description, proposed correct behavior, and edge cases are unambiguous, document any resolved doubts, and only start fix work once every zone of uncertainty is covered.
- MUST mark missing info as UNKNOWN and ask the user; if blocked, set `BLOCKED` with a blocker.
- MUST mark assumptions as ASSUMED with rationale; add an ADR if permanent.
- MUST NOT make forbidden assumptions: external provider swap, auth provider swap, DB structure change without data model update, external dependency without documentation, API contract change without API reference update.
- MUST keep docs and code in sync; code change without doc update is invalid; doc update without code is incomplete.
- MUST document every implementation or variation (backlog card/spec/docs update referencing the issue/feature) before merging; undocumented code changes are not allowed.
- MUST comment on every GitHub issue when resolving it and apply the `vibe review` label so reviewers know the fix is ready for QA/feedback.
- MUST follow handoff protocol in Active Code Context; receiver acknowledges and sets `IN_PROGRESS`.
- MUST use commit format `[FEAT-XXX] Brief description` or adapt to your project's convention; keep commits small/traceable.
- MUST NOT commit without updated docs or with failing build.
- MUST create complete ADRs (no TODO placeholders) for architectural decisions in backlog cards: provider changes, auth changes, DB schema changes, API contract changes, external dependencies (libraries, services), deployment targets, performance/scalability decisions, data model changes affecting multiple features.
- MUST pre-sync: `git fetch origin`, clean status, confirm branch; use `git pull --ff-only` unless approved.
- MUST get owner approval before force push/reset/branch deletion; create a safety tag `backup/<YYYYMMDD>-<reason>` and note it in the card.
- MUST follow the `git_strategy` specified in the backlog card; if not specified, ask the user before starting work; delete merged branches when instructed.
- MUST use branch-per-card for cloud agents (`codex/<CARD-ID>-<slug>` or `claude/<CARD-ID>-<slug>`), avoid direct cloud work on `main`, and submit PR for review before merge; for local agents use `feat/<CARD-ID>-<slug>` per section 5.2.
- MUST push working branch and keep `main` merge owner-controlled; prune remote branches only when instructed.
- MUST run testing gates before DONE: run tests (if exist), run build, and CI checks on PR; manual validation is REQUIRED for local mode and OPTIONAL for cloud mode.
- MUST create QA issues per test case (labels `qa` + area); when fixed add a fix summary, apply `vibe review`, leave open; open QA issues are the source of truth.
- MUST use exact terminology from `agents/coding-standards.md` if it exists in your project.
- MUST pass pre-commit hooks (linting, type checking, markdown lint, build); bypass (`--no-verify`) only for documented emergencies.
- MUST create ADRs with complete sections (Context, Decision, Rationale, Alternatives, Consequences); no TODO placeholders allowed.
- MUST use API versioning for breaking changes: create new version, deprecate old with appropriate headers, minimum sunset period; see project-specific API migration docs.
- MUST keep `docs/references/project-status.md` under 200 lines; archive detailed work logs to `docs/references/work-history.md`.
- MUST limit Active Code Context to 1 current + 3 recent entries max; use one-line summaries (no file lists).
- MUST archive work entries older than 7 days to `work-history.md`.
- MUST NOT add detailed file lists or multi-line work descriptions to project-status.md; use work-history.md instead.

## 5) Guidelines (SHOULD)

- SHOULD use Routing to load only relevant modules.
- SHOULD update `docs/references/project-status.md` when risks/status change.
- SHOULD review for duplication or drift when updating docs.
- SHOULD set `execution_mode: cloud` in backlog cards handled by cloud agents and claim file ownership using `claimed_paths`.

## 5.1) Execution Modes

- `local`: owner-approved work may run on `main`; manual validation remains mandatory before DONE.
- `cloud`: always use feature branch from `main`, open PR, and rely on CI-first validation; local checks are advisory unless explicitly requested.

## 5.2) Worktree Protocol

Every card implementation uses a dedicated git worktree for isolation. Grouped cards (shared `group.parent`) share ONE worktree; standalone cards get their own.

### Setup
1. Ensure `main` is clean: `git checkout main && git pull`.
2. Create worktree + branch: `git worktree add ../wt/<branch-name> -b <branch-name>`.
3. Install deps in worktree (e.g., `npm install`, `pip install -r requirements.txt`).
4. Verify build in worktree.

### Branch naming
- Grouped cards: `feat/<PARENT-ID>-<slug>` (e.g., `feat/FEAT-0394-onboarding`).
- Standalone cards: `feat/<CARD-ID>-<slug>` (e.g., `feat/BUG-0339-store-switcher`).
- Cloud agents: `claude/<CARD-ID>-<slug>` or `codex/<CARD-ID>-<slug>`.

### Development
- All work happens in the worktree directory, never in the main repo.
- Each card = one commit (`[CARD-ID] description`), all on the same branch.
- Build/test/lint must pass after each card.

### Post-batch merge
1. Push feature branch: `git push -u origin <branch-name>`.
2. Switch to main: `cd <main-repo> && git checkout main && git pull`.
3. Merge: `git merge --no-ff <branch-name>`.
4. If merge conflicts → STOP, report conflicting files, do NOT auto-resolve.
5. Verify: build and test on main.
6. Push: `git push`.

### Cleanup (only after successful merge + verify)
1. `git branch -d <branch-name>` (safe delete, not `-D`).
2. `git push origin --delete <branch-name>`.
3. `git worktree remove ../wt/<branch-name>`.
4. `git worktree prune`.

### Fail-safe rules
- Never use force push.
- Never modify main directly.
- Never delete a branch before a successful merge.
- Never remove a worktree before confirming main is stable.
- Stop execution immediately if any command fails.

## 6) Optional conventions (OPTIONAL)

- OPTIONAL: None defined. Add project-specific conventions as needed.

## 6.1) Deprecated Patterns (DO NOT USE)

- Add project-specific deprecated patterns here as they emerge.
- Example: Legacy authentication patterns, outdated API endpoints, deprecated libraries, etc.

## 7) Routing (If you touch X, read Y)

- **Documentation routing**: See `agents/index.md` for which docs to read/update when touching code.
- **Agent invocation routing**: See `.claude/agents/REGISTRY.md` for which agent to invoke via Task tool (single source of truth for all agent capabilities, categories, and decision tree). When adding or updating agents, update REGISTRY.md.

## 8) Workflow gates (tests/build/deploy)

### Pre-commit lint/build checks (MUST)

Before attempting any `git commit`, MUST run these checks on affected files and fix all errors:

1. Lint check — fix all lint errors (customize command for your project).
2. Type check — fix all type errors if applicable (customize command for your project).
3. Markdown lint — fix all markdown errors if .md files changed (customize command for your project).
4. Build check — must pass (customize command for your project).

Only after all checks pass, proceed with `git add` and `git commit`.
Do NOT rely on pre-commit hooks to catch these — run them explicitly first to avoid failed commit retry cycles.

Note: Use linting tools that scope to staged files only when possible; type checking may need to run on the whole project depending on your language/toolchain.

### Manual testing protocol (MVP)

1. Run test suite when tests exist.
2. Run build command (must pass).
3. Run project and manually test changed flows.
4. Record results in backlog card notes.

QA issue methodology (manual):
- One GitHub issue per test case (atomic scope).
- Labels: `qa` + one macro area (customize area labels for your project).
- When fixed: add fix summary comment, apply `vibe review`, leave open.
- If test passes: leave issue open with a short note.
- If test fails: keep open with details and evidence.
- Open QA issues are the source of truth for unresolved bugs.

## 9) Token budget / truncation policy

### File size thresholds

| Doc Type | Max Lines | Action When Exceeded |
|----------|-----------|---------------------|
| Index files (index.md) | 200 | Split by domain |
| Agent modules (agents/*.md) | 300 | Split into sub-modules |
| Reference docs (docs/references/*) | 400 | Split by topic |
| API docs (docs/references/api/*) | 800 | Split by endpoint group |
| Specs/PRDs (docs/specs/*, docs/prd/*) | 800 | Split into requirements + implementation |
| project-status.md | 200 | Archive to work-history.md |

### When context is truncated

1. Re-read only the specific section needed (use offset/limit).
2. Use index files (`api/index.md`, `ui/index.md`, `agents/index.md`) to navigate — never load all docs at once.
3. Link over duplicate — one source of truth per fact.
4. Prefer tables over prose for structured data.
5. If a file exceeds its threshold by 50%+, create a backlog card to split it.

### Loading priority

When context budget is limited, load in this order:
1. `AGENTS.md` (rules — always first)
2. `agents/index.md` (routing)
3. Relevant domain module only (not all modules)
4. `docs/references/project-status.md` (if status context needed)

## 10) Change protocol (updating this file)

1. Open/update a backlog card for doc changes.
2. Update the relevant module(s) first.
3. Update `docs/references/project-status.md` if status or risks change.
4. Add an ADR for architectural decisions.
5. Review for duplication or drift.
