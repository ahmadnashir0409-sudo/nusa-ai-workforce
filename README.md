# NUSA AI WORKFORCE

AI workforce command center for Nusa Pixel business operations and a separate personal workspace.

## Repository structure
- `apps/web` — responsive CEO dashboard, employee roster, task plans, approval view and Supabase Auth.
- `apps/worker` — Cloudflare Worker API and Workers AI planning endpoint.
- `supabase/migrations` — initial database schema and row-level security policies.
- `docs` — architecture, roadmap and security baseline.

## Current status
This is the **planning MVP scaffold**. It can authenticate users, request a structured task plan from Workers AI, validate it and save it to Supabase. It does **not** yet autonomously execute external actions, send messages, publish content, make payments, or modify production systems. End-to-end deployment testing remains outstanding.

## Setup
1. Create a **new dedicated Supabase project** named `nusa-ai-workforce`. Do not reuse the existing Nusa Pixel Studio or KDMP production projects.
2. Run `supabase/migrations/0001_initial_schema.sql` in that new project's SQL Editor.
3. Enable Supabase Email Auth.
4. Copy `apps/web/config.js` and fill `SUPABASE_URL`, `SUPABASE_ANON_KEY`, and `API_BASE_URL`.
5. In `apps/worker`, run `npm install`.
6. Set Worker secrets with `npx wrangler secret put SUPABASE_URL` and `npx wrangler secret put SUPABASE_ANON_KEY`.
7. Run `npx wrangler dev` for local API development and serve `apps/web` from a local static server.
8. Deploy the Worker with `npx wrangler deploy`, then deploy the static web app.

Never place a Supabase service-role key, database password, or Cloudflare API token in browser code or commit them to Git.

## Local development
- Worker: `cd apps/worker && npm install && npm run dev`
- Static web app: serve `apps/web` on `http://localhost:8080` (the default Worker CORS origin).

Review `docs/SECURITY.md` before connecting any external tools. Sensitive actions must remain approval-gated.
