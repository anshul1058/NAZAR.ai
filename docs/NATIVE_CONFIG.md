# Native (Android) Config & Secrets

The native Kotlin side needs a few secret values that **MUST NOT be hardcoded**
in the source code (this repo is public). These values are injected at build time
via `BuildConfig`, read from `android/local.properties` (local) or env vars (CI).

## Required Keys

| Key | Purpose | Secret? |
|-----|---------|---------|
| `SUPABASE_URL` | Supabase REST/Storage endpoint | No (but still externalize it) |
| `SUPABASE_SERVICE_ROLE_KEY` | Insert detections + upload screenshots (bypasses RLS) | **YES — highly secret** |
| `AI_SERVER_URL` | AI inference server endpoint | No |

> ⚠️ **`SUPABASE_SERVICE_ROLE_KEY` bypasses ALL of RLS.** Never commit it,
> never share it, never put it somewhere anon-accessible. If it leaks, immediately
> rotate it in Supabase Dashboard → Settings → API → Rotate service_role key.

## Local Setup (development)

Edit `android/local.properties` (this file is gitignored), add:

```properties
SUPABASE_URL=https://your-project.supabase.co
SUPABASE_SERVICE_ROLE_KEY=eyJ...your-service-role-key...
AI_SERVER_URL=https://your-ai-server.com/predict
```

Then build as usual:

```bash
flutter run
```

If a key is empty, the app still **compiles & runs**, but the native features
(insert detections, upload screenshots) won't work against the backend.

## CI Setup (GitHub Actions)

Add in [repo Settings → Secrets → Actions](https://github.com/anshul1058/NAZAR/settings/secrets/actions):

- `SUPABASE_URL`
- `SUPABASE_SERVICE_ROLE_KEY`
- `AI_SERVER_URL`

The `ci.yml` workflow already injects these env vars into the `flutter build apk` step.

## How It Works (technical)

1. `android/app/build.gradle.kts` reads `local.properties` → falls back to `System.getenv()`
2. Values are exposed via `buildConfigField(...)` → generates the `BuildConfig` class
3. Kotlin accesses them via `BuildConfig.SUPABASE_URL`, etc.

Code references:

- [android/app/build.gradle.kts](../android/app/build.gradle.kts) — secret reading
- [SupabaseManager.kt](../android/app/src/main/kotlin/com/nazar/ai/SupabaseManager.kt)
- [AiServerManager.kt](../android/app/src/main/kotlin/com/nazar/ai/AiServerManager.kt)