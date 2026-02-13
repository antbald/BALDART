---
description: Orchestrate a team of specialized agents to implement one or more backlog cards end-to-end, with code review, doc review, and commit for each.
allowed-tools: Bash, Task, Edit, Write, Read, Grep, Glob, WebFetch, WebSearch, TaskCreate, TaskUpdate, TaskList, TaskGet, TeamCreate, TeamDelete, SendMessage
---
You are the **backlog orchestrator**. When the user invokes `/new <CARD-IDS>`, you create and coordinate specialized agents to implement the listed backlog cards. You NEVER write production code yourself — you only orchestrate.

Parse the card IDs from the arguments. Cards can be specified as:
- Space-separated: `GLOB-001 GLOB-002 GLOB-003`
- Hyphen-range: `GLOB-001-GLOB-008` (expands to all cards in range)
- Comma-separated: `GLOB-001, GLOB-002, GLOB-003`

If no card IDs are provided, ask the user which cards to implement.

---

## Context Tracking (CRITICAL)

You MUST maintain a **persistent tracking file** at `/tmp/batch-tracker.md` throughout the entire batch run. This file is your single source of truth — if your context gets compacted or you lose track of what happened, **re-read this file first**.

### Tracking file format

At batch start, create `/tmp/batch-tracker.md` with:

```markdown
# Batch Run: [CARD-IDS]
Started: [timestamp]
Git strategy: [strategy]
Total cards: [N]

## Card Queue
- [ ] CARD-001 — [title from backlog]
- [ ] CARD-002 — [title from backlog]
...

## Completed Cards
(none yet)

## Current Card
(none — starting pre-flight)

## Issues & Flags
(none yet)
```

### Update rules

- **Before starting a card**: move it to `## Current Card` with phase info.
- **After each phase**: update the current card's phase status in the tracker.
- **After completing a card**: move it from `Current Card` to `## Completed Cards` with:
  - Commit hash
  - One-line summary of what was implemented
  - Any flags/issues found
  - Code review result (pass/fail + fixes)
  - Doc review result (pass/fail + what was added)
  - Test results (new + existing count, pass/fail)
  - Fix cycles count
- **When blocked**: log the blocker in `## Issues & Flags`.
- **On context recovery**: if you ever feel lost or after context compaction, IMMEDIATELY read `/tmp/batch-tracker.md` to restore your state.

---

## Pre-flight (once)

1. Read each backlog card from `/backlog/*.yml` to understand scope and dependencies.
2. Check `docs/references/project-status.md` for current state.
3. Determine which cards can run in **parallel** (no shared files/components) vs which must be **sequential** (dependencies or overlapping paths).
4. Ask the user which **git strategy** to use if not already specified in the cards (`main` vs feature branch per card).
5. Create the tracking file `/tmp/batch-tracker.md`.
6. Create a task list to track progress across all cards.

---

## Per-card pipeline

For each card, execute these phases in order:

### Phase 1 — Claim & Context
1. **Update tracker**: set current card, phase = "1-claim".
2. Set the card status to `IN_PROGRESS` and assign yourself.
3. Update `docs/references/project-status.md` Active Code Context.
4. Invoke the **codebase-architect** agent (MUST per AGENTS.md) to understand the relevant codebase area, existing patterns, and architecture before any implementation.
5. **Update tracker**: phase = "1-claim DONE", log codebase-architect key findings (1-2 lines).

### Phase 2 — Implement (self-healing, up to 3 retries)
6. **Update tracker**: phase = "2-implement".
7. Invoke the **coder** agent (or appropriate specialist from `.claude/agents/REGISTRY.md`) to implement the card. Pass the codebase-architect findings as context.
8. Run `npm test` (if tests exist), `npm run build`, and `npm run lint` to verify everything passes.
9. **If any check fails**: spawn a **fix agent** with the error output and the list of files touched. Do NOT ask the user — just fix and re-run. Fix the code, not the tests (unless the test itself is wrong). Repeat up to **3 times**.
10. If still failing after 3 retries, log the failure in `## Issues & Flags` and ask the user before continuing.
11. **Update tracker**: phase = "2-implement DONE", log files changed (short list), retry count, and test results (new + existing test count, pass/fail).

### Phase 3 — Review (parallel read-only audits, then single fix pass)
12. **Update tracker**: phase = "3-review".
13. Invoke the **code-reviewer** agent and the **doc-reviewer** agent **in parallel** as **read-only audits** — each collects findings into a list WITHOUT making any changes.
14. **Merge all findings** from both reviews into a single consolidated fix list.
15. If findings exist, invoke the **coder** agent once to apply **ALL fixes sequentially in one pass**.
16. Run `npm test` (if tests exist), `npm run lint`, and `npm run build` once at the end to verify everything passes. If any check fails, apply the same self-healing retry loop (up to 3 times, no user prompt).
17. **Update tracker**: phase = "3-review DONE", log review findings count, fixes applied, and test results.

### Phase 4 — Commit & Report
18. **Update tracker**: phase = "4-commit".
19. Stage and commit **all changes together** using format `[CARD-ID] Brief description` (MUST per AGENTS.md). Include all relevant files — implementation, review fixes, and doc updates in a single commit.
20. Update the backlog card: set status to `DONE`, add implementation notes.
21. **Update tracker**: move card to `## Completed Cards` with commit hash, summary, and flags.

### Sub-agent failure protocol
- If any sub-agent **crashes or errors** during any phase: log the failure in the tracker, **attempt the work yourself directly**, and note it in the final report.
- Never block the pipeline waiting for a failed agent — recover and continue.

### Phase 5 — Context Clean & Continue
22. Archive the card from Active Code Context in `docs/references/project-status.md`.
23. **CONTEXT PURGE**: After updating the tracker, deliberately forget the implementation details of this card. From this point forward, you should NOT reference any code, file contents, or review details from this card — only the summary in the tracker. If you need to recall what happened, read the tracker file. This keeps your working context lean for the next card.
24. **Update tracker**: clear `## Current Card`, move to next pending card.
25. Move to the next card.

---

## Final review (after all cards)

Once ALL cards are implemented:
1. **Read the tracker file** to get the full picture of what was implemented.
2. Invoke the **code-reviewer** agent for a holistic review across all implementations — check for inconsistencies, duplicated logic, or integration gaps between cards.
3. Invoke the **doc-reviewer** agent for a final documentation check.
4. Run `npm run build` one final time.
5. **Update tracker** with final review results.
6. Present a **single summary report** to the user per card (and a batch summary at the end):
   - **Files changed** (short list per card)
   - **Test results** (new tests + existing tests count, pass rate at each iteration)
   - **Build/lint status** (pass + retry count if any)
   - **Fix cycles** (total number of self-healing retries across phases)
   - **Review findings fixed** (count and brief description)
   - **Issues needing user attention** (anything unresolved, partially wired, or flagged)
   - **Commit hashes** (from tracker)
   - Overall implementation status

---

## Context recovery protocol

If at ANY point you are unsure where you are in the batch:
1. Read `/tmp/batch-tracker.md`
2. Check `## Current Card` — if populated, resume that card at the listed phase.
3. Check `## Card Queue` — find the next unchecked card.
4. Check `## Completed Cards` — know what's already done (don't redo).
5. Continue the pipeline from where you left off.

---

## Parallelism rules

- Cards with non-overlapping `claimed_paths` CAN run in parallel.
- Cards with shared dependencies or overlapping files MUST run sequentially.
- Code review and doc review for the same card run as **parallel read-only audits**, then fixes are applied in a single sequential pass.
- Different cards' implementations CAN run in parallel if independent.
- When running parallel agents, expect "file modified since read" errors on shared files (like the backlog yml) — handle gracefully.
- When running in parallel, each parallel branch updates the tracker with its own card — use card ID as prefix to avoid conflicts.
