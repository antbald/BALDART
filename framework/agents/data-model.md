# Data Model

## Purpose

Define database schema documentation standards and data modeling guidelines.

## Scope

**In**: Schema documentation format, field types, relationships, constraints.
**Out**: Query optimization (see agents/performance.md).

## Do

- Document all collections/tables in docs/references/data-model.md
- Define field types and constraints
- Document relationships between entities
- Update docs when schema changes

## Do Not

- Change schema without updating documentation
- Skip documenting new fields
- Make breaking changes without migration plan

## Schema Documentation Format

Each collection/table should document:

```markdown
## [CollectionName / TableName]

**Purpose**: [What this stores]

**Fields**:
| Field | Type | Required | Default | Description |
|-------|------|----------|---------|-------------|
| id | string | Yes | auto | Unique identifier |
| field1 | string | Yes | - | Description |
| field2 | number | No | 0 | Description |
| createdAt | timestamp | Yes | now() | Creation time |
| updatedAt | timestamp | Yes | now() | Last update time |

**Indexes**:
- Primary: `id`
- Index: `field1`
- Composite: `field1 + field2`

**Relationships**:
- `foreignKeyField` → References `OtherCollection.id`

**Constraints**:
- Unique: `field1`
- Check: `field2 > 0`

**Example Document/Row**:
\`\`\`json
{
  "id": "123",
  "field1": "value",
  "field2": 42,
  "createdAt": "2026-02-13T10:00:00Z",
  "updatedAt": "2026-02-13T10:00:00Z"
}
\`\`\`
```

## Field Type Conventions

- [String length limits]
- [Number ranges]
- [Date/timestamp formats]
- [Boolean defaults]
- [Array/nested object guidelines]
- [Enum value lists]

## Naming Conventions

- [Collection/table naming - e.g., plural, lowercase]
- [Field naming - e.g., camelCase, snake_case]
- [Foreign key naming]
- [Index naming]

## Relationships

- [One-to-one patterns]
- [One-to-many patterns]
- [Many-to-many patterns]
- [Denormalization guidelines]

## Migrations

- [Migration file location]
- [Migration naming convention]
- [Rollback requirements]
- [Data preservation rules]

## Audit Fields

Standard fields for all collections/tables:

- `createdAt`: timestamp of creation
- `updatedAt`: timestamp of last update
- `deletedAt`: soft delete timestamp (if using soft deletes)

## Data Retention

- [Retention policies]
- [Archival strategy]
- [Deletion procedures]
- [GDPR/privacy compliance]
