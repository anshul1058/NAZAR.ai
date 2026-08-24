import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'core/config/supabase_config.dart';
import 'core/providers/language_provider.dart';
import 'core/theme/app_theme.dart';
import 'l10n/app_localizations.dart';
import 'router.dart';
import 'services/channel_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load .env before anything that needs env (Supabase, etc.)
  await dotenv.load(fileName: '.env');

  // Initialize Supabase
  await Supabase.initialize(
    url: SupabaseConfig.url,
    anonKey: SupabaseConfig.anonKey,
  );

  ChannelService.startListening();

  runApp(
    // Riverpod wrapper
    const ProviderScope(
      child: NazarAiApp(),
    ),
  );
}

class NazarAiApp extends ConsumerWidget {
  const NazarAiApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentLocale = ref.watch(languageProvider);

    return MaterialApp.router(
      title: 'Nazar.Ai',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      routerConfig: appRouter,
      locale: currentLocale,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: supportedLocales,
    );
  }
}
