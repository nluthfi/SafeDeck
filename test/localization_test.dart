import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:password_management_apps/core/l10n/locale_provider.dart';
import 'package:password_management_apps/core/security/auth_provider.dart';
import 'package:password_management_apps/core/security/security_service.dart';
import 'package:password_management_apps/features/settings/settings_screen.dart';
import 'package:password_management_apps/l10n/generated/app_localizations.dart';

class _InMemorySecurityService extends SecurityService {
  String? _localeCode;

  @override
  Future<bool> hasMasterPin() async => true;

  @override
  Future<bool> isBiometricAvailable() async => false;

  @override
  Future<bool> isBiometricEnabled() async => false;

  @override
  Future<String> getAutoLockDuration() async => 'Segera';

  @override
  Future<int> getClipboardDurationSeconds() async => 30;

  @override
  Future<String?> getAppLocaleCode() async => _localeCode;

  @override
  Future<void> setAppLocaleCode(String? code) async {
    _localeCode = code;
  }
}

void main() {
  group('Locale resolution', () {
    test('resolves English for en_* and falls back to Indonesian otherwise', () {
      const supported = AppLocalizations.supportedLocales;
      expect(resolveAppLocale(const Locale('en', 'US'), supported),
          const Locale('en'));
      expect(resolveAppLocale(const Locale('id', 'ID'), supported),
          const Locale('id'));
      expect(resolveAppLocale(const Locale('ja', 'JP'), supported),
          const Locale('id'));
      expect(resolveAppLocale(null, supported), const Locale('id'));
    });
  });

  group('Settings language switcher', () {
    testWidgets('switching language updates UI from Indonesian to English',
        (tester) async {
      final fakeSecurity = _InMemorySecurityService();

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            securityServiceProvider.overrideWithValue(fakeSecurity),
          ],
          child: Consumer(
            builder: (context, ref, _) {
              final locale = ref.watch(localeProvider);
              return MaterialApp(
                locale: locale ?? const Locale('id'),
                supportedLocales: AppLocalizations.supportedLocales,
                localizationsDelegates: appLocalizationsDelegates,
                localeResolutionCallback: resolveAppLocale,
                home: const SettingsScreen(),
              );
            },
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Initially Indonesian
      expect(find.text('Pengaturan'), findsOneWidget);
      expect(find.text('Bahasa'), findsOneWidget);

      // Open Language picker and select English
      await tester.scrollUntilVisible(find.text('Bahasa'), 200);
      await tester.tap(find.text('Bahasa'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('English'));
      await tester.pumpAndSettle();

      // UI switched to English and persisted
      expect(find.text('Settings'), findsOneWidget);
      expect(find.text('Language'), findsOneWidget);
      expect(await fakeSecurity.getAppLocaleCode(), 'en');
    });
  });
}
