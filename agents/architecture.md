# Architecture

## Purpose

Summarize system architecture, tech stack, and core flows.

## Scope

**In**: Tech stack, architecture patterns, authentication flows, key principles.
**Out**: API details (see docs/references/api/index.md), data model (see docs/references/data-model.md).

## Do

- Align changes with the documented patterns and principles.
- Update this file when architecture or tech stack changes.

## Do Not

- Change providers or architecture without an ADR.

## Content

# Tech Stack

## Frontend

- **Framework**: [Your framework here - e.g., React, Next.js, Vue, Angular]
- **Language**: [Your language here - e.g., TypeScript, JavaScript]
- **Styling**: [Your styling approach - e.g., Tailwind CSS, CSS Modules, styled-components]
- **UI Approach**: [Your UI approach - e.g., mobile-first, responsive, component library]
- **State**: [Your state management - e.g., Redux, Zustand, Context API, none]
- **Session**: [Your session storage approach - e.g., localStorage, sessionStorage, cookies]

## Backend

- **Runtime**: [Your runtime - e.g., Node.js, Python, Go, Rust]
- **Database**: [Your database - e.g., PostgreSQL, MongoDB, Firebase, Supabase]
- **Storage**: [Your storage solution - e.g., S3, local filesystem, none]
- **Authentication**: [Your auth approach - e.g., JWT, OAuth, Firebase Auth, Supabase Auth, custom]

## Build/Deploy

- **Build**: [Your build tool - e.g., Vite, Webpack, Next.js, esbuild]
- **Linting**: [Your linter - e.g., ESLint, Biome, RuboCop, pylint]
- **Package Manager**: [Your package manager - e.g., npm, pnpm, yarn, pip, cargo]
- **Testing**: [Your test framework - e.g., Jest, Vitest, pytest, cargo test]

## External Dependencies

- List key external dependencies here
- Include purpose for each dependency
- Update when adding or removing major dependencies

---

# Architecture

## Pattern

- **Frontend**: [Your frontend architecture pattern]
- **Backend**: [Your backend architecture pattern]
- **Auth**: [Your authentication flow]
- **Data flow**: [Your data flow pattern - e.g., Client → API → Database → Response]

## Key Principles

- List your project's key architectural principles here
- Include design patterns you follow
- Document constraints and trade-offs
- Examples:
  - Mobile-first UI
  - RESTful API design
  - No real-time subscriptions
  - Immutable data patterns
  - Specific performance targets

## Authentication Flow

### User Type 1 (e.g., End Users)

1. [Step 1 of authentication]
2. [Step 2 of authentication]
3. [Step 3 of authentication]
4. [Session storage/management]

### User Type 2 (e.g., Admin Users)

1. [Step 1 of authentication]
2. [Step 2 of authentication]
3. [Step 3 of authentication]
4. [Session storage/management]

## Core Business Flows

### Flow 1: [Name of key flow]

1. [Step 1]
2. [Step 2]
3. [Step 3]
4. [Validation/error handling]
5. [Side effects/notifications]
6. [Return/response]

### Flow 2: [Name of another key flow]

1. [Step 1]
2. [Step 2]
3. [Step 3]

---

## Deployment Architecture

- **Environment**: [Development/Staging/Production setup]
- **Hosting**: [Your hosting solution - e.g., Vercel, AWS, GCP, self-hosted]
- **CI/CD**: [Your CI/CD pipeline - e.g., GitHub Actions, CircleCI, Jenkins]
- **Monitoring**: [Your monitoring solution - e.g., Sentry, Datadog, none]

---

## Security Considerations

- [List key security measures]
- [Authentication/authorization approach]
- [Data encryption]
- [API rate limiting]
- [Input validation]

---

## Performance Targets

- [Response time targets]
- [Throughput targets]
- [Scalability considerations]
- [Caching strategy]

---

## Known Limitations

- [Document known architectural limitations]
- [Technical debt]
- [MVP vs Production trade-offs]
- [Areas requiring future improvement]
