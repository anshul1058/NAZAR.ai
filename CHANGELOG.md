# Changelog

All notable changes to this project will be documented here.

The format follows [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [1.1.0] - 2026-07-01 — Production Hardening (Sprint 1)

### Added

- "Pause Temporarily" button on the child detail page (parents can pause monitoring)
- UTC → WIB conversion in detection time formatting
- Commit & branching conventions (CONTRIBUTING.md)
- Professional repo setup: PR/issue templates, CI workflow, CODEOWNERS, SECURITY.md
- `dev` branch for the integration workflow
- Supabase config via `.env` (flutter_dotenv) — credentials no longer hardcoded
- Migration SQL in `supabase/migrations/` — versioned schema (parents, children, detections)
- Full RLS policies + `children.paused_until` column for the pause feature
- `get_pairing_info` RPC so the child's phone (anon) doesn't need to SELECT tables directly

### Changed

- Security Score is now calculated from **all** detections (previously only the last 7 days, for demo visibility)
- "Connected Children (X)" now shows the total number of children, not just the online ones
- README.md replaced from the default Flutter template with a professional version
- `active_screen.dart` fetches parent name via the `get_pairing_info` RPC (instead of a direct SELECT)
- Replaced 27 scattered `debugPrint` calls with `AppLogger` (leveled, debug-only for
  trace, ready for crash reporting) — `lib/core/utils/app_logger.dart`
- "Hackathon CORE3D 2026 — Unand" text in Settings replaced with the product tagline

### Removed

- "AJARKAN" button on the detection detail page
- "Disconnect Connection" button on the child page (children can no longer disconnect on their own)

### Fixed

- `_todayCount` bug on the dashboard that didn't convert UTC to local time
- Detection time bug that showed UTC but was labeled "WIB"
- **The "Pause Temporarily" feature is now actually enforced** — previously the
  child's phone heartbeat (every 30 seconds) overrode the status back to online. Now
  the `update_child_connection` RPC respects `paused_until` (server-side enforcement,
  applies to both the native heartbeat and Flutter)

### Security

- **service_role key & Supabase URL no longer hardcoded** in native Kotlin —
  moved to `BuildConfig` via `local.properties`/env var (see docs/NATIVE_CONFIG.md)

## [1.0.0] - 2026-05-XX — Hackathon Submission

### Added

- Initial MVP for the CORE3D 2026 Hackathon, Universitas Andalas
- 🏆 **2nd Place**
- Real-time gambling detection via MediaProjection + on-device AI
- QR code pairing for parent ↔ child
- Dashboard, detection history, education screen
- Push notifications via Firebase Messaging

---

[Unreleased]: https://github.com/anshul1058/periai_app/compare/v1.1.0...HEAD
[1.1.0]: https://github.com/anshul1058/periai_app/compare/v1.0.0...v1.1.0
[1.0.0]: https://github.com/anshul1058/periai_app/releases/tag/v1.0.0