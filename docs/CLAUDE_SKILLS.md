# Claude Code Skills (Superpower) — PERISAI Guide

This document explains **when and how** to use Claude Code's "superpower" features (Skills, MCP, and agents) while coding PERISAI. Written specifically for this project's context.

> TL;DR: Skills = slash commands prepared for specific tasks. Use one if it fits — faster than a manual prompt.

---

## 1. Built-in Skills (always available)

### `/init`

Initializes `CLAUDE.md` for a new project. **DON'T use it in PERISAI** — our `CLAUDE.md` is already custom and more complete than the default template.

### `/review <PR-number-or-branch>`

Code review of a PR before merging to main. Good to use before merging a `feat/*` branch into `main`.

**Example:**

```text
/review feat/child-pause-button
```

Output: bug notes, improvement suggestions, and clarifying questions.

### `/security-review`

Security audit of the current branch's changes. **Mandatory** before the final demo, especially for:

- Auth flow (login/register/session handling)
- Credential storage (SharedPreferences, Supabase keys)
- Android permissions (MediaProjection, Overlay, Notifications)
- Files that could expose the service_role key

### `/loop <prompt-or-command>`

Run a task repeatedly. **Use cases in PERISAI**:

```text
/loop check whether the PERISAI app is still running on the emulator, restart it if it crashes
```

Or to poll Supabase status:

```text
/loop 5m check if there's a new detection in the detections table
```

Don't use it for one-off tasks.

### `/schedule`

Create a cron remote agent. **Not needed for PERISAI yet** — it's a local project, not a SaaS. Skip.

---

## 2. Day-to-Day Development Skills

### `simplify`

After finishing a feature implementation, review the code for:

- Reuse opportunities (are you using existing widgets?)
- Code quality (naming, structure)
- Efficiency (unnecessary re-renders)

**When to use**: after finishing a big feature (e.g. child detail screen, edit profile), before committing.

### `fewer-permission-prompts`

Scan the transcript for frequently repeated commands → add them to the `settings.json` allowlist so Claude stops asking for permission repeatedly.

**Run it once** at the start of the project, save time forever after.

### `update-config`

Edit Claude Code's `settings.json` (permissions, hooks, env vars). Use it if you want to:

- Auto-format with `dart format` after edits
- Allowlist `flutter pub get`, `flutter analyze`
- Set a hook so Claude runs `flutter analyze` before stopping

**Example prompt:**

```text
/update-config add permission for flutter pub get and flutter analyze
```

---

## 3. MCP Servers (External Integration)

### Figma (`mcp__claude_ai_Figma__*`)

Sync designs from Figma to Flutter code. **Use cases in PERISAI**:

- If there's a Figma mockup → "implement this screen" while sharing the Figma URL
- Generate color/component variants per the design system

**Important**: call the `/figma-use` skill before `use_figma` (mandatory per Figma docs).

### Canva (`mcp__claude_ai_Canva__*`)

For marketing/pitch deck demo assets. **Not for the app**. Use it when making hackathon presentation slides.

### Gmail, Drive, Microsoft 365

Not relevant to PERISAI. Skip.

---

## 4. Sub-Agents (Agent Tool)

### `Explore`

Read-only search agent — fast for looking up "where is X defined" or "who references Y".

**When to use**: when Claude alone would need >3 rounds of grep/glob. For example:

> "Find all the places that use `Supabase.instance.client`, then update them to use the service wrapper."

**Don't use it**: for cross-file consistency checks (it reads excerpts, could miss things).

### `Plan`

Architect agent that designs a step-by-step implementation plan. Good for:

- Large refactors (e.g. separating business logic from UI)
- Adding features that touch multiple screens + state
- Migrating from mock to real Supabase

**Output**: list of steps + files to touch + trade-offs.

### `claude-code-guide`

Ask about Claude Code / Anthropic SDK / API. **Not for PERISAI code** — use it if you're confused about Claude Code features themselves.

### `general-purpose`

Catch-all multi-step research agent. Fallback when there's no more specific agent.

---

## 5. Recommended Workflows

### When starting a new feature

1. (Optional) `Plan` agent to break down the steps
2. Implement inline with Claude (Edit/Write/Bash)
3. `simplify` skill for review
4. `flutter analyze` (make it a hook so it's automatic)
5. Commit with conventional format

### Before merging a branch to main

1. `/review` for a sanity check
2. Manual test on a physical phone
3. Squash commits if needed, then merge

### Before the final hackathon demo

1. `/security-review` — mandatory
2. `/code-review ultra` (if you want the full paid multi-agent review)
3. Run the Pre-Demo Checklist in `CLAUDE.md`

---

## 6. What NOT to Do

- **Don't spawn agents for simple tasks**. If 1-2 tool calls are enough, just do it.
- **Don't invoke skills that aren't in the available list**. Check the system reminder first, don't guess.
- **Don't use `/loop` to poll Supabase every second** — wastes tokens, expensive on the Claude API. Minimum interval: 5 minutes.
- **Don't use a sub-agent when you just need to read 1 file**. Use the Read tool directly.

---

## 7. Special Modes

### Auto Mode

When active, Claude doesn't ask many clarifying questions — makes reasonable decisions and keeps going. Good when you know exactly what you want and don't want to be interrupted.

### Plan Mode

Claude makes a plan first, must be approved before execution. Good for large/risky tasks (e.g. changing the DB schema, multi-file refactors).

---

## 8. References

- User-level skills live in `~/.claude/skills/`
- Project-level skills (if any custom ones) in `.claude/skills/` at the project root
- Hooks & permissions in `.claude/settings.json` (project) and `~/.claude/settings.json` (global)

Note: on Windows the location is `C:\Users\<user>\.claude\`.