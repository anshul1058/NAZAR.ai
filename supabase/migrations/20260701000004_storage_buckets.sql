-- ╔══════════════════════════════════════════════════════════════╗
-- ║ PERISAI — Storage Buckets & Policies                          ║
-- ╚══════════════════════════════════════════════════════════════╝
--
-- Two buckets:
-- • avatars     (PUBLIC)  — profile photo of parent & kid. Path: <id>/profile.jpg
-- • screenshots (PRIVATE) — detection screenshot. Path: <child_id>/<ts>.jpg
--                           Read by the parent via signed URL, written by the native
--                           service (service_role, bypass RLS).

-- ─── Buckets ─────────────────────────────────────────────────────
insert into storage.buckets (id, name, public)
values ('avatars', 'avatars', true)
on conflict (id) do nothing;

insert into storage.buckets (id, name, public)
values ('screenshots', 'screenshots', false)
on conflict (id) do nothing;

-- ─── Policies: avatars (public read, authenticated write) ────────
create policy "avatars_public_read"
  on storage.objects for select
  using (bucket_id = 'avatars');

create policy "avatars_auth_insert"
  on storage.objects for insert
  to authenticated
  with check (bucket_id = 'avatars');

create policy "avatars_auth_update"
  on storage.objects for update
  to authenticated
  using (bucket_id = 'avatars')
  with check (bucket_id = 'avatars');

-- ─── Policies: screenshots (private, parent reads own kid) ───────
-- Path = <child_id>/<timestamp>.jpg → the first folder is the child_id.
-- The parent can only read screenshots of their own kid.
create policy "screenshots_select_own"
  on storage.objects for select
  to authenticated
  using (
    bucket_id = 'screenshots'
    and exists (
      select 1 from public.children c
      where c.parent_id = auth.uid()
        and c.id::text = (storage.foldername(name))[1]
    )
  );

-- Note: INSERT on screenshots is done by the native service with service_role
-- (bypasses RLS), so no INSERT policy is needed.
