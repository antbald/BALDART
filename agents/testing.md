# Testing

## Purpose

Define required manual testing and QA issue workflow, including browser automation.

## Scope

**In**: Manual testing steps, QA issue creation and handling, browser automation.
**Out**: Performance testing strategy (see agents/performance.md).

## Do

- Run project build command before marking a card done.
- Manually test changed flows in development environment.
- Record results in the backlog card.

## Do Not

- Close QA issues after a fix (leave open with `vibe review`).

## Manual Testing Protocol (MVP)

1. Run test suite when tests exist.
2. Run build command (must pass).
3. Run development server and manually test changed flows.
4. Record results in card notes.

## Manual Test Checklist

- Happy path works end-to-end
- Error cases handled gracefully
- Loading states shown
- Mobile viewport tested (for UI changes)
- Authentication/authorization works
- No console errors in browser/logs

## Browser Automation Testing (if applicable)

For UI/frontend changes, consider using browser automation tools (e.g., Playwright, Cypress, Selenium):

### When to Use Browser Automation

- Testing user flows (login, checkout, form submissions)
- Validating responsive design across viewports
- Capturing screenshots for visual regression
- Checking browser console for errors
- Verifying loading states and animations
- Testing accessibility (tab navigation, focus states)

### Browser Test Examples

**Test a page across viewports:**

```
Test the dashboard page at desktop (1920x1080),
tablet (768x1024), and mobile (375x667) viewports
```

**Test authentication flow:**

```
Test the login flow: fill credentials, submit,
verify redirect to dashboard
```

**Capture screenshots:**

```
Capture full-page screenshots of the marketing page
at desktop and mobile sizes
```

## QA Issue Methodology (Manual)

- One GitHub issue per test case (atomic scope).
- Labels: `qa` + one macro area (customize for your project - e.g., `area:frontend`, `area:api`, `area:admin`).
- When a GitHub issue is fixed: add a fix summary comment, apply `vibe review`, leave it open.
- If a test passes: leave the issue open with a short note.
- If a test fails: keep it open with details and evidence.
- Open QA issues are the source of truth for unresolved bugs.

### QA Evidence

When creating or updating QA issues:

- Include reproduction steps
- Attach screenshots/videos if visual bugs
- Note environment details (browser, viewport, OS)
- Include error logs/console output if relevant
- Add test scripts that reproduce the issue (if using automation)

## Test Coverage (if applicable)

- [Define coverage requirements - e.g., minimum 80% coverage]
- [Critical paths requiring 100% coverage]
- [Areas exempt from coverage requirements]

## Test Organization

- [Test file location conventions]
- [Test naming conventions]
- [Integration vs unit test guidelines]
- [End-to-end test guidelines]

## Continuous Integration

- [CI test requirements]
- [When tests run (pre-commit, pre-push, PR)]
- [Test failure handling policy]
- [Flaky test management]
