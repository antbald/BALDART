# Coding Standards

## Purpose

Ensure consistent terminology and naming across code and docs.

## Scope

**In**: Terminology rules for UI, code, docs, and commit messages.
**Out**: Formatting or lint rules (handled by tooling).

## Do

- Use the exact terms below in code, docs, and issues.

## Do Not

- Substitute synonyms for defined terms.

## Terminology

Define project-specific terminology here to ensure consistency across codebase:

| Correct | Avoid |
|---|---|
| [Term 1] | [Synonym 1], [Synonym 2] |
| [Term 2] | [Synonym 1], [Synonym 2] |
| [Term 3] | [Synonym 1], [Synonym 2] |

### Examples of Terminology to Define

- **User Types**: End user, admin, moderator, customer, etc.
- **Core Entities**: Product, order, transaction, item, etc.
- **Actions**: Create, add, register, signup, etc.
- **UI Elements**: Modal, dialog, popup, drawer, etc.
- **Status Values**: Active, enabled, live, published, etc.

## Code Conventions

### Naming Conventions

- **Files**: [Your convention - e.g., kebab-case, camelCase, PascalCase]
- **Functions**: [Your convention - e.g., camelCase, snake_case]
- **Components**: [Your convention - e.g., PascalCase]
- **Constants**: [Your convention - e.g., SCREAMING_SNAKE_CASE]
- **Variables**: [Your convention - e.g., camelCase, snake_case]

### Project-Specific Patterns

Document any project-specific coding patterns here:

#### Example: File Organization

```
src/
  features/
    [feature-name]/
      components/
      hooks/
      utils/
      types.ts
      index.ts
```

#### Example: Import Order

1. External dependencies
2. Internal utilities
3. Components
4. Types
5. Styles

#### Example: Error Handling

```typescript
// Preferred pattern
try {
  // operation
} catch (error) {
  // handle error
}

// Avoid pattern
if (error) {
  // handle error
}
```

## Commit Message Format

- **Format**: `[TYPE-XXX] Brief description` or adapt to your project convention
- **Types**: feat, fix, docs, refactor, test, chore
- **Examples**:
  - `[FEAT-123] Add user authentication`
  - `[FIX-456] Resolve login redirect issue`
  - `[DOCS-789] Update API documentation`

## Documentation Standards

### Code Comments

- Comment **why**, not **what**
- Use JSDoc/docstrings for public APIs
- Avoid obvious comments
- Update comments when code changes

### README Requirements

- Installation instructions
- Configuration steps
- Usage examples
- Contributing guidelines
- License information

## Type Safety (if applicable)

- [Your type safety requirements]
- [Strictness level]
- [Type annotation requirements]
- [Any/unknown usage policy]

## Testing Standards

- [Test coverage requirements]
- [Test naming conventions]
- [Test file organization]
- [Mocking guidelines]

## Accessibility Standards (if applicable)

- [ARIA label requirements]
- [Keyboard navigation requirements]
- [Screen reader compatibility]
- [Color contrast requirements]

## Performance Standards (if applicable)

- [Bundle size limits]
- [Image optimization requirements]
- [Lazy loading guidelines]
- [Caching strategies]

## Security Standards

- [Input validation requirements]
- [Authentication patterns]
- [Data sanitization rules]
- [Secrets management]
