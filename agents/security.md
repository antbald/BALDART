# Security

## Purpose

Document security requirements, threats, and mitigation strategies.

## Scope

**In**: Authentication, authorization, data protection, common vulnerabilities.
**Out**: Compliance requirements (create separate docs/compliance/ if needed).

## Do

- Validate all user inputs
- Use parameterized queries
- Implement rate limiting
- Log security events
- Keep dependencies updated

## Do Not

- Store secrets in code
- Trust client-side validation alone
- Skip authentication checks
- Log sensitive data

## Authentication

- [Authentication method]
- [Session management]
- [Token handling]
- [Password requirements]
- [Multi-factor authentication if applicable]

## Authorization

- [Permission model]
- [Role-based access control]
- [Resource-level permissions]
- [API authorization checks]

## Input Validation

- Validate all user inputs server-side
- Sanitize data before database operations
- Use allowlists over denylists
- Validate file uploads (type, size, content)
- Check for injection attacks (SQL, NoSQL, command, XSS)

## Data Protection

- [Encryption at rest]
- [Encryption in transit]
- [PII handling]
- [Sensitive data masking in logs]
- [Secrets management]

## Common Vulnerabilities (OWASP Top 10)

### Injection Attacks

- Use parameterized queries
- Validate and sanitize inputs
- Implement least privilege database access

### Broken Authentication

- Implement secure session management
- Use strong password policies
- Implement account lockout
- Protect against brute force

### Sensitive Data Exposure

- Encrypt sensitive data
- Use HTTPS everywhere
- Don't log sensitive information
- Implement secure key management

### XML External Entities (XXE)

- Disable XML external entity processing
- Use safe XML parsers
- Validate XML inputs

### Broken Access Control

- Implement proper authorization
- Validate permissions on every request
- Use principle of least privilege

### Security Misconfiguration

- Harden default configurations
- Keep software updated
- Remove unnecessary features
- Implement security headers

### Cross-Site Scripting (XSS)

- Escape output
- Use Content Security Policy
- Validate and sanitize inputs
- Use framework protections

### Insecure Deserialization

- Validate serialized data
- Use safe deserialization libraries
- Implement integrity checks

### Using Components with Known Vulnerabilities

- Keep dependencies updated
- Monitor security advisories
- Use dependency scanning tools

### Insufficient Logging & Monitoring

- Log security events
- Monitor for suspicious activity
- Implement alerting
- Protect log integrity

## Rate Limiting

- [API rate limits]
- [Authentication attempt limits]
- [Resource access limits]

## Security Headers

Implement these HTTP security headers:

- `Content-Security-Policy`
- `X-Content-Type-Options: nosniff`
- `X-Frame-Options: DENY`
- `X-XSS-Protection: 1; mode=block`
- `Strict-Transport-Security`

## Secrets Management

- Never commit secrets to version control
- Use environment variables
- Use secrets management service if available
- Rotate secrets regularly
- Implement least privilege access

## Incident Response

1. Detect and identify incident
2. Contain the threat
3. Investigate root cause
4. Remediate vulnerability
5. Document and learn

## Security Checklist

- [ ] All inputs validated
- [ ] Parameterized queries used
- [ ] Authentication implemented
- [ ] Authorization checked
- [ ] Sensitive data encrypted
- [ ] Security headers set
- [ ] Rate limiting implemented
- [ ] Dependencies up to date
- [ ] Logging implemented
- [ ] Secrets properly managed
