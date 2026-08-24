# NAZAR.AI

AI-powered parental control app to detect online gambling content on kids' phones. Hackathon project, dual-role app (parent + child).

## Tech Stack

- **Flutter 3+** (Dart SDK >=3.0.0) — UI + state via Riverpod, navigation via `go_router`
- **Supabase** — auth, DB (`children`, `detections`), storage (screenshot), realtime stream
- **Firebase Messaging** + `flutter_local_notifications` — notifications to parents
- **Native Android (Kotlin)** — foreground service for screen capture + AI inference. The native part is handled separately; the Flutter side only consumes it via channels.

## Architecture

```
┌─────────────── Flutter (Dart) ───────────────┐
│  UI screens (features/)                       │
│  ChannelService ◄──── EventChannel ─────┐    │
│       │                                   │    │
│       └────► MethodChannel ──────┐        │    │
│                                   │        │    │
└───────────────────────────────────┼────────┼────┘
                                    │        │
┌───────────────── Android (Kotlin) ▼────────┴────┐
│  MainActivity (channel bridge)                   │
│  PerisaiService (foreground, mediaProjection)    │
│    └─► capture screen → AiServerManager → ...   │
│        └─► gambling detected → SupabaseManager  │
│            + send event to Flutter via eventSink│
│  UrlCheckerService (accessibility service)      │
└──────────────────────────────────────────────────┘
```

**Channel names:**
- Event (Android → Flutter): `com.nazar.ai/detection_stream`
- Method (Flutter → Android): `com.nazar.ai/service_control`

**Method calls:** `startService`, `stopService`.
**Event types** (from Android): `gambling_detected`, `service_started`, `service_stopped`.

## Folder Layout (lib/)

- `core/` — theme, constants (`app_strings.dart`), config (`supabase_config.dart`), shared widgets, mock data
- `features/` — one folder per feature (auth, dashboard, detail, pairing, education, settings, test)
- `models/` — DTO + `fromJson` (Detection, Child, UserProfile). **Note:** some model files can be empty at first — that causes undefined type errors; check their contents before importing.
- `services/` — `channel_service.dart` (bridge to native), `supabase_service.dart`
- `router.dart` — all `go_router` routes, navigatorKey shared with `ChannelService` so the service can push routes from the background.
- `main.dart` — init Supabase, call `ChannelService.startListening()`, then run `PerisaiApp`.

## App Flow

**Splash** (`/splash`) reads SharedPreferences:
- session exists + `role == 'parent'` → `/dashboard`
- `role == 'child'` + `child_id` exists → `/scan-qr`
- otherwise → `/role-select`

**Parent:** role-select → login/register → dashboard → (add-child, detail/:id, settings)
**Child:** role-select → scan-qr → active (PopScope, can't go back) → (auto `/education` when there's a gambling_detected event)

## Native Service — Things to Remember

1. **MediaProjection (Android 14+, targetSDK 35):**
   `PerisaiService.onStartCommand` MUST call `startForeground()` *after* getting the MediaProjection token, and use the 3-param version with `ServiceInfo.FOREGROUND_SERVICE_TYPE_MEDIA_PROJECTION` on API 29+. If called before the token exists → `SecurityException` crash.
2. **Permission flow in `MainActivity.requestAllPermissions()`** runs sequentially: POST_NOTIFICATIONS → SYSTEM_ALERT_WINDOW → MediaProjection. The service is only started after all are granted.
3. **`startService` in Flutter** only saves `child_id` to `SharedPreferences` and triggers the permission chain — it doesn't start the service directly. The service starts after the user accepts the MediaProjection dialog.
4. **`child_id` is used cross-layer:** Flutter saves it via Method channel args, native reads it from `nazar_ai_prefs` SharedPreferences (not flutter prefs — different file).

## Supabase

- Config in `lib/core/config/supabase_config.dart` (hardcoded URL + anon key — this is a hackathon, don't be surprised).
- Tables: `children` (parent_id, child_name, age, ...), `detections` (child_id, screenshot_url, confidence, triggered_by, keywords, details).
- Storage bucket for screenshots.
- Realtime subscription is used on the dashboard to auto-refresh when a new detection comes in.

## Test Fixtures

`test/fixtures/mock_data.dart` — collection of dummy `Child` & `Detection` objects for unit/widget tests. Not used at runtime — the backend always goes through Supabase.

## Build & Run

```bash
flutter pub get
flutter run            # default debug
flutter build apk      # release debug APK
```

**Android settings (`android/app/build.gradle.kts`):**
- `ndkVersion = "27.0.12077973"` (plugin requirement, don't downgrade)
- `isCoreLibraryDesugaringEnabled = true` + `desugar_jdk_libs:2.1.4` — required by `flutter_local_notifications`

## Code Conventions

- Comments and UI text in **English** (casual, friendly).
- Use `withValues(alpha: x)` instead of `withOpacity(x)` (latest Flutter).
- Use `ColorScheme.surface` instead of `background` (deprecated).
- `CardThemeData` instead of `CardTheme` (in `ThemeData`).
- Always check `mounted` after `await` before using `BuildContext`.
- `TapGestureRecognizer` needs `import 'package:flutter/gestures.dart'` (not exported by `material.dart`).
- **Logging**: use `AppLogger` (`lib/core/utils/app_logger.dart`), NOT `print`/`debugPrint`. `AppLogger.d`/`i` for tracing (debug-only), `AppLogger.w`/`e` for warnings/errors (run in release, ready for crash reporting).

## Testing

`test/widget_test.dart` is just a placeholder. The app can't be pumped directly in widget tests because it needs Supabase init + native channels — mocking is required for serious testing.

---

## Working Rules (MUST READ)

### Git & Commit Convention

Use **Conventional Commits** (messages in English). Format:

```text
<type>(<scope>): <short message>
```

**Types used:**

- `feat` — new feature
- `fix` — bug fix
- `refactor` — code restructuring without changing behavior
- `style` — formatting, spacing, file rename (no logic)
- `docs` — documentation changes
- `chore` — config, dependency, build
- `perf` — performance improvements

**Scope (optional)**: `dashboard`, `child-detail`, `auth`, `native`, `supabase`, `router`, etc.

**CORRECT examples:**

```text
feat(child-detail): add pause button to the connection status
fix(detection): convert UTC to local time before time formatting
refactor(dashboard): split _ChildAvatar into a reusable widget
docs: update CLAUDE.md with commit rules
chore(android): bump ndkVersion to 27.0.12077973
```

**WRONG examples (don't repeat):**

```text
heheheha
final touch
finishing staage1
update
```

**Additional rules:**

- One commit = one logical change. Don't mix a fix with a new feature.
- Message max 72 characters in the first line.
- If a longer explanation is needed, add a body after a blank line.
- **DON'T** commit `.env` files, credentials, or `build/`.

### Branching Strategy (hackathon-friendly)

- `main` — always working, demo-ready
- `feat/<feature-name>` — create from main, merge back via PR/manual merge
- Before merging to main: at minimum **`flutter analyze`** must be clean + the app must still run

### Pre-Commit Checklist

Before `git commit`, **must** check:

- [ ] `flutter analyze` — no errors, info-level warnings can be ignored
- [ ] Try running the app, changed screens don't crash
- [ ] No leftover `print()` or `debugPrint()` for debugging
- [ ] No hardcoded test data (token, child_id, etc.) in production code
- [ ] TODO comments are done or linked to an issue
- [ ] Irrelevant files are not staged (`git status` first)

### Pre-Demo Checklist (Hackathon)

Before demo day:

- [ ] "DEBUG" / "TEST" buttons/features removed from UI
- [ ] `flutter build apk --release` succeeds
- [ ] Test on a physical phone, not an emulator (MediaProjection behaves differently)
- [ ] Permission flow works smoothly from fresh install
- [ ] Supabase URL & anon key in `supabase_config.dart` point to the demo project, not dev
- [ ] `children` & `detections` tables have sensible dummy data
- [ ] Default avatar doesn't crash (handle null image_url)
- [ ] Test in both WiFi AND cellular data mode — kid's connection is often a problem here

### Adding Features Rules

When adding a new feature:

1. **Check if a similar feature already exists** — don't duplicate widgets. Look at `_SectionCard`, `_StatItem`, `_InfoRow` etc. that already exist.
2. **Reuse `AppColors`, don't create new colors** — if a variant is needed, add it to `AppColors` instead.
3. **Casual English** for all UI text and comments.
4. **State management:** for local screen state use `StatefulWidget`. For state shared across screens, use Riverpod providers in `lib/core/providers/`.
5. **Navigation**: add routes in `router.dart`, don't use `Navigator.push` directly.
6. **Error handling**: wrap async calls with try-catch, show a SnackBar via `ScaffoldMessenger` — don't let errors only appear in the console.
7. **Mounted check**: every async `await` used for `setState` or `context` **MUST** check `if (!mounted) return;` afterwards.

### Native Code (Kotlin) Edit Rules

The native part is owned by another team. Before editing `android/app/src/main/kotlin/`:

1. **Confirm with the native owner first** — can break the fragile MediaProjection flow.
2. **DON'T** change the method channel signature (`startService`, `stopService`) — it's a contract with the Flutter side.
3. **DON'T** change event names (`gambling_detected`, `service_started`, `service_stopped`) — Flutter listens based on those names.
4. After native edits, **MUST** `flutter clean` + `flutter run` again, not hot reload.
5. Test on Android 14+ (API 34+) — foreground service behavior is very different there.

### Database Change Rules (Supabase)

Whenever adding/changing a column in Supabase:

1. **Update the Dart model** (`lib/models/`) in the same commit.
2. **Update `fromJson` and `toJson`** — both.
3. **Test that old queries still work** — `.select()` without specific columns fetches everything, so it's safe. But `.select('a, b, c')` needs updating if one of the columns is removed/changed.
4. **Migration SQL** is stored in `supabase/migrations/` (create the folder if it doesn't exist).
5. **RLS policy** — if it's a new table, **MUST** create a policy. Without a policy = table not accessible via anon key.

### Definition of Done (Per Feature)

A feature is considered done when:

- [ ] UI matches the agreed design/mockup
- [ ] Happy path behavior works end-to-end
- [ ] Basic edge cases are handled (empty data, network error, permission denied)
- [ ] Loading state exists (don't leave UI frozen without an indicator)
- [ ] Empty state exists (don't leave an empty list without a message)
- [ ] `flutter analyze` is clean
- [ ] Tested at least once on a physical phone
- [ ] Doesn't break other features (smoke test 3-4 other screens)
- [ ] Commit message is conventional

### File-Specific Rules

**`router.dart`** — complete route list. Add here before `context.push('/<route>')` in screens.

**`supabase_config.dart`** — the anon key can be hardcoded here (this is a hackathon), BUT the **service_role key** or other secrets must **NEVER** be committed.

**`app_colors.dart`** — single source of truth for colors. Don't inline `Color(0xFF...)` in screens.

**`app_strings.dart`** — strings used in >1 place go here. Strings unique to one screen can be inlined.

### Using Claude Code Skills

See **[docs/CLAUDE_SKILLS.md](docs/CLAUDE_SKILLS.md)** — guide on when & how to use skills, MCP, and sub-agents for PERISAI. In short:

- `/review` before merging a branch
- `/security-review` before the final demo
- `simplify` after finishing a big feature
- `Plan` agent for refactors/large features
- `Explore` agent for cross-file lookups

### When Confused / In Conflict

- Check git history & blame for the file in question first
- Ask in the team group chat before overwriting someone else's code
- If unsure between two approaches, **the simpler one wins**. Hackathon = limited time.