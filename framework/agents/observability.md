# Observability

## Purpose

Define logging, monitoring, and alerting strategies.

## Scope

**In**: Logging standards, metrics, tracing, alerting.
**Out**: Performance optimization (see agents/performance.md).

## Do

- Log important events with context
- Monitor key metrics
- Set up alerts for critical issues
- Implement distributed tracing if applicable

## Do Not

- Log sensitive data (passwords, tokens, PII)
- Over-log (creates noise)
- Ignore warning signs

## Logging

### Log Levels

- **ERROR**: Application errors requiring immediate attention
- **WARN**: Warning conditions that should be reviewed
- **INFO**: Important business events
- **DEBUG**: Detailed diagnostic information

### Log Format

Use structured logging:

```json
{
  "timestamp": "2026-02-13T10:00:00Z",
  "level": "INFO",
  "message": "User logged in",
  "userId": "123",
  "context": {
    "ip": "192.168.1.1",
    "userAgent": "..."
  }
}
```

### What to Log

- Authentication attempts
- Authorization failures
- API requests/responses (sanitized)
- Database errors
- External service calls
- Business-critical events
- Performance anomalies

### What NOT to Log

- Passwords
- API keys/tokens
- Credit card numbers
- PII (unless required and encrypted)
- Large payloads

## Metrics

### Application Metrics

- Request count
- Response times
- Error rates
- Active users
- Business metrics (signups, conversions, etc.)

### Infrastructure Metrics

- CPU usage
- Memory usage
- Disk I/O
- Network I/O
- Database connections

### Custom Metrics

Define project-specific metrics:

- [Business metric 1]
- [Business metric 2]
- [Technical metric 1]

## Tracing (if applicable)

- Implement distributed tracing for microservices
- Trace IDs through request lifecycle
- Track latency across services
- Identify bottlenecks

## Alerting

### Alert Levels

- **Critical**: Immediate action required (page on-call)
- **High**: Requires attention within hours
- **Medium**: Review during business hours
- **Low**: Informational

### Alert Criteria

Define when to alert:

| Metric | Threshold | Level |
|--------|-----------|-------|
| Error rate | > 5% | Critical |
| Response time (p95) | > 2s | High |
| CPU usage | > 80% | High |
| Disk space | < 10% | Critical |
| [Custom metric] | [Threshold] | [Level] |

### Alert Channels

- [On-call system - e.g., PagerDuty]
- [Team chat - e.g., Slack]
- [Email]
- [SMS for critical]

## Dashboards

Create dashboards for:

- System health overview
- Application performance
- Business metrics
- Error tracking
- User activity

## Incident Response

1. Alert fires
2. On-call acknowledges
3. Investigate using logs/metrics
4. Mitigate issue
5. Create post-mortem
6. Implement preventive measures

## Tools

- **Logging**: [e.g., ELK, Loki, CloudWatch]
- **Metrics**: [e.g., Prometheus, Datadog, CloudWatch]
- **Tracing**: [e.g., Jaeger, Zipkin, X-Ray]
- **Alerting**: [e.g., PagerDuty, Opsgenie, Grafana]
- **Dashboards**: [e.g., Grafana, Kibana, Datadog]

## Log Retention

- [Production logs retention - e.g., 30 days]
- [Error logs retention - e.g., 90 days]
- [Audit logs retention - e.g., 1 year]
- [Archive policy]
