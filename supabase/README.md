# Supabase — Database & Migrations

This folder contains the PERISAI database schema as **versioned migration SQL** tracked in git.

## Structure

```text
supabase/
└─ migrations/
   ├─ 20260701000001_initial_schema.sql        # tables: parents, children, detections
   ├─ 20260701000002_functions_and_triggers.sql  # handle_new_user, RPCs
   ├─ 20260701000003_rls_policies.sql          # Row Level Security
   ├─ 20260701000004_storage_buckets.sql       # avatars + screenshots buckets
   └─ 20260701000005_pause_enforcement.sql     # update_child_connection respects paused_until
```

## How to Apply

### Option A — Supabase Dashboard (fastest)

1. Open the project → **SQL Editor**
2. Run each migration file **in order** (0001 → 0002 → 0003 → 0004)
3. Copy the file contents, paste, click **Run**

### Option B — Supabase CLI (recommended for teams)

```bash
# Install the CLI: https://supabase.com/docs/guides/cli
supabase link --project-ref <project-ref>
supabase db push
```

### Option C — GitHub Integration (auto-deploy)

If the project is connected to this repo via the Supabase GitHub Integration,
every new migration pushed to `main` is auto-applied. See
[Supabase branching docs](https://supabase.com/docs/guides/deployment/branching).

## Access Model (RLS)

| Actor | Access method | Rights |
|-------|--------------|--------|
| Parent (authenticated) | Supabase Auth session | CRUD their own children & detections |
| Child's phone (anon) | anon key, no session | Only via the `update_child_connection` & `get_pairing_info` RPCs |
| Native service | service_role key | Bypasses RLS (insert detections, upload screenshots) |

## Functions (RPCs)

- **`update_child_connection(p_child_id, p_status, p_last_seen)`** — updates the
  connection status + heartbeat. Called by the child's phone & native.
- **`get_pairing_info(p_child_id)`** — fetches the child's name & parent's name for
  the "Connected" screen. Avoids direct SELECTs blocked by RLS.

## Storage Buckets

- **`avatars`** (public) — profile photos for parents & children
- **`screenshots`** (private) — detection screenshots, read by parents via signed URLs

## Adding a New Migration

**DON'T edit existing migration files** (already applied in production).
Always create a new file with a larger timestamp:

```text
20260702000001_change_name.sql
```

Use `create or replace` for functions, `alter table` for new columns.