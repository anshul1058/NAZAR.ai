import 'package:flutter/material.dart';

/// Warm editorial / "home journal" palette for Nazar.Ai.
///
/// Warm parchment tones, dark espresso accents, soft gold highlights.
/// No cool grays, no pure white, no blue-based UI colors.
class AppColors {
  // ─── Accent / brand ───────────────────────────────────
  static const Color primary = Color(0xFFC89B3C); // gold/amber — active nav, highlights, badges
  static const Color primaryLight = Color(0xFFDDB862); // lighter gold (chart fills, tints)
  static const Color primaryDark = Color(0xFFA67F2E); // deeper gold

  // ─── Filled buttons ──────────────────────────────────
  static const Color buttonPrimary = Color(0xFF2B1D14); // dark brown + cream text
  static const Color buttonPrimaryText = Color(0xFFF5EFE1); // cream text on dark brown

  // ─── Backgrounds & surfaces ──────────────────────────
  static const Color background = Color(0xFFF5EFE1); // warm cream / ivory
  static const Color surface = Color(0xFFFFFCF5); // warm off-white
  static const Color espresso = Color(0xFF1B140F); // near-black espresso (nav/headers)
  static const Color navInactive = Color(0xFF9A8F7E); // muted tan for inactive nav on espresso
  static const Color toggleOff = Color(0xFFE4D9C4); // light tan / beige (switch off track)

  // ─── Text ────────────────────────────────────────────
  static const Color textPrimary = Color(0xFF241A12); // dark espresso brown
  static const Color textSecondary = Color(0xFF8A7F70); // warm muted gray-brown
  static const Color textMuted = Color(0xFF6B5D4E); // dusty tan (uppercase labels)

  // ─── Status ──────────────────────────────────────────
  static const Color danger = Color(0xFFB0503F); // red-terracotta — high risk
  static const Color success = Color(0xFF6B7A4F); // sage/olive green — low risk / online
  static const Color warning = Color(0xFFC89B3C); // amber/gold — medium tone

  // ─── Triggered-by badges ─────────────────────────────
  static const Color ocr = Color(0xFF8A7F70); // warm gray-brown
  static const Color mobilenet = Color(0xFF6B7A4F); // sage
  static const Color trustpositif = Color(0xFFB0503F); // terracotta
  static const Color combined = Color(0xFFC89B3C); // gold

  // ─── Borders / dividers ──────────────────────────────
  static const Color border = Color(0xFFEFE6D6); // warm tan hairline
  static const Color outline = Color(0xFFE4D9C4); // thin warm border for outline buttons
}