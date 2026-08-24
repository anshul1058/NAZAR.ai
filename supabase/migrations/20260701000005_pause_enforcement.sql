-- ╔══════════════════════════════════════════════════════════════╗
-- ║ PERISAI — Pause Enforcement                                    ║
-- ║ Make update_child_connection respect children.paused_until     ║
-- ╚══════════════════════════════════════════════════════════════╝
--
-- Problem: when the parent uses "Pause Temporarily", status is set to offline_manual.
-- But the kid's phone sends an 'online' heartbeat every 30 seconds → overrides it back.
--
-- Solution: if paused_until is still in the future, the RPC REFUSES to change
-- the status to online — only last_seen is updated (heartbeat is still recorded).
-- Enforcement is server-side, so it applies to both native and Flutter heartbeats.

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
declare
  v_paused_until timestamptz;
begin
  -- Validate status
  if p_status not in ('online', 'offline_internet', 'offline_manual') then
    raise exception 'Invalid status: %', p_status;
  end if;

  select paused_until into v_paused_until
  from public.children
  where id = p_child_id;

  -- If paused and a heartbeat tries to set online → don't override.
  -- Just record last_seen so the parent still knows the kid's phone is alive.
  if p_status = 'online'
     and v_paused_until is not null
     and v_paused_until > now() then
    update public.children
    set last_seen = p_last_seen
    where id = p_child_id;
    return;
  end if;

  update public.children
  set connection_status = p_status,
      last_seen         = p_last_seen
  where id = p_child_id;
end;
$$;
