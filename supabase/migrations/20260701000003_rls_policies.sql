-- ╔══════════════════════════════════════════════════════════════╗
-- ║ PERISAI — Row Level Security Policies                          ║
-- ╚══════════════════════════════════════════════════════════════╝
--
-- Access model:
-- • Parent (authenticated)    → CRUD on their own children & detection data
-- • Kid's phone (anon)        → NO direct table access; only via
--                               RPC SECURITY DEFINER (update_child_connection,
--                               get_pairing_info)
-- • Native service            → uses the service_role key which bypasses RLS entirely

-- ─── parents ─────────────────────────────────────────────────────
alter table public.parents enable row level security;

-- Parent reads their own profile
create policy "parents_select_own"
  on public.parents for select
  to authenticated
  using (id = auth.uid());

-- Parent updates their own profile (e.g. avatar_url)
create policy "parents_update_own"
  on public.parents for update
  to authenticated
  using (id = auth.uid())
  with check (id = auth.uid());

-- Note: INSERT on parents is handled by the handle_new_user trigger (SECURITY DEFINER),
-- so no INSERT policy is needed for authenticated.

-- ─── children ────────────────────────────────────────────────────
alter table public.children enable row level security;

create policy "children_select_own"
  on public.children for select
  to authenticated
  using (parent_id = auth.uid());

create policy "children_insert_own"
  on public.children for insert
  to authenticated
  with check (parent_id = auth.uid());

create policy "children_update_own"
  on public.children for update
  to authenticated
  using (parent_id = auth.uid())
  with check (parent_id = auth.uid());

create policy "children_delete_own"
  on public.children for delete
  to authenticated
  using (parent_id = auth.uid());

-- ─── detections ──────────────────────────────────────────────────
alter table public.detections enable row level security;

-- Parent reads their children's detections (via join to children)
create policy "detections_select_own"
  on public.detections for select
  to authenticated
  using (
    exists (
      select 1 from public.children c
      where c.id = detections.child_id
        and c.parent_id = auth.uid()
    )
  );

-- Note: INSERT on detections is done by the native service with service_role
-- (bypasses RLS), so no INSERT policy is needed for authenticated/anon.
