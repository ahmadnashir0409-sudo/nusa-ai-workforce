# Security baseline

- Browser code may contain only Supabase publishable/anon credentials.
- Never expose service-role keys, database passwords or Cloudflare API tokens.
- Worker validates bearer tokens before accepting commands.
- All application tables enable Row Level Security.
- AI output is untrusted and validated before persistence.
- No external tool execution is enabled in this milestone.
- Require CEO approval before sending messages, publishing, deleting data, changing permissions, spending money or modifying production systems.
- Use a dedicated Supabase project; do not reuse Nusa Pixel Studio or KDMP production databases.
- Add rate limits, usage budgets, monitoring and secret rotation before public launch.
