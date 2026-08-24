-- ============================================================
-- PERISAI — SQL Migration for Connection Status
-- Run in the Supabase SQL Editor
-- ============================================================

-- 1. Change connection_status default to 'offline_manual'
ALTER TABLE children ALTER COLUMN connection_status SET DEFAULT 'offline_manual';

-- 2. Reset ALL children still 'online' even though never connected
UPDATE children SET connection_status = 'offline_manual' WHERE connection_status = 'online';

-- 3. Create an RPC function so the kid's phone can update status WITHOUT an auth session
CREATE OR REPLACE FUNCTION update_child_connection(
  p_child_id UUID,
  p_status TEXT,
  p_last_seen TIMESTAMPTZ DEFAULT NOW()
)
RETURNS VOID
LANGUAGE plpgsql
SECURITY DEFINER  -- bypass RLS
AS $$
BEGIN
  UPDATE children
  SET connection_status = p_status,
      last_seen = p_last_seen
  WHERE id = p_child_id;
END;
$$;

-- 4. Add an RLS policy so everyone can call the RPC
-- (SECURITY DEFINER already handles this, but just in case)
GRANT EXECUTE ON FUNCTION update_child_connection TO anon, authenticated;
