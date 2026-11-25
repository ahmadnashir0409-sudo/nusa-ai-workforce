# Architecture

1. CEO signs in through Supabase Auth.
2. Browser sends the access token and a goal to the Cloudflare Worker.
3. Worker validates the token against Supabase Auth.
4. Workers AI generates a structured plan.
5. Worker validates the model output and saves it using the caller JWT.
6. Supabase RLS limits records to the authenticated owner.

## Roles
- AI Director: decomposes goals and delegates.
- Secretary: schedules, notes and drafts.
- Developer: implementation plans, code review and tests.
- Marketing: research, content and lead qualification.
- Finance: budgets and analysis.
- Researcher: source-based research.
- Personal Assistant: private planning and reminders.

This first milestone is plan-only. The Agent class is scaffolded, but specialist tool execution, durable queues and external integrations are not enabled yet. Company and personal workspaces must remain separated.
