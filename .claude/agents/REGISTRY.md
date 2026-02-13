# Agent Registry

Single source of truth for all available agents, their capabilities, and when to use them.

## Quick Reference

| Agent | Purpose | When to Use |
|-------|---------|-------------|
| codebase-architect | Understand codebase structure | Before planning/implementing |
| coder | Write production code | Feature implementation, bug fixes |
| code-reviewer | Review code quality | After implementation, before merge |
| doc-reviewer | Review/write documentation | After feature completion |
| prd | Create PRDs and specs | Before feature development |
| plan-auditor | Audit implementation plans | After planning, before coding |
| senior-researcher | Research & analysis | Technology decisions, comparisons |
| api-perf-cost-auditor | API performance/cost analysis | API optimization, cost review |

## Detailed Agent Descriptions

### codebase-architect

**Purpose**: Understand codebase structure, existing patterns, and architecture before planning or implementing changes.

**Capabilities**:
- Deep codebase exploration
- Pattern identification
- Architecture mapping
- Dependency analysis
- Code organization recommendations

**When to invoke**:
- MANDATORY before any planning or implementation
- Understanding feature implementation areas
- Investigating existing patterns
- Architecture decisions

**Tools**: All tools except Edit, Write, Task

### coder

**Purpose**: Write, modify, or refactor production code for features, bugs, and optimizations.

**Capabilities**:
- Feature implementation
- Bug fixes
- Code refactoring
- Test writing
- Build/lint/test verification

**When to invoke**:
- After planning is approved
- For code implementations
- Bug fixes with clear requirements

**Tools**: All tools

### code-reviewer

**Purpose**: Review code for bugs, security issues, quality, and maintainability.

**Capabilities**:
- Security analysis
- Performance evaluation
- Best practices verification
- Modularization review
- Technical debt identification
- Protocol compliance checking

**When to invoke**:
- After implementation complete
- Before merging code
- Major feature completion
- Suspicious code patterns

**Tools**: All tools

### doc-reviewer

**Purpose**: Audit, review, and write project documentation.

**Capabilities**:
- Documentation completeness audit
- Missing documentation identification
- Documentation writing
- Doc structure review
- Consistency checking

**When to invoke**:
- After feature implementation
- Documentation cleanup needed
- New features need docs
- Doc drift suspected

**Tools**: All tools

### prd

**Purpose**: Create Product Requirement Documents, implementation plans, and backlog cards.

**Capabilities**:
- PRD creation
- User story writing
- Acceptance criteria definition
- Backlog card generation
- Requirements analysis

**When to invoke**:
- New feature planning
- Complex feature breakdown
- Requirements clarification needed
- Before implementation starts

**Tools**: All tools

### plan-auditor

**Purpose**: Rigorous review of implementation plans before coding begins.

**Capabilities**:
- Plan completeness verification
- Gap identification
- Risk assessment
- Dependency analysis
- Ambiguity detection

**When to invoke**:
- MANDATORY after plan creation, before implementation
- Quality gate before coding
- Complex feature plans
- Multi-agent coordination needed

**Tools**: All tools

### senior-researcher

**Purpose**: Comprehensive research and analysis for technical decisions.

**Capabilities**:
- Technology comparisons
- Framework evaluations
- Library research
- Best practices research
- Evidence-based recommendations
- Decision documentation

**When to invoke**:
- Technology selection needed
- Architecture decisions
- Library/framework comparisons
- Performance optimization research
- Security pattern research

**Tools**: All tools

### api-perf-cost-auditor

**Purpose**: Analyze APIs for performance bottlenecks and cost inefficiencies.

**Capabilities**:
- Performance profiling
- Cost analysis
- Bottleneck identification
- Optimization recommendations
- Scaling issue detection

**When to invoke**:
- API performance issues
- High cloud costs
- Scaling concerns
- Before major launches
- Regular performance audits

**Tools**: All tools

## Agent Invocation Decision Tree

```
START: Need to do work
  |
  v
Need to understand codebase first?
  |-- YES --> Invoke codebase-architect (MANDATORY)
  |
  v
Need to create requirements/plan?
  |-- YES --> Invoke prd
  |           Then invoke plan-auditor
  |
  v
Need to research/compare options?
  |-- YES --> Invoke senior-researcher
  |
  v
Ready to implement code?
  |-- YES --> Invoke coder
  |
  v
Code implemented, need review?
  |-- YES --> Invoke code-reviewer
  |
  v
Documentation needs review/writing?
  |-- YES --> Invoke doc-reviewer
  |
  v
API performance concerns?
  |-- YES --> Invoke api-perf-cost-auditor
  |
  v
DONE
```

## Agent Collaboration Patterns

### Pattern 1: New Feature (Full Cycle)

1. **prd** - Create requirements
2. **codebase-architect** - Understand existing code (MANDATORY)
3. **senior-researcher** - Research approach if needed
4. **plan-auditor** - Review plan before coding
5. **coder** - Implement feature
6. **code-reviewer** - Review implementation
7. **doc-reviewer** - Ensure docs complete

### Pattern 2: Bug Fix

1. **codebase-architect** - Understand affected area
2. **coder** - Fix bug with tests
3. **code-reviewer** - Verify fix

### Pattern 3: Performance Optimization

1. **api-perf-cost-auditor** - Identify bottlenecks
2. **codebase-architect** - Understand current implementation
3. **senior-researcher** - Research optimization techniques
4. **coder** - Implement optimizations
5. **code-reviewer** - Review changes
6. **api-perf-cost-auditor** - Verify improvements

### Pattern 4: Technology Decision

1. **senior-researcher** - Compare options
2. **prd** - Document decision and rationale
3. **plan-auditor** - Review migration plan if needed

## Adding Custom Agents

To add project-specific agents:

1. Create agent file in `.claude/agents/[agent-name].md`
2. Follow agent file format (frontmatter + instructions)
3. Add to this REGISTRY.md
4. Update decision tree if needed
5. Document collaboration patterns

## Agent File Format

```markdown
---
name: agent-name
description: "Brief description"
model: opus|sonnet|haiku
color: red|blue|green|yellow
---

[Agent instructions]

## Purpose
[What this agent does]

## Capabilities
[What it can do]

## When to invoke
[Triggering conditions]

## Tools
[Available tools]
```

## Notes

- **MANDATORY invocations**: codebase-architect before planning/implementation, plan-auditor after planning
- **Model selection**: Use opus for complex reasoning, sonnet for balanced tasks, haiku for simple/fast tasks
- **Tool access**: Read agent files for specific tool restrictions
- **Parallel execution**: Independent agents can run in parallel for efficiency
