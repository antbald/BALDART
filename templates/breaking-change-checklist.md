# Breaking Change Checklist

**Purpose**: Ensure zero-surprise breaking changes to API contracts, with proper deprecation timeline and client migration support.

**When to Use**: Before introducing any breaking change to an existing API endpoint.

**Timeline**: Minimum 6 months from deprecation announcement to sunset (removal).

---

## What Qualifies as a Breaking Change?

A change is **breaking** if existing clients would fail or behave incorrectly without code changes:

✅ **Breaking Changes** (Require new version):
- Remove endpoint or HTTP method
- Remove request field (required or optional)
- Remove response field
- Rename request/response field
- Change field type (string → number, object → array, etc.)
- Add required request field (was optional or didn't exist)
- Change validation rules (stricter limits, new format requirements)
- Change authentication/authorization requirements
- Change error response format
- Change HTTP status codes for existing scenarios

❌ **Non-Breaking Changes** (Can update in place):
- Add optional request field
- Add response field (clients should ignore unknown fields)
- Relax validation rules (accept more input)
- Fix bugs that made endpoint unusable
- Performance improvements
- Internal refactoring (no contract change)

**When in Doubt**: Treat as breaking. Over-communicate > under-communicate.

---

## Pre-Change Checklist

### 1. Document the Decision

- [ ] **Create ADR** in `docs/decisions/ADR-YYYYMMDD-<change-description>.md`
  - **Context**: Why is this change needed? What problem does it solve?
  - **Decision**: What exactly are we changing? (Include before/after examples)
  - **Rationale**: Why is breaking change necessary? (Why can't we maintain backward compatibility?)
  - **Alternatives Considered**: What non-breaking alternatives were evaluated?
  - **Consequences**: Impact on clients, migration effort, timeline
  - **Migration Path**: How will clients migrate? (Link to migration guide)

**Example ADR filename**: `ADR-20260115-auth-otp-require-country-code.md`

### 2. Create New Versioned Endpoint

- [ ] **Create new version directory**:
  ```bash
  # If changing /api/v1/auth/otp → create /api/v2/auth/otp
  mkdir -p src/app/api/v2/auth/otp
  ```

- [ ] **Copy and modify route file**:
  ```bash
  cp src/app/api/v1/auth/otp/route.ts src/app/api/v2/auth/otp/route.ts
  # Edit v2/route.ts to implement breaking change
  ```

- [ ] **Implement breaking change** in new version ONLY
  - Old version (`/api/v1/...`) remains unchanged
  - New version (`/api/v2/...`) has new contract

### 3. Add Deprecation Headers to Old Version

- [ ] **Update old version** (`/api/v1/auth/otp/route.ts`) to add deprecation wrapper:
  ```typescript
  import { addDeprecationHeader, getSunsetDate } from "@/lib/apiVersion";

  export async function POST(req: NextRequest) {
    // Original v1 logic (unchanged)
    const data = await yourExistingLogic(req);
    const response = NextResponse.json(data);

    // Add deprecation headers
    return addDeprecationHeader(response, "v1", getSunsetDate());
  }
  ```

- [ ] **Verify deprecation headers** in response:
  ```http
  Deprecation: true
  Sunset: YYYY-MM-DD (6 months from now)
  Link: </api/v2>; rel="successor-version"
  X-Migration-Guide: https://github.com/.../docs/api-migration-v1.md
  ```

### 4. Update Documentation

- [ ] **Update API reference** (appropriate module in `docs/references/api/`):
  - Add new version entry with **Status: Current**
  - Update old version entry with **Status: Deprecated**
  - Add **Sunset** date and **Successor** link

**Example**:
```markdown
### POST /api/v2/auth/otp
**Status**: Current
**Added**: 2026-01-15 (v2)
**Breaking Changes**: Now requires `countryCode` field

[Full documentation here]

---

### POST /api/v1/auth/otp
**Status**: Deprecated
**Deprecated**: 2026-01-15
**Sunset**: 2026-07-15 (6 months)
**Successor**: `/api/v2/auth/otp`

⚠️ **Use `/api/v2/auth/otp` instead.** This version will be removed on 2026-07-15.

**Breaking Changes in v2**:
- Added required field: `countryCode` (ISO 3166-1 alpha-2, e.g., "IT", "US")
```

- [ ] **Update migration guide** if needed (add new patterns/examples)

- [ ] **Create backlog card** (if not already exists):
  - **Type**: `type: breaking-change`
  - **Status**: `IN_PROGRESS`
  - **Linked ADR**: Reference ADR filename
  - **Sunset date**: 6 months from deprecation

### 5. Test Both Versions

- [ ] **Manual testing**:
  - [ ] Old version (`/api/v1/...`) still works with old contract
  - [ ] Old version returns deprecation headers
  - [ ] New version (`/api/v2/...`) works with new contract
  - [ ] New version does NOT return deprecation headers

- [ ] **Automated testing**:
  - [ ] Add tests for v2 endpoint (new contract)
  - [ ] Verify v1 tests still pass (no regression)
  - [ ] Add test for deprecation headers on v1

**Example test**:
```typescript
describe("POST /api/v1/auth/otp (deprecated)", () => {
  it("returns deprecation headers", async () => {
    const response = await fetch("/api/v1/auth/otp", { method: "POST", ... });
    expect(response.headers.get("Deprecation")).toBe("true");
    expect(response.headers.get("Sunset")).toMatch(/\d{4}-\d{2}-\d{2}/);
  });

  it("still accepts old contract (no countryCode)", async () => {
    const response = await fetch("/api/v1/auth/otp", {
      method: "POST",
      body: JSON.stringify({ phoneNumber: "+393331234567" }), // No countryCode
    });
    expect(response.status).toBe(200);
  });
});

describe("POST /api/v2/auth/otp", () => {
  it("requires countryCode field", async () => {
    const response = await fetch("/api/v2/auth/otp", {
      method: "POST",
      body: JSON.stringify({ phoneNumber: "+393331234567" }), // Missing countryCode
    });
    expect(response.status).toBe(400); // Bad Request
  });

  it("accepts new contract with countryCode", async () => {
    const response = await fetch("/api/v2/auth/otp", {
      method: "POST",
      body: JSON.stringify({
        phoneNumber: "+393331234567",
        countryCode: "IT"
      }),
    });
    expect(response.status).toBe(200);
  });
});
```

### 6. Announce Deprecation

- [ ] **Internal announcement** (team Slack/email):
  - What's changing (endpoint + contract)
  - When it's deprecated (today)
  - When it's removed (6 months)
  - How to migrate (link to guide + ADR)

**Example announcement**:
```
🚨 **API Breaking Change Alert**

**Endpoint**: POST /api/v1/auth/otp
**Status**: Deprecated as of 2026-01-15
**Sunset**: 2026-07-15 (6 months)
**New Version**: POST /api/v2/auth/otp

**What Changed**:
The `countryCode` field is now REQUIRED in v2 (was optional/missing in v1).

**Migration**:
Update your calls to use `/api/v2/auth/otp` and include `countryCode`:
```json
{
  "phoneNumber": "+393331234567",
  "countryCode": "IT"  // ← New required field
}
```

**Docs**: See docs/api-migration-v1.md
**ADR**: docs/decisions/ADR-20260115-auth-otp-require-country-code.md
```

- [ ] **External announcement** (if API is public):
  - Blog post or changelog entry
  - Email to registered API users
  - Update API documentation site

---

## During Migration Period (Months 0-6)

### 7. Monitor Usage

- [ ] **Add logging** to old endpoint to track usage:
  ```typescript
  export async function POST(req: NextRequest) {
    // Log deprecated endpoint usage
    console.warn(`[DEPRECATED] /api/v1/auth/otp called - Sunset: ${getSunsetDate()}`);

    // Or use analytics/monitoring
    trackEvent("api.deprecated.v1.auth.otp", { userAgent: req.headers.get("user-agent") });

    // Continue with original logic...
  }
  ```

- [ ] **Track metrics**:
  - Daily/weekly request count to old endpoint
  - Unique clients calling old endpoint (by IP, user-agent, auth token)
  - Error rate on new endpoint (migration issues?)

### 8. Proactive Client Outreach

**Month 1-2** (25% through sunset period):
- [ ] Review usage metrics
- [ ] Identify top clients still using old endpoint
- [ ] Send reminder emails with migration guide

**Month 3-4** (50% through sunset period):
- [ ] Review usage metrics again
- [ ] Escalate outreach to heavy users
- [ ] Offer migration support (pair programming, code review)

**Month 5** (80% through sunset period):
- [ ] Final warning emails to remaining clients
- [ ] Announce firm removal date (sunset)
- [ ] Publish sunset countdown (30 days, 14 days, 7 days, 1 day)

### 9. Update Client Code

- [ ] **Search for old endpoint usage** in codebase:
  ```bash
  rg 'fetch.*["\x27]/api/v1/auth/otp' --type ts --type tsx
  ```

- [ ] **Update all calls** to use new version:
  ```typescript
  // Before (v1 - deprecated)
  const response = await fetch("/api/v1/auth/otp", {
    method: "POST",
    body: JSON.stringify({ phoneNumber: "+393331234567" }),
  });

  // After (v2 - current)
  const response = await fetch("/api/v2/auth/otp", {
    method: "POST",
    body: JSON.stringify({
      phoneNumber: "+393331234567",
      countryCode: "IT", // ← New required field
    }),
  });
  ```

- [ ] **Test updated code** (manual + automated)

- [ ] **Deploy updated clients** BEFORE sunset date

### 10. Backward Compatibility Strategy

**Option A: Graceful Degradation** (Recommended for minor changes)
- Old version (`/api/v1/...`) still works but returns deprecation headers
- New version (`/api/v2/...`) has enhanced functionality

**Option B: Feature Flag Rollout** (For risky changes)
- Deploy v2 behind feature flag
- Gradually roll out to 1% → 10% → 50% → 100% traffic
- Monitor error rates at each stage
- Rollback flag if issues detected

**Option C: Dual Write** (For data model changes)
- Write to both old and new schemas during migration
- Read from new schema (with fallback to old)
- Remove old schema after sunset

---

## Post-Sunset Checklist (Month 6+)

### 11. Verify Zero Traffic

- [ ] **Check usage metrics** for old endpoint:
  - Zero requests for 30+ consecutive days
  - Or <0.01% of total API traffic

- [ ] **Final warning announcement** (7 days before removal):
  ```
  🚨 **Final Notice: API Removal in 7 Days**

  **Endpoint**: POST /api/v1/auth/otp
  **Removal Date**: 2026-07-15
  **Replacement**: POST /api/v2/auth/otp

  This is your FINAL WARNING. After 2026-07-15, the old endpoint will return 410 Gone.

  If you are still using the old endpoint, migrate NOW: [migration guide link]
  ```

### 12. Remove Old Endpoint

- [ ] **Delete old route file**:
  ```bash
  rm src/app/api/v1/auth/otp/route.ts
  # Keep directory if other routes exist in v1
  ```

- [ ] **Add 410 Gone stub** (optional but recommended for 30 days):
  ```typescript
  // src/app/api/v1/auth/otp/route.ts (temporary stub)
  import { NextRequest, NextResponse } from "next/server";

  export async function POST(req: NextRequest) {
    return NextResponse.json(
      {
        error: "This endpoint has been removed",
        message: "POST /api/v1/auth/otp was sunset on 2026-07-15",
        successor: "/api/v2/auth/otp",
        migrationGuide: "https://github.com/.../docs/api-migration-v1.md"
      },
      { status: 410 } // 410 Gone (permanent removal)
    );
  }
  ```

- [ ] **Remove 410 stub** after 30 days (now return 404 from framework)

### 13. Update Documentation

- [ ] **Remove old endpoint** from appropriate `docs/references/api/*.md` module
  - Or move to "Removed Endpoints" section with removal date

- [ ] **Update migration guide** if needed (mark migration complete)

- [ ] **Create removal ADR**:
  - `docs/decisions/ADR-YYYYMMDD-remove-v1-auth-otp.md`
  - **Context**: Old endpoint sunset date reached, zero traffic confirmed
  - **Decision**: Removed `/api/v1/auth/otp` on YYYY-MM-DD
  - **Consequences**: Clients using old endpoint will receive 410 Gone (or 404 after stub removed)

### 14. Clean Up Code

- [ ] **Remove feature flags** (if used for rollout)

- [ ] **Remove dual-write code** (if used for data model migration)

- [ ] **Remove monitoring/logging** specific to old endpoint

- [ ] **Archive related backlog cards**:
  - Mark breaking change card as `DONE`
  - Add completion notes (removal date, final usage metrics)

### 15. Post-Mortem (Optional but Recommended)

- [ ] **Review migration metrics**:
  - How many clients migrated proactively vs. reactively?
  - Did we have any surprise breakages?
  - Was 6-month timeline sufficient?
  - Were deprecation headers effective?

- [ ] **Document lessons learned** in ADR or team wiki

- [ ] **Update this checklist** if needed (new best practices discovered)

---

## Emergency Rollback

**If breaking change causes unexpected issues:**

### Option 1: Immediate Revert (Recommended)
```bash
git revert <commit-hash>  # Revert the breaking change commit
git push origin main      # Deploy old version immediately
```

### Option 2: Feature Flag Rollback
```typescript
// Temporarily disable v2 endpoint
export async function POST(req: NextRequest) {
  const useV2 = process.env.ENABLE_V2_AUTH_OTP === "true";

  if (!useV2) {
    // Fallback to v1 logic
    return v1Handler(req);
  }

  // v2 logic
  return v2Handler(req);
}
```

### Option 3: Traffic Routing
- Route 100% traffic back to old endpoint via load balancer/reverse proxy
- Fix issues in new endpoint
- Gradually re-enable new endpoint

**Post-Rollback**:
- [ ] Notify clients about rollback
- [ ] Investigate root cause
- [ ] Fix issue in new version
- [ ] Re-test thoroughly
- [ ] Re-deploy with extended sunset timeline (e.g., +2 months)

---

## Examples

### Example 1: Add Required Field

**Breaking Change**: POST /api/v1/coupons/redeem now requires `restaurantId` field.

**Checklist**:
- ✅ ADR: `ADR-20260120-coupons-redeem-require-restaurant-id.md`
- ✅ New version: `/api/v2/coupons/redeem` (requires `restaurantId`)
- ✅ Old version: `/api/v1/coupons/redeem` (deprecation headers, works without `restaurantId`)
- ✅ Sunset: 2026-07-20 (6 months)
- ✅ Tests: v1 accepts old contract, v2 rejects missing `restaurantId`

### Example 2: Remove Response Field

**Breaking Change**: GET /api/v1/user/dashboard removes `legacyStats` field from response.

**Checklist**:
- ✅ ADR: `ADR-20260125-dashboard-remove-legacy-stats.md`
- ✅ New version: `/api/v2/user/dashboard` (no `legacyStats` in response)
- ✅ Old version: `/api/v1/user/dashboard` (deprecation headers, still returns `legacyStats`)
- ✅ Sunset: 2026-07-25 (6 months)
- ✅ Client migration: Update code to not rely on `legacyStats` field

### Example 3: Change Field Type

**Breaking Change**: POST /api/v1/receipts/upload changes `totalAmount` from string to number.

**Checklist**:
- ✅ ADR: `ADR-20260201-receipts-total-amount-type-change.md`
- ✅ New version: `/api/v2/receipts/upload` (accepts `totalAmount: 12.34` as number)
- ✅ Old version: `/api/v1/receipts/upload` (deprecation headers, accepts `totalAmount: "12.34"` as string)
- ✅ Sunset: 2026-08-01 (6 months)
- ✅ Migration: Clients update to send number instead of string

---

## See Also

- [docs/api-migration-v1.md](../docs/api-migration-v1.md) - Complete migration guide for URL-based versioning
- TODO (needs confirmation): document the current location of any API versioning utilities (previously referenced as `src/lib/apiVersion.ts`)
- [docs/references/api/index.md](../docs/references/api/index.md) - API inventory with deprecation status (split into modules)
- [RFC 8594](https://www.rfc-editor.org/rfc/rfc8594.html) - HTTP Deprecation Header standard
- [docs/decisions/ADR-20260107-drift-prevention-protocols.md](../docs/decisions/ADR-20260107-drift-prevention-protocols.md) - Why we chose URL-based versioning
