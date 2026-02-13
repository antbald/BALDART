# Environment Reference

## Purpose

Document all environment variables and configuration options.

## Scope

**In**: Environment variable definitions, configuration, secrets.
**Out**: Operational procedures (see agents/runbook.md).

## Do

- Document all environment variables
- Provide examples
- Specify required vs optional
- Update when adding new variables

## Do Not

- Commit actual secret values
- Use production values in examples

## Environment Variables

### Application Configuration

| Variable | Required | Default | Description | Example |
|----------|----------|---------|-------------|---------|
| `APP_NAME` | No | MyApp | Application name | `MyApp` |
| `APP_ENV` | Yes | - | Environment (dev/staging/prod) | `production` |
| `APP_PORT` | No | 3000 | Server port | `8080` |
| `APP_URL` | Yes | - | Application base URL | `https://app.example.com` |

### Database

| Variable | Required | Default | Description | Example |
|----------|----------|---------|-------------|---------|
| `DB_HOST` | Yes | - | Database host | `localhost` |
| `DB_PORT` | No | 5432 | Database port | `5432` |
| `DB_NAME` | Yes | - | Database name | `myapp` |
| `DB_USER` | Yes | - | Database username | `dbuser` |
| `DB_PASSWORD` | Yes | - | Database password | `***` |
| `DB_SSL` | No | false | Use SSL connection | `true` |

### Authentication

| Variable | Required | Default | Description | Example |
|----------|----------|---------|-------------|---------|
| `JWT_SECRET` | Yes | - | JWT signing secret | `***` |
| `JWT_EXPIRY` | No | 24h | JWT expiration time | `7d` |
| `SESSION_SECRET` | Yes | - | Session secret key | `***` |

### External Services

| Variable | Required | Default | Description | Example |
|----------|----------|---------|-------------|---------|
| `SERVICE_API_KEY` | Yes | - | External service API key | `***` |
| `SERVICE_URL` | Yes | - | External service URL | `https://api.service.com` |

### Email (if applicable)

| Variable | Required | Default | Description | Example |
|----------|----------|---------|-------------|---------|
| `SMTP_HOST` | Yes | - | SMTP server host | `smtp.gmail.com` |
| `SMTP_PORT` | No | 587 | SMTP server port | `587` |
| `SMTP_USER` | Yes | - | SMTP username | `user@example.com` |
| `SMTP_PASSWORD` | Yes | - | SMTP password | `***` |
| `EMAIL_FROM` | Yes | - | Default sender email | `noreply@example.com` |

### Storage (if applicable)

| Variable | Required | Default | Description | Example |
|----------|----------|---------|-------------|---------|
| `STORAGE_TYPE` | No | local | Storage type (local/s3) | `s3` |
| `S3_BUCKET` | No | - | S3 bucket name | `my-bucket` |
| `S3_REGION` | No | - | S3 region | `us-east-1` |
| `S3_ACCESS_KEY` | No | - | S3 access key | `***` |
| `S3_SECRET_KEY` | No | - | S3 secret key | `***` |

### Monitoring/Logging

| Variable | Required | Default | Description | Example |
|----------|----------|---------|-------------|---------|
| `LOG_LEVEL` | No | info | Logging level | `debug` |
| `SENTRY_DSN` | No | - | Sentry error tracking DSN | `https://***@sentry.io/***` |

## Environment Files

### .env.example

Create a `.env.example` file with all variables (no secrets):

```bash
# Application
APP_NAME=MyApp
APP_ENV=development
APP_PORT=3000
APP_URL=http://localhost:3000

# Database
DB_HOST=localhost
DB_PORT=5432
DB_NAME=myapp
DB_USER=dbuser
DB_PASSWORD=change-me-in-production

# Authentication
JWT_SECRET=change-me-to-random-string
JWT_EXPIRY=24h
SESSION_SECRET=change-me-to-random-string

# External Services
SERVICE_API_KEY=your-api-key-here
SERVICE_URL=https://api.service.com

# Monitoring
LOG_LEVEL=info
```

### .env.local (Development)

Copy `.env.example` to `.env.local` and fill in development values.

### Environment-Specific Files

- `.env.development` - Development defaults
- `.env.staging` - Staging configuration
- `.env.production` - Production configuration (never commit!)

## Secrets Management

### Development

- Use `.env` files (gitignored)
- Share example values in `.env.example`

### Production

- Use secrets management service (e.g., AWS Secrets Manager, HashiCorp Vault)
- Or use platform-specific env var management (e.g., Vercel, Heroku)
- Never commit production secrets

## Configuration Validation

Validate required environment variables on startup:

```typescript
// Example validation
const required = ['DB_HOST', 'DB_NAME', 'JWT_SECRET'];
for (const key of required) {
  if (!process.env[key]) {
    throw new Error(`Missing required env var: ${key}`);
  }
}
```

## Loading Environment

Document how environment variables are loaded:

- [e.g., dotenv package]
- [e.g., Next.js built-in]
- [e.g., platform-specific]

## Feature Flags (if applicable)

| Variable | Type | Default | Description |
|----------|------|---------|-------------|
| `FEATURE_FLAG_1` | boolean | false | Enable new feature |
| `FEATURE_FLAG_2` | boolean | false | Enable experimental feature |
