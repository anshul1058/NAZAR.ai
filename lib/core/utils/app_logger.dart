import 'dart:developer' as developer;
import 'package:flutter/foundation.dart';

/// Lightweight logger for Nazar.Ai.
///
/// Replaces scattered `debugPrint` calls. Benefits:
/// - Log levels (debug/info/warning/error) → easy to filter in DevTools
/// - `d`/`i` only run in debug builds (won't leak to production logcat)
/// - `w`/`e` also run in release so they can be hooked up to crash reporting
///   (Sentry/Crashlytics) later
///
/// Usage:
/// ```dart
/// AppLogger.d('Connection status updated');
/// AppLogger.e('Failed to upload avatar', error, stackTrace);
/// ```
class AppLogger {
  AppLogger._();

  static const _name = 'NAZAR.AI';

  /// Debug — technical detail, only in debug builds.
  static void d(String message) {
    if (kDebugMode) {
      developer.log(message, name: _name, level: 500);
    }
  }

  /// Info — interesting normal events, only in debug builds.
  static void i(String message) {
    if (kDebugMode) {
      developer.log(message, name: _name, level: 800);
    }
  }

  /// Warning — something is off but not fatal. Runs in all builds.
  static void w(String message, [Object? error, StackTrace? stackTrace]) {
    developer.log(
      message,
      name: _name,
      level: 900,
      error: error,
      stackTrace: stackTrace,
    );
  }

  /// Error — failures. Runs in all builds (ready to be hooked into crash reporting).
  static void e(String message, [Object? error, StackTrace? stackTrace]) {
    developer.log(
      message,
      name: _name,
      level: 1000,
      error: error,
      stackTrace: stackTrace,
    );
  }
}
