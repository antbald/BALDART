# API Contracts

## Purpose

Define API endpoint documentation standards and contract rules.

## Scope

**In**: API documentation format, versioning, breaking changes, error responses.
**Out**: Specific endpoint implementations (see docs/references/api/).

## Do

- Document all API endpoints in docs/references/api/
- Follow consistent request/response format
- Version APIs appropriately
- Document error responses

## Do Not

- Make breaking changes without versioning
- Skip documenting endpoints
- Change contracts without updating docs

## API Documentation Format

Each endpoint should document:

```markdown
### [METHOD] /api/[version]/[resource]

**Purpose**: [What this endpoint does]

**Auth**: [Required authentication - e.g., Bearer token, API key, none]

**Request**:
- **Headers**: [Required headers]
- **Path Params**: [URL parameters]
- **Query Params**: [Query string parameters]
- **Body**: [Request body schema]

**Response**:
- **Success (200)**: [Success response schema]
- **Error (4xx/5xx)**: [Error response schema]

**Example Request**:
\`\`\`json
{
  "field": "value"
}
\`\`\`

**Example Response**:
\`\`\`json
{
  "data": "value",
  "message": "Success"
}
\`\`\`

**Business Rules**:
- [Rule 1]
- [Rule 2]

**Error Codes**:
- `ERROR_CODE_1`: Description
- `ERROR_CODE_2`: Description
```

## Versioning Strategy

- Use semantic versioning for API versions (v1, v2, etc.)
- Maintain backwards compatibility within major versions
- Deprecate old versions with appropriate sunset periods
- Document version differences

## Breaking vs Non-Breaking Changes

**Non-Breaking** (can be added without version bump):

- Adding new optional fields to requests
- Adding new fields to responses
- Adding new endpoints
- Adding new optional query parameters

**Breaking** (require version bump):

- Removing fields from responses
- Changing field types
- Making optional fields required
- Removing endpoints
- Changing authentication requirements
- Changing error response format

## Error Response Format

Define a consistent error response format:

```json
{
  "error": {
    "code": "ERROR_CODE",
    "message": "Human readable message",
    "details": {}
  }
}
```

## API Conventions

- [HTTP method conventions]
- [Resource naming conventions]
- [Query parameter conventions]
- [Pagination conventions]
- [Filtering conventions]
- [Sorting conventions]

## Authentication

- [Authentication method - Bearer, API Key, etc.]
- [Token format]
- [Token expiration]
- [Refresh token flow if applicable]

## Rate Limiting

- [Rate limit rules if applicable]
- [Rate limit headers]
- [Handling rate limit errors]

## Deprecation Policy

1. Announce deprecation with timeline
2. Add deprecation headers to responses
3. Update documentation with migration guide
4. Maintain deprecated version for sunset period
5. Remove after sunset period expires
