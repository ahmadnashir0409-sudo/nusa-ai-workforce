-- Apply only to a NEW dedicated Supabase project. Never run on KDMP production.
create extension if not exists pgcrypto;
create table if not exists public.workspaces(id uuid primary key default gen_random_uuid(),owner_id uuid not null references auth.users(id) on delete cascade,workspace_type text not null check(workspace_type in('company','personal')),name text not null,created_at timestamptz not null default now(),unique(owner_id,workspace_type));
create table if not exists public.task_plans(id uuid primary key default gen_random_uuid(),owner_id uuid not null references auth.users(id) on delete cascade,workspace_type text not null check(workspace_type in('company','personal')),goal text not null check(char_length(goal) between 8 and 3000),title text not null,summary text not null default '',assignees jsonb not null default '[]'::jsonb,steps jsonb not null default '[]'::jsonb,requires_approval boolean not null default false,approval_reasons jsonb not null default '[]'::jsonb,status text not null default 'planned' check(status in('planned','queued','running','blocked','completed','failed','cancelled')),created_at timestamptz not null default now(),updated_at timestamptz not null default now());
create table if not exists public.audit_events(id uuid primary key default gen_random_uuid(),owner_id uuid not null references auth.users(id) on delete cascade,workspace_type text not null check(workspace_type in('company','personal')),event_type text not null,entity_id uuid,details jsonb not null default '{}'::jsonb,created_at timestamptz not null default now());
create index if not exists task_plans_owner_created_idx on public.task_plans(owner_id,created_at desc);
create index if not exists task_plans_owner_workspace_idx on public.task_plans(owner_id,workspace_type);
create index if not exists audit_events_owner_created_idx on public.audit_events(owner_id,created_at desc);
alter table public.workspaces enable row level security;alter table public.task_plans enable row level security;alter table public.audit_events enable row level security;
create policy "owners manage own workspaces" on public.workspaces for all to authenticated using((select auth.uid())=owner_id) with check((select auth.uid())=owner_id);
create policy "owners read own task plans" on public.task_plans for select to authenticated using((select auth.uid())=owner_id);
create policy "owners insert own task plans" on public.task_plans for insert to authenticated with check((select auth.uid())=owner_id);
create policy "owners update own task plans" on public.task_plans for update to authenticated using((select auth.uid())=owner_id) with check((select auth.uid())=owner_id);
create policy "owners read own audit events" on public.audit_events for select to authenticated using((select auth.uid())=owner_id);
create policy "owners insert own audit events" on public.audit_events for insert to authenticated with check((select auth.uid())=owner_id);
grant select,insert,update on public.workspaces to authenticated;grant select,insert,update on public.task_plans to authenticated;grant select,insert on public.audit_events to authenticated;
create or replace function public.create_default_workspaces() returns trigger language plpgsql security definer set search_path='' as $$ begin insert into public.workspaces(owner_id,workspace_type,name) values(new.id,'company','Nusa Pixel Company'),(new.id,'personal','Personal Assistant') on conflict(owner_id,workspace_type) do nothing;return new;end;$$;
drop trigger if exists on_auth_user_created_workspaces on auth.users;
create trigger on_auth_user_created_workspaces after insert on auth.users for each row execute function public.create_default_workspaces();
