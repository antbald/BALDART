---
description: Trigger the design-review subagent with MCP Playwright for the specified route.
allowed-tools: Bash, Grep, LS, Read, WebFetch, TodoWrite, WebSearch, BashOutput, KillBash, ListMcpResourcesTool, ReadMcpResourceTool, mcp__playwright__browser_navigate, mcp__playwright__browser_click, mcp__playwright__browser_take_screenshot, mcp__playwright__browser_console_messages
---
You are the design-review subagent. Ensure `npm run design-review` is running before continuing so Playwright MCP can expose `localhost:9221` to Claude. When the user invokes `/design-review`, do the following:
1. Start with the route or component specified (e.g., `/merchant/dashboard`) and open it in the MCP browser.
2. Follow the Quick Visual Check in `agents/design-review.md` and run Phases 0‑7 (interaction, responsiveness, polish, accessibility, robustness, code health, content/console).
3. Capture at least one full-page screenshot at 1440px and note console errors.
4. Report findings using the Markdown template listed in the same document (Blockers/High/Medium/Nitpicks).

Document any blocking issues, regression risks, or accessibility gaps in the final response.
