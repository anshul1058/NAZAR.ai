import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Supabase config is read from `.env`.
///
/// `.env` is gitignored — copy `.env.example` to `.env` and fill in
/// the real values from Supabase Dashboard → Settings → API.
///
/// In CI, `.env` is generated from GitHub Secrets before build.
class SupabaseConfig {
  static String get url {
    final value = dotenv.maybeGet('SUPABASE_URL') ?? '';
    if (value.isEmpty) {
      throw StateError(
        'SUPABASE_URL is not set in .env. '
        'Copy .env.example → .env and fill in its value.',
      );
    }
    return value;
  }

  static String get anonKey {
    final value = dotenv.maybeGet('SUPABASE_ANON_KEY') ?? '';
    if (value.isEmpty) {
      throw StateError(
        'SUPABASE_ANON_KEY is not set in .env. '
        'Copy .env.example → .env and fill in its value.',
      );
    }
    return value;
  }
}
