# Agents Index

## Purpose

Route agents to the right module with minimal reading.

## Routing Rules

### Documentation Routing

- If needing to understand codebase structure, existing patterns, or architecture before planning -> MUST invoke `codebase-architect` agent (via Task tool) first; do not proceed without architectural understanding.
- If touching API endpoints or request/response shape -> read `agents/api-contracts.md` and `docs/references/api/index.md` (then specific API module for your domain).
- If touching database schema or fields -> read `agents/data-model.md` and `docs/references/data-model.md`.
- If touching UI pages/routes or flows -> read `docs/references/ui/index.md` (then specific UI module for your domain).
- If touching design-review workflows or UI guidelines -> read `agents/design-review.md` and project-specific UI guidelines.
- If touching architecture, auth, or tech stack -> read `agents/architecture.md`.
- If touching workflow/process/commits/backlog -> read `agents/workflows.md`.
- If touching testing or QA issues -> read `agents/testing.md`.
- If touching GitHub issues or issue workflow -> read `agents/github-issue-subagent.md`.
- If touching terminology or naming -> read `agents/coding-standards.md`.
- If touching env vars or scripts -> read `agents/runbook.md` and `agents/env-reference.md`.
- If touching operational procedures (backup, cleanup, secrets) -> read `docs/operations/` if it exists in your project.
- If touching security or auth risk -> read `agents/security.md`.
- If touching performance limits or scaling -> read `agents/performance.md`.
- If touching monitoring/logging -> read `agents/observability.md`.
- For day-to-day status -> read and update `docs/references/project-status.md`.
- For legacy context -> read `archive/project_full_legacy.md` if it exists.

### Agent Invocation Routing (via Task tool)

**Single source of truth**: See [`.claude/agents/REGISTRY.md`](../.claude/agents/REGISTRY.md) for the full agent map, decision tree, capabilities, and tool access.

When adding or updating agents, update REGISTRY.md — not this file.

## Modules

- `agents/architecture.md`
- `agents/coding-standards.md`
- `agents/workflows.md`
- `agents/testing.md`
- `agents/security.md`
- `agents/performance.md`
- `agents/observability.md`
- `agents/api-contracts.md`
- `agents/data-model.md`
- `agents/runbook.md`
- `agents/env-reference.md`
- `agents/maintenance-protocol.md`
- `agents/github-issue-subagent.md`
- `agents/design-review.md`
- `agents/skills-mapping.md`

## Where to Document (Decision Tree)

Use these flowcharts to determine where documentation changes belong.

### Code Change Documentation

When you make a code change, follow this decision tree:

```
START: You made a code change
  |
  v
Is it an API endpoint change?
  |-- YES --> Update docs/references/api/{module}.md
  |            (Organize API docs by domain/feature)
  |
  v
Is it a database schema change?
  |-- YES --> Update docs/references/data-model.md
  |            + Create ADR if structural
  |
  v
Is it a UI page/route change?
  |-- YES --> Update docs/references/ui/{domain}.md (see ui/index.md)
  |
  v
Is it an architectural decision?
  |-- YES --> Create ADR in docs/decisions/
  |            + Update agents/architecture.md if persistent
  |
  v
Is it a security-related change?
  |-- YES --> Update agents/security.md
  |            + Create ADR if policy change
  |
  v
Is it a workflow/process change?
  |-- YES --> Update agents/workflows.md
  |
  v
Does it affect project status?
  |-- YES --> Update docs/references/project-status.md
  |
  v
DONE: Commit with docs updated
```

### API Module Routing

When documenting an API endpoint, select the correct module based on your project's domain structure:

```
START: New or modified API endpoint
  |
  v
Identify the domain/feature area
  |
  v
Does a module exist for this domain?
  |-- YES --> Update that module (e.g., auth.md, users.md, products.md)
  |-- NO --> Create new module or add to closest existing module
  |
  v
Update docs/references/api/index.md with module reference
  |
  v
DONE: Document endpoint following project standards
```

### Documentation-Only Changes

When you need to update documentation without code changes:

```
START: Documentation update needed
  |
  v
Is it fixing a typo/broken link?
  |-- YES --> Fix directly, no ADR needed
  |
  v
Is it clarifying existing behavior?
  |-- YES --> Update the relevant reference doc
  |            (data-model, ui/{domain}, api/*)
  |
  v
Is it adding new guidance/rules?
  |-- YES --> Is it agent-specific?
  |            |-- YES --> Update agents/{topic}.md
  |            |-- NO --> Update docs/references/{topic}.md
  |
  v
Is it documenting a decision?
  |-- YES --> Create ADR in docs/decisions/
  |
  v
Is it changing this file (index.md)?
  |-- YES --> Update this file + AGENTS.md routing section
  |
  v
DONE: Commit with clear message
```

---

## Quick Reference Table

| What Changed | Where to Document | Also Update |
|--------------|-------------------|-------------|
| API endpoint | `docs/references/api/{domain}.md` | `api/index.md` if new endpoint |
| Database schema | `docs/references/data-model.md` | API module if affects endpoints |
| UI page/route | `docs/references/ui/{domain}.md` | `ui/index.md` if new page |
| Architecture decision | `docs/decisions/ADR-*.md` | `agents/architecture.md` |
| Workflow/process | `agents/workflows.md` | `AGENTS.md` if MUST rule |
| Security policy | `agents/security.md` | ADR if major change |
| Testing approach | `agents/testing.md` | - |
| Environment setup | `agents/runbook.md` | - |
| Project status | `docs/references/project-status.md` | - |

---

## Realistic Examples

### Example 1: Adding a new API endpoint

You add `POST /api/v1/users/favorites`:

1. Determine module: User-related --> `users.md` or `customer.md`
2. Add endpoint documentation following the standard format
3. Update `api/index.md` endpoint count if needed
4. Update `data-model.md` if new database fields
5. Commit: `[FEAT-XXX] Add favorites endpoint with docs`

### Example 2: Changing database schema

You add a `lastLoginAt` field to the `users` table/collection:

1. Update `docs/references/data-model.md` with new field
2. Check if any API endpoints need doc updates
3. No ADR needed (field addition is non-breaking)
4. Commit: `[FEAT-XXX] Add lastLoginAt field to users`

### Example 3: Architectural decision

You decide to use Redis for caching:

1. Create `docs/decisions/ADR-20260123-redis-caching.md`
2. Update `agents/architecture.md` with caching strategy
3. Update `agents/runbook.md` with Redis setup
4. Update backlog card with decision
5. Commit: `[FEAT-XXX] Add Redis caching with ADR`

---

## Navigation Tips

1. **Start here**: If unsure where to look, start with `agents/index.md` (this file)
2. **API changes**: Always check `agents/api-contracts.md` for rules before modifying API docs
3. **Data model**: Cross-reference with `api/*.md` modules when updating
4. **Legacy context**: Check `archive/project_full_legacy.md` for historical decisions if it exists
5. **Status check**: `docs/references/project-status.md` shows current work and blockers

---

## Documentation Size Budget

### File Size Thresholds

| Doc Type | Max Lines | Action When Exceeded |
|----------|-----------|---------------------|
| Agent modules (agents/*.md) | 300 | Split into sub-modules |
| Reference docs (docs/references/*) | 300 | Split by topic/collection |
| API docs | 400 | Split by endpoint group |
| PRDs/Specs | 500 | Split into requirements + implementation |
| project-status.md | 200 | Archive to work-history.md |

### When to Split a File

1. File exceeds threshold by 50%+
2. File mixes doc-types (tutorial + reference + how-to)
3. File has 3+ distinct topics that could standalone
4. Agents report context loading issues

### Token Efficiency Guidelines

- Compress verbose cross-references: "See [X](link)." not "See the X documentation for details."
- Use tables over bullet lists for structured data
- Remove boilerplate (Purpose/Scope can be 1 line)
- Link don't duplicate - one source of truth per fact

---

## References

- `docs/references/product-scope.md`
- `docs/references/data-model.md`
- `docs/references/api/index.md` (API reference - organize by domain)
- `docs/references/ui/index.md` (UI routes - organize by domain)
- `docs/references/project-status.md`
- `docs/operations/` (operational procedures - if applicable)
- `docs/decisions/`
