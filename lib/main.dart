import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:material_ui/material_ui.dart';
import 'core/l10n/locale_provider.dart';
import 'core/router/app_router.dart';
import 'core/security/auth_provider.dart';
import 'core/theme/app_theme.dart';
import 'data/repositories/vault_repository.dart';
import 'l10n/generated/app_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await initializeDateFormatting('id_ID', null);
    await initializeDateFormatting('id', null);
    await initializeDateFormatting('en', null);
  } catch (e) {
    debugPrint('Error initializing date formatting: $e');
  }
  runApp(
    const ProviderScope(
      child: BrankasApp(),
    ),
  );
}

class BrankasApp extends ConsumerStatefulWidget {
  const BrankasApp({super.key});

  @override
  ConsumerState<BrankasApp> createState() => _BrankasAppState();
}

class _BrankasAppState extends ConsumerState<BrankasApp>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    // Seed debug data in debug mode if database is empty
    if (kDebugMode) {
      Future.microtask(() async {
        final repo = ref.read(vaultRepositoryProvider);
        await repo.seedDebugData();
      });
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    final notifier = ref.read(authNotifierProvider.notifier);
    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.inactive) {
      notifier.onAppPaused();
    } else if (state == AppLifecycleState.resumed) {
      notifier.onAppResumed();
    }
  }

  @override
  Widget build(BuildContext context) {
    final router = ref.watch(appRouterProvider);
    final locale = ref.watch(localeProvider);

    return MaterialApp.router(
      title: 'SafeDeck',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      locale: locale,
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: appLocalizationsDelegates,
      localeResolutionCallback: resolveAppLocale,
      routerConfig: router,
    );
  }
}
