# Performance

## Purpose

Define performance targets, optimization guidelines, and monitoring strategies.

## Scope

**In**: Performance requirements, optimization techniques, profiling.
**Out**: Infrastructure scaling (see deployment-protocol.md if applicable).

## Do

- Set measurable performance targets
- Profile before optimizing
- Monitor performance metrics
- Optimize critical paths first

## Do Not

- Optimize prematurely
- Sacrifice readability for micro-optimizations
- Skip performance testing

## Performance Targets

Define your performance targets:

| Metric | Target | Critical Threshold |
|--------|--------|-------------------|
| API Response Time (p95) | [e.g., < 200ms] | [e.g., < 500ms] |
| Page Load Time | [e.g., < 2s] | [e.g., < 5s] |
| Time to Interactive | [e.g., < 3s] | [e.g., < 7s] |
| Database Query Time | [e.g., < 50ms] | [e.g., < 200ms] |
| Bundle Size | [e.g., < 200KB] | [e.g., < 500KB] |

## Frontend Performance

### Loading Performance

- Code splitting
- Lazy loading
- Asset optimization
- Caching strategies
- CDN usage

### Runtime Performance

- Virtual scrolling for long lists
- Debouncing/throttling
- Memoization
- Efficient re-renders
- Web Workers for heavy computation

### Bundle Optimization

- Tree shaking
- Minification
- Compression (gzip/brotli)
- Remove unused dependencies
- Analyze bundle composition

## Backend Performance

### Query Optimization

- Use indexes effectively
- Avoid N+1 queries
- Implement query caching
- Use connection pooling
- Optimize complex joins

### API Optimization

- Response compression
- Pagination for large datasets
- Rate limiting
- Request/response caching
- Background job processing

### Caching Strategy

- [Cache layers - e.g., Redis, CDN, browser]
- [Cache invalidation rules]
- [Cache TTL policies]
- [Cache warming strategies]

## Database Performance

### Indexing Strategy

- Index frequently queried fields
- Composite indexes for multi-field queries
- Monitor index usage
- Remove unused indexes

### Query Patterns

- Use database connection pooling
- Implement read replicas if needed
- Batch operations when possible
- Avoid SELECT *
- Use appropriate data types

## Monitoring

### Key Metrics

- Response times (p50, p95, p99)
- Error rates
- Throughput (requests per second)
- Resource utilization (CPU, memory, disk)
- Database query performance

### Tools

- [APM tool - e.g., New Relic, Datadog]
- [Logging - e.g., ELK, CloudWatch]
- [Profiling tools]
- [Load testing tools]

## Profiling

### When to Profile

- Before major optimizations
- After performance regressions
- During load testing
- For bottleneck identification

### Profiling Tools

- [Browser DevTools for frontend]
- [Language-specific profilers for backend]
- [Database query analyzers]

## Load Testing

- Define realistic load scenarios
- Test at expected peak load
- Test beyond capacity (stress testing)
- Monitor resource usage during tests
- Document findings and thresholds

## Optimization Checklist

- [ ] Performance targets defined
- [ ] Critical paths identified
- [ ] Monitoring implemented
- [ ] Caching strategy in place
- [ ] Database indexed appropriately
- [ ] Frontend bundle optimized
- [ ] API responses optimized
- [ ] Load testing performed
- [ ] Profiling results documented
