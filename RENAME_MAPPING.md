# RENAME_MAPPING.md

This document maps the current file/folder structure to the proposed standardized naming convention for NAZAR.AI.

## Legend
- ✅ Already follows convention
- 🔄 Proposed rename
- ⚠️ Requires cross-file reference updates

---

## Flutter (Dart) — lib/

### Core
| Current Path | Proposed Path | Status | Notes |
|--------------|---------------|--------|-------|
| `lib/core/config/supabase_config.dart` | `lib/core/config/supabase_config.dart` | ✅ | OK |
| `lib/core/constants/app_strings.dart` | `lib/core/constants/app_strings.dart` | ✅ | OK |
| `lib/core/providers/language_provider.dart` | `lib/core/providers/language_provider.dart` | ✅ | OK |
| `lib/core/theme/app_theme.dart` | `lib/core/theme/app_theme.dart` | ✅ | OK |
| `lib/core/theme/app_colors.dart` | `lib/core/theme/app_colors.dart` | ✅ | OK |
| `lib/core/utils/app_logger.dart` | `lib/core/utils/app_logger.dart` | ✅ | OK |
| `lib/core/widgets/detection_card.dart` | `lib/core/widgets/detection_card.dart` | ✅ | OK |

### Models
| Current Path | Proposed Path | Status | Notes |
|--------------|---------------|--------|-------|
| `lib/models/child.dart` | `lib/models/child.dart` | ✅ | OK |
| `lib/models/detection.dart` | `lib/models/detection.dart` | ✅ | OK |
| `lib/models/user_profile.dart` | `lib/models/user_profile.dart` | ✅ | OK |

### Services
| Current Path | Proposed Path | Status | Notes |
|--------------|---------------|--------|-------|
| `lib/services/channel_service.dart` | `lib/services/channel_service.dart` | ✅ | OK |
| `lib/services/supabase_service.dart` | `lib/services/supabase_service.dart` | ✅ | OK |

### Features — Auth
| Current Path | Proposed Path | Status | Notes |
|--------------|---------------|--------|-------|
| `lib/features/auth/splash_screen.dart` | `lib/features/auth/splash_screen.dart` | ✅ | OK |
| `lib/features/auth/role_select_screen.dart` | `lib/features/auth/role_select_screen.dart` | ✅ | OK |
| `lib/features/auth/login_screen.dart` | `lib/features/auth/login_screen.dart` | ✅ | OK |
| `lib/features/auth/register_screen.dart` | `lib/features/auth/register_screen.dart` | ✅ | OK |
| `lib/features/auth/loading_screen.dart` | `lib/features/auth/loading_screen.dart` | ✅ | OK |

### Features — Dashboard (Parent)
| Current Path | Proposed Path | Status | Notes |
|--------------|---------------|--------|-------|
| `lib/features/dashboard/dashboard_screen.dart` | `lib/features/dashboard/dashboard_screen.dart` | ✅ | OK |
| `lib/features/dashboard/main_screen.dart` | `lib/features/dashboard/main_screen.dart` | ✅ | OK |
| `lib/features/dashboard/child_detail_screen.dart` | `lib/features/dashboard/child_detail_screen.dart` | ✅ | OK |
| `lib/features/dashboard/family_screen.dart` | `lib/features/dashboard/family_screen.dart` | ✅ | OK |
| `lib/features/dashboard/activity_screen.dart` | `lib/features/dashboard/activity_screen.dart` | ✅ | OK |
| `lib/features/dashboard/shield_screen.dart` | `lib/features/dashboard/shield_screen.dart` | ✅ | OK |

### Features — Detail
| Current Path | Proposed Path | Status | Notes |
|--------------|---------------|--------|-------|
| `lib/features/detail/detection_detail_screen.dart` | `lib/features/detail/detection_detail_screen.dart` | ✅ | OK |

### Features — Pairing
| Current Path | Proposed Path | Status | Notes |
|--------------|---------------|--------|-------|
| `lib/features/pairing/onboarding_screen.dart` | `lib/features/pairing/onboarding_screen.dart` | ✅ | OK |
| `lib/features/pairing/scan_qr_screen.dart` | `lib/features/pairing/scan_qr_screen.dart` | ✅ | OK |
| `lib/features/pairing/add_child_screen.dart` | `lib/features/pairing/add_child_screen.dart` | ✅ | OK |
| `lib/features/pairing/active_screen.dart` | `lib/features/pairing/active_screen.dart` | ✅ | OK |

### Features — Education
| Current Path | Proposed Path | Status | Notes |
|--------------|---------------|--------|-------|
| `lib/features/education/education_screen.dart` | `lib/features/education/education_screen.dart` | ✅ | OK |

### Features — Settings
| Current Path | Proposed Path | Status | Notes |
|--------------|---------------|--------|-------|
| `lib/features/settings/settings_screen.dart` | `lib/features/settings/settings_screen.dart` | ✅ | OK |
| `lib/features/settings/edit_profile_screen.dart` | `lib/features/settings/edit_profile_screen.dart` | ✅ | OK |

### Routing & Entry
| Current Path | Proposed Path | Status | Notes |
|--------------|---------------|--------|-------|
| `lib/router.dart` | `lib/router.dart` | ✅ | OK |
| `lib/main.dart` | `lib/main.dart` | ✅ | OK |

---

## Native Android (Kotlin) — android/app/src/main/kotlin/com/nazar/ai/

| Current Path | Proposed Path | Status | Notes |
|--------------|---------------|--------|-------|
| `MainActivity.kt` | `MainActivity.kt` | ✅ | OK |
| `PerisaiService.kt` | `PerisaiService.kt` | ✅ | OK |
| `UrlCheckerService.kt` | `UrlCheckerService.kt` | ✅ | OK |
| `SupabaseManager.kt` | `SupabaseManager.kt` | ✅ | OK |
| `AiServerManager.kt` | `AiServerManager.kt` | ✅ | OK |
| `BootReceiver.kt` | `BootReceiver.kt` | ✅ | OK |

---

## Configuration Files
| Current Path | Proposed Path | Status | Notes |
|--------------|---------------|--------|-------|
| `pubspec.yaml` | `pubspec.yaml` | ✅ | OK |
| `analysis_options.yaml` | `analysis_options.yaml` | ✅ | OK |
| `android/app/build.gradle.kts` | `android/app/build.gradle.kts` | ✅ | OK |
| `android/build.gradle.kts` | `android/build.gradle.kts` | ✅ | OK |
| `android/settings.gradle.kts` | `android/settings.gradle.kts` | ✅ | OK |

---

## Summary
**No renames are required** — the current project structure already follows consistent naming conventions:
- Feature-based folder organization under `lib/features/`
- Clear separation: `core/`, `models/`, `services/`
- Descriptive snake_case filenames
- Consistent channel names in native & Flutter layers

If the app name changes in UI, only string constants (`app_strings.dart`, l10n files) need updates — no file renames.