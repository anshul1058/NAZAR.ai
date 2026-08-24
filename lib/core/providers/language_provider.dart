import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

const String _kLangPrefKey = 'selected_language_code';

class LanguageNotifier extends StateNotifier<Locale> {
  LanguageNotifier() : super(const Locale('en')) {
    _loadSaved();
  }

  Future<void> _loadSaved() async {
    final prefs = await SharedPreferences.getInstance();
    final code = prefs.getString(_kLangPrefKey);
    if (code != null) {
      state = Locale(code);
    }
  }

  Future<void> setLanguage(Locale locale) async {
    state = locale;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_kLangPrefKey, locale.languageCode);
  }
}

final languageProvider =
    StateNotifierProvider<LanguageNotifier, Locale>((ref) {
  return LanguageNotifier();
});

/// All supported locales for the app.
const List<Locale> supportedLocales = [
  Locale('en'),  // English
  Locale('as'),  // Assamese
  Locale('bn'),  // Bengali
  Locale('brx'), // Bodo
  Locale('doi'), // Dogri
  Locale('gu'),  // Gujarati
  Locale('hi'),  // Hindi
  Locale('kn'),  // Kannada
  Locale('ks'),  // Kashmiri
  Locale('gom'), // Konkani
  Locale('mai'), // Maithili
  Locale('ml'),  // Malayalam
  Locale('mni'), // Manipuri
  Locale('mr'),  // Marathi
  Locale('ne'),  // Nepali
  Locale('or'),  // Odia
  Locale('pa'),  // Punjabi
  Locale('sa'),  // Sanskrit
  Locale('sat'), // Santali
  Locale('sd'),  // Sindhi
  Locale('ta'),  // Tamil
  Locale('te'),  // Telugu
  Locale('ur'),  // Urdu
];

/// Display names for each language (native name + English).
const Map<String, String> languageDisplayNames = {
  'en': 'English',
  'as': 'অসমীয়া (Assamese)',
  'bn': 'বাংলা (Bengali)',
  'brx': 'बड़ो (Bodo)',
  'doi': 'डोगरी (Dogri)',
  'gu': 'ગુજરાતી (Gujarati)',
  'hi': 'हिन्दी (Hindi)',
  'kn': 'ಕನ್ನಡ (Kannada)',
  'ks': 'कॉशुर (Kashmiri)',
  'gom': 'कोंकणी (Konkani)',
  'mai': 'मैथिली (Maithili)',
  'ml': 'മലയാളം (Malayalam)',
  'mni': 'মৈতৈলোন্ (Manipuri)',
  'mr': 'मराठी (Marathi)',
  'ne': 'नेपाली (Nepali)',
  'or': 'ଓଡ଼ିଆ (Odia)',
  'pa': 'ਪੰਜਾਬੀ (Punjabi)',
  'sa': 'संस्कृतम् (Sanskrit)',
  'sat': 'संताली (Santali)',
  'sd': 'सिंधी (Sindhi)',
  'ta': 'தமிழ் (Tamil)',
  'te': 'తెలుగు (Telugu)',
  'ur': 'اردو (Urdu)',
};
