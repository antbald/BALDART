# Skills Mapping

## Purpose

Map Claude Code skills to project domains and provide guidance on when to use each skill.

## Scope

**In**: Skill selection guidance, domain mapping, best practices.
**Out**: Skill implementation details (see skill documentation).

## Do

- Use skills when appropriate
- Follow skill-specific guidelines
- Invoke skills before starting work when applicable

## Do Not

- Skip skills for tasks they're designed for
- Use wrong skill for the task
- Rationalize not using applicable skills

## Core Development Skills

### brainstorming

**When to use**:

- Starting new features
- Unclear requirements
- Multiple possible approaches
- Design decisions needed

**Triggers**:

- "Add [feature]"
- "Build [component]"
- "Implement [functionality]"
- "How should I..."

### writing-plans

**When to use**:

- After brainstorming
- Multi-step implementation needed
- Complex feature development

**Triggers**:

- After design approval
- Before starting implementation
- For documented requirements

### test-driven-development

**When to use**:

- Implementing new features
- Fixing bugs
- Adding testable functionality

**Triggers**:

- New feature implementation
- Bug fix with test case
- Refactoring with tests

### systematic-debugging

**When to use**:

- Bug investigation
- Test failures
- Unexpected behavior

**Triggers**:

- "Fix [bug]"
- "Why is [X] not working?"
- Test failure analysis

## Code Quality Skills

### code-review

**When to use**:

- Before merging
- After major implementation
- PR review process

**Triggers**:

- Feature completion
- Before deployment
- Pull request review

### verification-before-completion

**When to use**:

- Claiming work is complete
- Before marking card done
- Before creating PR

**Triggers**:

- "Done"
- "Fixed"
- "Tests passing"

## UI/UX Skills

### frontend-design

**When to use**:

- Building UI components
- Creating pages
- Styling work

**Triggers**:

- "Create [page]"
- "Build [component]"
- "Design [interface]"

### ui-ux-pro-max

**When to use**:

- Professional UI/UX design
- Design system work
- Polished interfaces

**Triggers**:

- Design-heavy features
- Visual refinement needed
- Design system development

## Testing Skills

### playwright-skill

**When to use**:

- Browser automation
- E2E testing
- UI testing

**Triggers**:

- "Test [page]"
- "Automate [flow]"
- Visual regression testing

### webapp-testing

**When to use**:

- Full webapp testing
- Server lifecycle management
- Comprehensive test orchestration

**Triggers**:

- Full application testing
- Integration testing
- Server management needed

## Documentation Skills

### writing-clearly-and-concisely

**When to use**:

- Writing documentation
- Creating specs
- User-facing content

**Triggers**:

- Documentation updates
- README writing
- Technical writing

## Project-Specific Skills

Add your project-specific skills here:

### [Your Skill 1]

**When to use**: [Description]
**Triggers**: [When to invoke]

### [Your Skill 2]

**When to use**: [Description]
**Triggers**: [When to invoke]

## Skill Selection Decision Tree

```
START: User gives a task
  |
  v
Is it a new feature/design task?
  |-- YES --> Use brainstorming skill first
  |           Then writing-plans
  |           Then implementation skills
  |
  v
Is it a bug fix?
  |-- YES --> Use systematic-debugging
  |           Then test-driven-development
  |           Then verification-before-completion
  |
  v
Is it UI/visual work?
  |-- YES --> Use frontend-design or ui-ux-pro-max
  |
  v
Is it browser testing?
  |-- YES --> Use playwright-skill or webapp-testing
  |
  v
Is work complete?
  |-- YES --> Use verification-before-completion
  |           Then code-review
  |
  v
Proceed with appropriate skill
```

## Skill Chaining

Common skill chains:

1. **New Feature**:
   - brainstorming → writing-plans → test-driven-development → verification-before-completion → code-review

2. **Bug Fix**:
   - systematic-debugging → test-driven-development → verification-before-completion

3. **UI Feature**:
   - brainstorming → frontend-design → test-driven-development → playwright-skill → code-review

4. **Refactoring**:
   - code-review (identify issues) → test-driven-development → verification-before-completion

## Anti-Patterns

**Don't**:

- Skip brainstorming for "simple" features
- Start coding before planning
- Skip TDD because "I know how to fix it"
- Skip verification before claiming completion
- Use wrong skill for the task

**Do**:

- Follow skill workflows
- Chain skills appropriately
- Use skills even when they seem "overkill"
- Trust the skill process

## Skill Configuration

Some skills may require configuration:

- [Skill-specific config location]
- [Environment variables needed]
- [Setup requirements]

## Custom Skills

Document how to create custom skills:

1. Create skill file in `.claude/skills/`
2. Follow skill template format
3. Document when to use
4. Add to this mapping file
