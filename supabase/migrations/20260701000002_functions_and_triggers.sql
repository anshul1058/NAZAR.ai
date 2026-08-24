-- ╔══════════════════════════════════════════════════════════════╗
-- ║ PERISAI — Functions & Triggers                                 ║
-- ╚══════════════════════════════════════════════════════════════╝

-- ─── handle_new_user ─────────────────────────────────────────────
-- Auto-create a parents row when a new user signs up in auth.users.
-- Take the name from user_metadata.full_name sent during registration.
create or replace function public.handle_new_user()
returns trigger
language plpgsql
security definer
set search_path = public
as $$
begin
  insert into public.parents (id, name, email)
  values (
    new.id,
    coalesce(new.raw_user_meta_data ->> 'full_name', ''),
    new.email
  )
  on conflict (id) do nothing;
  return new;
end;
$$;

drop trigger if exists on_auth_user_created on auth.users;
create trigger on_auth_user_created
  after insert on auth.users
  for each row execute function public.handle_new_user();

-- ─── update_child_connection ─────────────────────────────────────
-- Called by the kid's phone (anon) and the native service (service_role) to
-- update connection status + heartbeat. SECURITY DEFINER so it can run
-- without a parent session.
--
-- Security note: anyone who knows the child_id (UUID) can update
-- the status. Low risk because UUIDs can't be guessed, and the only
-- impact is toggling the connection status — not access to sensitive data.
create or replace function public.update_child_connection(
  p_child_id  uuid,
  p_status    text,
  p_last_seen timestamptz
)
returns void
language plpgsql
security definer
set search_path = public
as $$
begin
  -- Validate status
  if p_status not in ('online', 'offline_internet', 'offline_manual') then
    raise exception 'Invalid status: %', p_status;
  end if;

  update public.children
  set connection_status = p_status,
      last_seen         = p_last_seen
  where id = p_child_id;
end;
$$;

-- ─── get_pairing_info ────────────────────────────────────────────
-- Called by the kid's phone (anon) to show "Connected to <parent name>".
-- Avoids a direct SELECT on the parents/children tables which are blocked
-- by RLS for anon. Only exposes the name, no other sensitive data.
create or replace function public.get_pairing_info(p_child_id uuid)
returns table (child_name text, parent_name text)
language sql
security definer
set search_path = public
as $$
  select c.child_name, p.name
  from public.children c
  join public.parents p on p.id = c.parent_id
  where c.id = p_child_id;
$$;

-- Allow anon + authenticated to call the RPC
grant execute on function public.update_child_connection(uuid, text, timestamptz) to anon, authenticated;
grant execute on function public.get_pairing_info(uuid) to anon, authenticated;
