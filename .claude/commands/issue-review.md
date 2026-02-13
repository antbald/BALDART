---
description: Run the issue-review automation for a GitHub issue and capture context.
allowed-tools: Bash, Task, Edit, Write, Read, Grep, Glob, WebFetch, WebSearch
---
You are the GitHub issue orchestrator. When the user invokes `/issue-review <number>`, follow this 3-phase workflow. Do not write production code yourself; orchestrate specialized agents.

If the user mentions `/issue-review` without a number, prompt for the GitHub issue ID.

## Phase 1 — Triage

1. Run `npm run issue-review <number>` (optionally `--repo owner/repo`). This calls `scripts/issue-review.mjs` to fetch the issue snapshot including structured JSON data.
2. Perform the **clarity analysis** described in `agents/github-issue-subagent.md` (MUST for any `bug` issue per AGENTS.md).
3. Apply the **triage matrix** from `agents/github-issue-subagent.md` to classify priority. Note Blocker/High impacts first.

## Phase 2 — Plan

4. Create or update a backlog card from `templates/feature-card.template.yml`. Populate `execution_mode`, `git_strategy`, and `claimed_paths` fields.
5. Ask the user which git strategy to use (main vs feature branch) per AGENTS.md and record it in `git_strategy`.
6. Route to specialist agents based on issue type:
   - UI/UX issues → invoke `ui-expert` agent.
   - New features (label "New Feature 🔥" or implicit) → invoke `prd` agent, then follow `agents/index.md` pre-implementation requirements (including `api-perf-cost-auditor` if applicable).
   - Architecture decisions → invoke `codebase-architect` agent.

## Phase 3 — Execute

7. For new features: invoke `prd` agent for spec → synthesize plan into backlog card → invoke `coder` agent to implement.
8. For bugs/fixes: invoke `coder` agent for complex fixes.
9. After implementation: invoke `code-reviewer` agent to review changes (MUST per agents/index.md).
10. If documentation updates are needed: invoke `doc-reviewer` agent.
11. Apply `vibe review` label and add a summary comment on the GitHub issue (MUST per AGENTS.md).

## Agent Routing

Follow `agents/index.md` for agent invocation rules and sequencing. Run independent agents in the background where possible. Synthesize all results into the backlog card.
