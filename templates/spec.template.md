# [Feature Name] - Specification

**Feature ID**: FEAT-XXX
**Status**: DRAFT | APPROVED | IMPLEMENTED
**Owner**: [Agent/Person]
**Created**: YYYY-MM-DD
**Updated**: YYYY-MM-DD

---

## Summary

[1-3 paragraphs describing what this feature does, why it exists, and what problem it solves]

**Target Users**: [CUSTOMER | MERCHANT | ADMIN]
**Priority**: [LOW | MEDIUM | HIGH | CRITICAL]
**Effort Estimate**: [S | M | L | XL]

---

## User Stories

**As a [user type]**, I want to [action] so that [benefit].

### Primary Stories
- **US-1**: As a [user], I want to [action] so that [benefit]
- **US-2**: As a [user], I want to [action] so that [benefit]

### Secondary Stories
- **US-3**: As a [user], I want to [action] so that [benefit]

---

## Scope

### In Scope
- [What this feature WILL include]
- [Specific functionality to be implemented]

### Out of Scope (Non-Goals)
- [What this feature will NOT include]
- [Features explicitly excluded]
- [Future enhancements to consider later]

---

## UX Notes

### User Flow
1. User navigates to [page/component]
2. User performs [action]
3. System responds with [result]
4. User sees [feedback]

### UI Components
- **[Component Name]**: Description and purpose
- **[Component Name]**: Description and purpose

### Mobile Considerations
- [Mobile-specific UX notes]
- [Responsive behavior]
- [Touch interactions]

### Error States
- [Error condition]: [Error message shown to user]
- [Error condition]: [Error message shown to user]

### Loading States
- [When loading]: [What user sees]

---

## API Changes

### New Endpoints
```typescript
// POST /api/[endpoint]
// Description: [What this endpoint does]
Request: {
  field: type  // Description
}
Response: {
  field: type  // Description
}
Errors:
  - 400: [Error condition]
  - 404: [Error condition]
  - 500: [Error condition]
```

### Modified Endpoints
```typescript
// [METHOD] /api/[endpoint]
// Changes: [What's being modified]
```

### Deprecated Endpoints
- `/api/[old-endpoint]` - Replaced by `/api/[new-endpoint]`

---

## Data Model Changes

### New Collections
```typescript
// Collection: [collectionName]
{
  id: string              // Description
  field: type             // Description
  createdAt: Date
  updatedAt: Date
}
```
**Indexes Required**: [List indexes]

### Schema Changes to Existing Collections
```typescript
// Collection: [collectionName]
// Added fields:
{
  newField: type          // Description
}
```

### Data Migration Required
- [Y/N] If yes, describe migration strategy

---

## Edge Cases

### Validation
- **[Case]**: System validates [condition] and rejects if [rule]
- **[Case]**: System validates [condition] and rejects if [rule]

### Error Handling
- **[Scenario]**: [How system handles it]
- **[Scenario]**: [How system handles it]

### Performance
- **[Concern]**: [Mitigation strategy]

### Security
- **[Concern]**: [Mitigation strategy]

---

## Test Plan

### Manual Test Cases
1. **[Test Case]**: [Steps to reproduce] → Expected: [result]
2. **[Test Case]**: [Steps to reproduce] → Expected: [result]

### Validation Checklist
- [ ] Happy path: User completes flow successfully
- [ ] Error path: Invalid input rejected with clear message
- [ ] Empty state: UI handles no data gracefully
- [ ] Loading state: UI shows loading indicator
- [ ] Mobile: Feature works on mobile viewport
- [ ] Authentication: Unauthorized access blocked

### Build Verification
- [ ] `npm run build` passes with no TypeScript errors
- [ ] No console errors in browser
- [ ] All links/navigation work correctly

---

## Rollout Notes

### Prerequisites
- [Dependency or requirement needed before this can ship]

### Deployment Steps
1. [Step to deploy]
2. [Step to deploy]

### Seed Data Updates
- [Y/N] If yes, describe changes to seed script

### Breaking Changes
- [List any breaking changes and migration path]

### Rollback Plan
- [How to rollback if issues found]

---

## Open Questions

- **[Q-1]**: [Question that needs answering before implementation]
- **[Q-2]**: [Question that needs answering before implementation]

---

## Related

- **Feature Card**: `/backlog/[feature-name].yml`
- **Related Specs**: [Links to other specs]
- **Docs References**: [Which docs/references files this impacts]

---

## Changelog

| Date | Change | Author |
|------|--------|--------|
| YYYY-MM-DD | Initial draft | [Agent] |
