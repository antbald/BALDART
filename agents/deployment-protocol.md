# Deployment Protocol

## Purpose

Define safe deployment procedures and rollback strategies.

## Scope

**In**: Deployment steps, environments, rollback procedures, pre/post checks.
**Out**: Infrastructure details (see agents/runbook.md).

## Do

- Follow deployment checklist
- Test in staging before production
- Have rollback plan ready
- Document deployment results

## Do Not

- Deploy without testing
- Skip pre-deployment checks
- Deploy during peak hours (unless emergency)

## Environments

| Environment | Purpose | Deployment Frequency | Auto-Deploy |
|-------------|---------|---------------------|-------------|
| Development | Local dev | Continuous | N/A |
| Staging | Pre-production testing | On PR merge | Optional |
| Production | Live users | Manual/Scheduled | Conditional |

## Deployment Checklist

### Pre-Deployment

- [ ] All tests passing
- [ ] Code review approved
- [ ] Staging deployment successful
- [ ] Database migrations tested
- [ ] Rollback plan documented
- [ ] Monitoring alerts configured
- [ ] Team notified of deployment
- [ ] Maintenance window scheduled (if needed)

### Deployment Steps

1. **Verify current state**
   ```bash
   [command to check current version/state]
   ```

2. **Create backup**
   ```bash
   [backup command]
   ```

3. **Run database migrations** (if applicable)
   ```bash
   [migration command]
   ```

4. **Deploy new version**
   ```bash
   [deploy command]
   ```

5. **Health check**
   ```bash
   [health check command or URL to check]
   ```

6. **Smoke tests**
   - [ ] Homepage loads
   - [ ] Authentication works
   - [ ] Critical user flows work
   - [ ] No error spikes in logs

### Post-Deployment

- [ ] Monitor error rates for 15 minutes
- [ ] Check performance metrics
- [ ] Verify database connections stable
- [ ] Test critical user flows manually
- [ ] Update deployment log
- [ ] Notify team of completion

## Rollback Procedure

### When to Rollback

- Error rate > 5% increase
- Critical feature broken
- Performance degradation > 50%
- Data corruption detected

### Rollback Steps

1. **Announce rollback**
   ```bash
   # Notify team
   ```

2. **Revert to previous version**
   ```bash
   [rollback command]
   ```

3. **Rollback database** (if needed)
   ```bash
   [db rollback command]
   ```

4. **Verify health**
   ```bash
   [health check]
   ```

5. **Document issue**
   - What went wrong
   - Why it wasn't caught
   - How to prevent in future

## Deployment Strategies

### Blue-Green Deployment (if applicable)

1. Deploy to green environment
2. Test green environment
3. Switch traffic to green
4. Keep blue as rollback option

### Canary Deployment (if applicable)

1. Deploy to subset of servers
2. Monitor metrics for canary group
3. Gradually increase percentage
4. Rollback if issues detected

### Rolling Deployment (if applicable)

1. Deploy to one server at a time
2. Verify health after each
3. Continue to next server
4. Rollback if issues detected

## Database Migrations

### Migration Checklist

- [ ] Migration tested locally
- [ ] Migration tested in staging
- [ ] Backup created before migration
- [ ] Migration is reversible
- [ ] Rollback migration tested

### Migration Best Practices

- Make migrations backwards compatible when possible
- Avoid locking tables during peak hours
- Test with production-sized data
- Have rollback SQL ready

## Monitoring During Deployment

Watch these metrics:

- **Error rate**: Should not increase
- **Response time**: Should remain stable
- **CPU/Memory**: Should remain within limits
- **Database connections**: Should remain stable
- **Queue depth**: Should not grow

## Emergency Hotfix Process

1. **Identify critical issue**
2. **Create hotfix branch** from production
3. **Minimal fix** - only address critical issue
4. **Fast-track review** (but still review!)
5. **Deploy with monitoring**
6. **Back-port to main** branch
7. **Post-mortem** - why did this slip through?

## Deployment Schedule

- **Staging**: Automatic on PR merge to main
- **Production**: [Your schedule - e.g., Mon/Wed/Fri 10am]
- **Hotfixes**: As needed, any time
- **Avoid**: Friday afternoons, holidays, weekends (unless emergency)

## Communication

### Before Deployment

- Notify team in [channel]
- Post in deployment log
- Schedule maintenance window if needed

### During Deployment

- Update status in [channel]
- Monitor alerts
- Be ready to rollback

### After Deployment

- Announce completion
- Share metrics
- Document any issues

## Deployment Log

Maintain a deployment log:

```markdown
## YYYY-MM-DD HH:MM - Version X.Y.Z

**Deployer**: [Name]
**Changes**: [Brief description or link to changelog]
**Status**: Success/Rollback
**Issues**: [Any issues encountered]
**Metrics**:
- Deployment time: [duration]
- Error rate: [before] -> [after]
- Response time: [before] -> [after]
```

## Access Control

- **Who can deploy**: [Roles/people]
- **Approval required**: [Yes/No, by whom]
- **Emergency access**: [Contact info]
