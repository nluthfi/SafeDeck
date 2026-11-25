// ignore: depend_on_referenced_packages
import 'package:cupertino_ui/cupertino_ui.dart'
    show CupertinoLocalizations, DefaultCupertinoLocalizations;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';
import '../../l10n/generated/app_localizations.dart';
import '../../l10n/generated/app_localizations_id.dart';
import '../security/auth_provider.dart';
import '../widgets/strength_indicator.dart';

/// Bridges `material_ui` / `cupertino_ui` localizations for all supported
/// locales (`flutter_localizations` only registers `flutter/material.dart`).
class _MaterialUiLocalizationsDelegate
    extends LocalizationsDelegate<MaterialLocalizations> {
  const _MaterialUiLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) =>
      locale.languageCode == 'id' || locale.languageCode == 'en';

  @override
  Future<MaterialLocalizations> load(Locale locale) =>
      DefaultMaterialLocalizations.load(locale);

  @override
  bool shouldReload(_MaterialUiLocalizationsDelegate old) => false;
}

class _CupertinoUiLocalizationsDelegate
    extends LocalizationsDelegate<CupertinoLocalizations> {
  const _CupertinoUiLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) =>
      locale.languageCode == 'id' || locale.languageCode == 'en';

  @override
  Future<CupertinoLocalizations> load(Locale locale) =>
      DefaultCupertinoLocalizations.load(locale);

  @override
  bool shouldReload(_CupertinoUiLocalizationsDelegate old) => false;
}

const List<LocalizationsDelegate<dynamic>> appLocalizationsDelegates = [
  _MaterialUiLocalizationsDelegate(),
  _CupertinoUiLocalizationsDelegate(),
  ...AppLocalizations.localizationsDelegates,
];

/// Holds the user-selected [Locale], or `null` to follow the device locale.
final localeProvider =
    NotifierProvider<LocaleNotifier, Locale?>(LocaleNotifier.new);

class LocaleNotifier extends Notifier<Locale?> {
  @override
  Locale? build() {
    Future.microtask(_loadSavedLocale);
    return null;
  }

  Future<void> _loadSavedLocale() async {
    try {
      final code = await ref.read(securityServiceProvider).getAppLocaleCode();
      if (code != null && state?.languageCode != code) {
        state = Locale(code);
      }
    } catch (_) {
      // Ignore storage errors (e.g. in unit tests without secure storage plugin)
    }
  }

  Future<void> setLocale(Locale? locale) async {
    state = locale;
    try {
      await ref
          .read(securityServiceProvider)
          .setAppLocaleCode(locale?.languageCode);
    } catch (_) {}
  }
}

/// Resolves device locale: English -> `en`, everything else falls back to `id`.
Locale resolveAppLocale(Locale? deviceLocale, Iterable<Locale> supported) {
  if (deviceLocale != null && deviceLocale.languageCode == 'en') {
    return const Locale('en');
  }
  return const Locale('id');
}

extension L10nContext on BuildContext {
  /// Returns active [AppLocalizations], falling back to Indonesian in isolated widget tests.
  AppLocalizations get l10n => AppLocalizations.of(this) ?? AppLocalizationsId();
}

String localizeCategory(AppLocalizations l10n, String category) {
  switch (category) {
    case 'Semua':
      return l10n.categoryAll;
    case 'Game':
      return l10n.categoryGame;
    case 'Sosial':
      return l10n.categorySocial;
    case 'Sosial Media':
      return l10n.categorySocialMedia;
    case 'Kerja':
      return l10n.categoryWork;
    case 'Kerja & Bisnis':
      return l10n.categoryWorkBusiness;
    case 'Keuangan':
      return l10n.categoryFinance;
    case 'Hiburan':
      return l10n.categoryEntertainment;
    default:
      return category;
  }
}

String localizeAutoLock(AppLocalizations l10n, String duration) {
  switch (duration) {
    case 'Segera':
      return l10n.autoLockImmediate;
    case '1 Menit':
      return l10n.autoLock1Min;
    case '5 Menit':
      return l10n.autoLock5Min;
    case '15 Menit':
      return l10n.autoLock15Min;
    default:
      return duration;
  }
}

String localizeStrengthLabel(
  AppLocalizations l10n,
  PasswordStrength strength, {
  bool isEmpty = false,
}) {
  if (isEmpty) return l10n.strengthEmpty;
  switch (strength) {
    case PasswordStrength.weak:
      return l10n.strengthWeak;
    case PasswordStrength.fair:
      return l10n.strengthFair;
    case PasswordStrength.strong:
      return l10n.strengthStrong;
    case PasswordStrength.veryStrong:
      return l10n.strengthVeryStrong;
  }
}

String localizeStrengthDetail(
  AppLocalizations l10n,
  PasswordStrengthResult result,
  int passwordLength,
) {
  if (result.score == 0) return l10n.strengthEmptyDetail;
  switch (result.strength) {
    case PasswordStrength.weak:
      return l10n.strengthWeakDetail;
    case PasswordStrength.fair:
      return l10n.strengthFairDetail;
    case PasswordStrength.strong:
      return l10n.strengthStrongDetail(passwordLength);
    case PasswordStrength.veryStrong:
      return l10n.strengthVeryStrongDetail(passwordLength);
  }
}
