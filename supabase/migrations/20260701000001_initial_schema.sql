-- ╔══════════════════════════════════════════════════════════════╗
-- ║ PERISAI — Initial Schema                                       ║
-- ║ Tables: parents, children, detections                         ║
-- ╚══════════════════════════════════════════════════════════════╝

-- Extension for gen_random_uuid() (usually already enabled in Supabase)
create extension if not exists "pgcrypto";

-- ─── Table: parents ──────────────────────────────────────────────
-- One row per parent. id = auth.users.id (created via trigger).
create table if not exists public.parents (
  id         uuid primary key references auth.users (id) on delete cascade,
  name       text not null default '',
  email      text,
  avatar_url text,
  created_at timestamptz not null default now()
);

comment on table public.parents is 'Parent profile, auto-created on signup via trigger handle_new_user';

-- ─── Table: children ─────────────────────────────────────────────
create table if not exists public.children (
  id                uuid primary key default gen_random_uuid(),
  parent_id         uuid not null references public.parents (id) on delete cascade,
  child_name        text not null,
  age               int  not null check (age >= 0 and age <= 18),
  phone             text,
  avatar_url        text,
  connection_status text not null default 'offline_manual'
                    check (connection_status in ('online', 'offline_internet', 'offline_manual')),
  last_seen         timestamptz,
  -- If set and > now(), monitoring is temporarily paused by the parent.
  -- Enforcement is in the RPC update_child_connection (see migration functions).
  paused_until      timestamptz,
  created_at        timestamptz not null default now()
);

comment on table public.children is 'Kid''s phone connected to one parent';
comment on column public.children.paused_until is 'If > now(), monitoring is temporarily paused by the parent';

create index if not exists idx_children_parent_id on public.children (parent_id);

-- ─── Table: detections ───────────────────────────────────────────
create table if not exists public.detections (
  id             uuid primary key default gen_random_uuid(),
  child_id       uuid not null references public.children (id) on delete cascade,
  screenshot_url text not null default '',
  confidence     real not null default 0,
  triggered_by   text not null default '',
  keywords       jsonb not null default '[]'::jsonb,
  details        jsonb not null default '{}'::jsonb,
  created_at     timestamptz not null default now()
);

comment on table public.detections is 'Detection history of gambling content from the kid''s phone';

create index if not exists idx_detections_child_id   on public.detections (child_id);
create index if not exists idx_detections_created_at on public.detections (created_at desc);
