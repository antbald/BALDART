# Maintenance Protocol

## Purpose

Define routine maintenance tasks and procedures.

## Scope

**In**: Dependency updates, database maintenance, cleanup tasks, health checks.
**Out**: Emergency procedures (see agents/deployment-protocol.md).

## Do

- Schedule regular maintenance
- Test updates in staging first
- Document maintenance activities
- Keep dependencies up to date

## Do Not

- Skip maintenance windows
- Update production directly
- Ignore security updates

## Maintenance Schedule

### Daily

- [ ] Check error logs
- [ ] Monitor system health
- [ ] Review performance metrics
- [ ] Check disk space

### Weekly

- [ ] Review security advisories
- [ ] Check for dependency updates
- [ ] Analyze slow queries
- [ ] Review recent deployments

### Monthly

- [ ] Update dependencies
- [ ] Database optimization
- [ ] Review access logs
- [ ] Clean up old data
- [ ] Review backup procedures
- [ ] Test disaster recovery

### Quarterly

- [ ] Security audit
- [ ] Performance review
- [ ] Capacity planning
- [ ] Documentation review
- [ ] Dependency major version updates

### Annually

- [ ] Comprehensive security review
- [ ] Architecture review
- [ ] Technology stack evaluation
- [ ] Disaster recovery drill
- [ ] SSL certificate renewal

## Dependency Management

### Checking for Updates

```bash
# Check for outdated packages
[command - e.g., npm outdated, pip list --outdated]
```

### Update Strategy

1. **Patch updates** (x.x.X): Apply immediately
2. **Minor updates** (x.X.x): Test in staging, deploy within week
3. **Major updates** (X.x.x): Plan, test thoroughly, may require code changes

### Update Process

1. Check changelog for breaking changes
2. Update in development
3. Run tests
4. Deploy to staging
5. Test critical flows
6. Deploy to production
7. Monitor for issues

## Database Maintenance

### Regular Tasks

```bash
# Analyze tables (example for PostgreSQL)
ANALYZE;

# Vacuum database
VACUUM;

# Check database size
[command]

# Optimize tables (if applicable)
[command]
```

### Index Maintenance

- Review slow query log
- Identify missing indexes
- Remove unused indexes
- Rebuild fragmented indexes

### Data Cleanup

- Archive old records
- Delete soft-deleted records
- Clean up orphaned data
- Purge expired sessions

## Log Management

### Log Rotation

- Rotate logs daily/weekly
- Compress old logs
- Delete logs older than retention period
- Archive important logs

### Log Analysis

- Review error patterns
- Identify slow operations
- Check for security issues
- Monitor resource usage

## Backup Verification

### Regular Checks

```bash
# List recent backups
[command]

# Test backup restoration
[command]

# Verify backup integrity
[command]
```

### Backup Schedule

- **Database**: Daily, keep 30 days
- **Files**: Weekly, keep 12 weeks
- **Full system**: Monthly, keep 12 months
- **Critical data**: Real-time replication

## Security Maintenance

### SSL Certificates

- Monitor expiration dates
- Renew 30 days before expiry
- Test after renewal
- Update certificate pinning if used

### Access Review

- Review user accounts
- Remove inactive users
- Review permissions
- Rotate API keys/secrets

### Security Patches

- Monitor security advisories
- Apply critical patches immediately
- Test non-critical patches in staging
- Document all security updates

## Performance Optimization

### Regular Reviews

- Analyze slow queries
- Review API response times
- Check resource usage trends
- Identify bottlenecks

### Cache Management

```bash
# Clear cache
[command]

# Warm cache
[command]

# Review cache hit rate
[command]
```

## Health Checks

### System Health

```bash
# Check service status
[command]

# Check disk space
[command]

# Check memory usage
[command]

# Check CPU usage
[command]
```

### Application Health

```bash
# Health endpoint
curl [health-check-url]

# Database connection
[command]

# External service status
[command]
```

## Incident Prevention

### Monitoring

- Set up alerts for:
  - High error rates
  - Slow response times
  - High resource usage
  - Failed health checks
  - Security events

### Proactive Actions

- Scale before reaching capacity
- Fix issues before they become critical
- Update before forced by security issues
- Document before knowledge is lost

## Maintenance Windows

### Planning

1. Announce maintenance window
2. Schedule during low-traffic period
3. Prepare rollback plan
4. Test procedures in staging

### During Maintenance

1. Put site in maintenance mode (if applicable)
2. Perform maintenance tasks
3. Run health checks
4. Verify functionality
5. Return to normal operation

### After Maintenance

1. Monitor for issues
2. Document what was done
3. Review if maintenance was successful
4. Schedule next maintenance

## Documentation

Maintain maintenance log:

```markdown
## YYYY-MM-DD: [Maintenance Type]

**Performed by**: [Name]
**Duration**: [Time]
**Tasks completed**:
- [Task 1]
- [Task 2]

**Issues encountered**: [None or description]
**Follow-up actions**: [Any actions needed]
```

## Emergency Maintenance

For critical issues requiring immediate maintenance:

1. Notify team
2. Document issue
3. Perform fix
4. Test immediately
5. Monitor closely
6. Post-mortem after resolution
