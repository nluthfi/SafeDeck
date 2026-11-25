import 'package:file_picker/file_picker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:material_ui/material_ui.dart';
import 'package:share_plus/share_plus.dart';
import '../../core/l10n/locale_provider.dart';
import '../../core/security/auth_provider.dart';
import '../../core/security/backup_service.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_shadows.dart';
import '../../core/theme/app_typography.dart';
import '../../core/widgets/app_button.dart';
import '../../core/widgets/app_switch.dart';
import '../../core/widgets/app_text_field.dart';
import '../../core/widgets/app_toast.dart';
import '../../core/widgets/settings_row.dart';
import '../../data/repositories/vault_repository.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  final _backupService = BackupService();

  void _showLanguageDialog() {
    final notifier = ref.read(localeProvider.notifier);
    final current = ref.read(localeProvider);
    final l10n = context.l10n;
    final options = <(Locale?, String)>[
      (null, l10n.languageSystem),
      (const Locale('id'), l10n.languageIndonesian),
      (const Locale('en'), l10n.languageEnglish),
    ];

    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.card,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (sheetCtx) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(l10n.settingsLanguageTitle, style: AppTypography.h3),
                const SizedBox(height: 12),
                ...options.map((opt) {
                  final (locale, label) = opt;
                  final isSelected = locale?.languageCode == current?.languageCode;
                  return ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(label, style: AppTypography.bodyMedium),
                    trailing: isSelected
                        ? const Icon(LucideIcons.check, color: AppColors.primary)
                        : null,
                    onTap: () async {
                      await notifier.setLocale(locale);
                      if (sheetCtx.mounted) Navigator.of(sheetCtx).pop();
                      if (mounted) {
                        AppToast.show(
                          context,
                          title: context.l10n.settingsLanguageUpdated(label),
                        );
                      }
                    },
                  );
                }),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showAutoLockDialog() {
    final l10n = context.l10n;
    final notifier = ref.read(authNotifierProvider.notifier);
    final current = ref.read(authNotifierProvider).autoLockDuration;
    final options = ['Segera', '1 Menit', '5 Menit', '15 Menit'];

    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.card,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(l10n.settingsAutoLockTitle, style: AppTypography.h3),
                const SizedBox(height: 12),
                ...options.map((opt) {
                  final isSelected = opt == current;
                  final displayLabel = localizeAutoLock(l10n, opt);
                  return ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(displayLabel, style: AppTypography.bodyMedium),
                    trailing: isSelected
                        ? const Icon(LucideIcons.check, color: AppColors.primary)
                        : null,
                    onTap: () {
                      notifier.setAutoLockDuration(opt);
                      Navigator.of(context).pop();
                      AppToast.show(context,
                          title: l10n.settingsAutoLockUpdated(displayLabel));
                    },
                  );
                }),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showClipboardDurationDialog() {
    final l10n = context.l10n;
    final notifier = ref.read(authNotifierProvider.notifier);
    final current = ref.read(authNotifierProvider).clipboardDuration;
    final options = [
      {'label': l10n.clipboard30sRecommended, 'sec': 30},
      {'label': l10n.clipboardSeconds(60), 'sec': 60},
      {'label': l10n.clipboardSeconds(120), 'sec': 120},
      {'label': l10n.clipboardNeverLong, 'sec': 0},
    ];

    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.card,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(l10n.settingsClearClipboardTitle, style: AppTypography.h3),
                const SizedBox(height: 12),
                ...options.map((opt) {
                  final sec = opt['sec'] as int;
                  final label = opt['label'] as String;
                  final isSelected = sec == current;
                  return ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(label, style: AppTypography.bodyMedium),
                    trailing: isSelected
                        ? const Icon(LucideIcons.check, color: AppColors.primary)
                        : null,
                    onTap: () {
                      notifier.setClipboardDuration(sec);
                      Navigator.of(context).pop();
                      AppToast.show(context, title: l10n.settingsClipboardUpdated);
                    },
                  );
                }),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showChangePinDialog() {
    final l10n = context.l10n;
    final oldPinController = TextEditingController();
    final newPinController = TextEditingController();
    final confirmPinController = TextEditingController();
    final notifier = ref.read(authNotifierProvider.notifier);

    showDialog(
      context: context,
      builder: (dialogCtx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(l10n.settingsChangePin, style: AppTypography.h3),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AppTextField(
                controller: oldPinController,
                label: l10n.settingsOldPin,
                keyboardType: TextInputType.number,
                variant: AppTextFieldVariant.password,
              ),
              const SizedBox(height: 12),
              AppTextField(
                controller: newPinController,
                label: l10n.settingsNewPin,
                keyboardType: TextInputType.number,
                variant: AppTextFieldVariant.password,
              ),
              const SizedBox(height: 12),
              AppTextField(
                controller: confirmPinController,
                label: l10n.settingsConfirmNewPin,
                keyboardType: TextInputType.number,
                variant: AppTextFieldVariant.password,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogCtx).pop(),
            child: Text(l10n.cancel),
          ),
          AppButton(
            text: l10n.settingsSavePin,
            height: 40,
            onPressed: () async {
              final oldP = oldPinController.text.trim();
              final newP = newPinController.text.trim();
              final confP = confirmPinController.text.trim();

              if (newP.length != 6) {
                AppToast.show(context,
                    title: l10n.settingsPinLengthError,
                    iconColor: AppColors.warning);
                return;
              }
              if (newP != confP) {
                AppToast.show(context,
                    title: l10n.settingsPinMismatchError,
                    iconColor: AppColors.destructive);
                return;
              }

              final success = await notifier.changeMasterPin(oldP, newP);
              if (dialogCtx.mounted && success) {
                Navigator.of(dialogCtx).pop();
              }
              if (mounted) {
                if (success) {
                  AppToast.show(context, title: l10n.settingsPinUpdated);
                } else {
                  AppToast.show(context,
                      title: l10n.settingsOldPinWrong,
                      iconColor: AppColors.destructive);
                }
              }
            },
          ),
        ],
      ),
    );
  }

  void _showExportDialog() {
    final l10n = context.l10n;
    final passwordController = TextEditingController();

    showDialog(
      context: context,
      builder: (dialogCtx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(l10n.settingsExportTitle, style: AppTypography.h3),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.settingsExportDialogDesc,
              style: AppTypography.small.copyWith(color: AppColors.textMuted),
            ),
            const SizedBox(height: 14),
            AppTextField(
              controller: passwordController,
              label: l10n.settingsBackupPassword,
              hintText: l10n.settingsBackupPasswordHint,
              variant: AppTextFieldVariant.password,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogCtx).pop(),
            child: Text(l10n.cancel),
          ),
          AppButton(
            text: l10n.settingsExportAction,
            height: 40,
            onPressed: () async {
              final pwd = passwordController.text;
              if (pwd.length < 6) {
                AppToast.show(context,
                    title: l10n.settingsBackupPasswordMin,
                    iconColor: AppColors.warning);
                return;
              }
              Navigator.of(dialogCtx).pop();

              try {
                final repo = ref.read(vaultRepositoryProvider);
                final file = await _backupService.exportEncryptedBackup(
                  repository: repo,
                  password: pwd,
                );
                await Share.shareXFiles(
                  [XFile(file.path)],
                  text: l10n.settingsExportShareText,
                );
                if (mounted) {
                  AppToast.show(context, title: l10n.settingsExportSuccess);
                }
              } catch (e) {
                if (mounted) {
                  AppToast.show(context,
                      title: l10n.settingsExportFailed,
                      subtitle: e.toString(),
                      iconColor: AppColors.destructive);
                }
              }
            },
          ),
        ],
      ),
    );
  }

  void _importBackup() async {
    final l10n = context.l10n;
    try {
      final files = await FilePicker.pickFiles();
      if (files.isEmpty || files.first.path == null) return;

      final filePath = files.first.path!;
      final passwordController = TextEditingController();

      if (!mounted) return;
      showDialog(
        context: context,
        builder: (dialogCtx) => AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Text(l10n.settingsImportDialogTitle, style: AppTypography.h3),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.settingsImportDialogDesc,
                style:
                    AppTypography.small.copyWith(color: AppColors.textMuted),
              ),
              const SizedBox(height: 14),
              AppTextField(
                controller: passwordController,
                label: l10n.settingsBackupPassword,
                variant: AppTextFieldVariant.password,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogCtx).pop(),
              child: Text(l10n.cancel),
            ),
            AppButton(
              text: l10n.settingsImportAction,
              height: 40,
              onPressed: () async {
                final pwd = passwordController.text;
                Navigator.of(dialogCtx).pop();

                try {
                  final repo = ref.read(vaultRepositoryProvider);
                  final count = await _backupService.importEncryptedBackup(
                    repository: repo,
                    filePath: filePath,
                    password: pwd,
                  );
                  if (mounted) {
                    AppToast.show(
                      context,
                      title: l10n.settingsImportSuccess,
                      subtitle: l10n.settingsImportSuccessSubtitle(count),
                    );
                  }
                } catch (e) {
                  if (mounted) {
                    AppToast.show(
                      context,
                      title: l10n.settingsImportFailed,
                      subtitle: e.toString().replaceAll('Exception: ', ''),
                      iconColor: AppColors.destructive,
                    );
                  }
                }
              },
            ),
          ],
        ),
      );
    } catch (e) {
      if (mounted) {
        AppToast.show(
          context,
          title: l10n.settingsPickFileFailed,
          subtitle: e.toString(),
          iconColor: AppColors.destructive,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final authState = ref.watch(authNotifierProvider);
    final authNotifier = ref.read(authNotifierProvider.notifier);
    final currentLocale = ref.watch(localeProvider);

    final clipStr = authState.clipboardDuration == 0
        ? l10n.clipboardNeverShort
        : l10n.clipboardSeconds(authState.clipboardDuration);

    final languageLabel = currentLocale == null
        ? l10n.languageSystem
        : (currentLocale.languageCode == 'en'
            ? l10n.languageEnglish
            : l10n.languageIndonesian);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          l10n.settingsTitle,
          style: AppTypography.h2.copyWith(fontWeight: FontWeight.w600),
        ),
        automaticallyImplyLeading: false,
        backgroundColor: AppColors.background,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        children: [
          // Profile Vault Card
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(16),
              border:
                  Border.all(color: AppColors.primaryOutline, width: 1.2),
              boxShadow: AppShadows.sm,
            ),
            child: Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: const BoxDecoration(
                    color: AppColors.primary,
                    shape: BoxShape.circle,
                  ),
                  child: const Center(
                    child: Icon(LucideIcons.shieldCheck,
                        size: 26, color: Colors.white),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.settingsProfileTitle,
                        style: AppTypography.h3.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Row(
                        children: [
                          Container(
                            width: 8,
                            height: 8,
                            decoration: const BoxDecoration(
                              color: AppColors.success,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            l10n.settingsEncryptionActive,
                            style: AppTypography.captionMedium.copyWith(
                              color: AppColors.success,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Section: PREFERENSI
          Text(
            l10n.settingsSectionPreferences,
            style: AppTypography.captionMedium.copyWith(
              color: AppColors.textMuted,
              letterSpacing: 0.8,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            decoration: BoxDecoration(
              color: AppColors.card,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.border, width: 1.2),
            ),
            child: SettingsRow(
              title: l10n.settingsLanguage,
              icon: const Icon(LucideIcons.languages,
                  color: AppColors.primary, size: 20),
              valueText: languageLabel,
              onTap: _showLanguageDialog,
            ),
          ),
          const SizedBox(height: 24),

          // Section: KEAMANAN BRANKAS
          Text(
            l10n.settingsSectionSecurity,
            style: AppTypography.captionMedium.copyWith(
              color: AppColors.textMuted,
              letterSpacing: 0.8,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            decoration: BoxDecoration(
              color: AppColors.card,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.border, width: 1.2),
            ),
            child: Column(
              children: [
                SettingsRow(
                  title: l10n.settingsAutoLock,
                  icon: const Icon(LucideIcons.clock,
                      color: AppColors.primary, size: 20),
                  valueText: localizeAutoLock(l10n, authState.autoLockDuration),
                  onTap: _showAutoLockDialog,
                ),
                const Divider(),
                SettingsRow(
                  title: l10n.settingsBiometric,
                  subtitle: authState.isBiometricAvailable
                      ? l10n.settingsBiometricDetected
                      : l10n.settingsBiometricDefault,
                  icon: const Icon(LucideIcons.fingerprint,
                      color: AppColors.primary, size: 20),
                  trailing: AppSwitch(
                    value: authState.isBiometricEnabled,
                    onChanged: (v) async {
                      await authNotifier.toggleBiometric(v);
                      if (!context.mounted) return;
                      AppToast.show(
                        context,
                        title: v
                            ? l10n.settingsBiometricEnabled
                            : l10n.settingsBiometricDisabled,
                        subtitle: v && !authState.isBiometricAvailable
                            ? l10n.settingsBiometricHint
                            : null,
                      );
                    },
                  ),
                ),
                const Divider(),
                SettingsRow(
                  title: l10n.settingsChangePin,
                  icon: const Icon(LucideIcons.keyRound,
                      color: AppColors.primary, size: 20),
                  onTap: _showChangePinDialog,
                ),
                const Divider(),
                SettingsRow(
                  title: l10n.settingsClearClipboard,
                  icon: const Icon(LucideIcons.clipboardCheck,
                      color: AppColors.primary, size: 20),
                  valueText: clipStr,
                  onTap: _showClipboardDurationDialog,
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Section: DATA & CADANGAN
          Text(
            l10n.settingsSectionBackup,
            style: AppTypography.captionMedium.copyWith(
              color: AppColors.textMuted,
              letterSpacing: 0.8,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            decoration: BoxDecoration(
              color: AppColors.card,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.border, width: 1.2),
            ),
            child: Column(
              children: [
                SettingsRow(
                  title: l10n.settingsExportTitle,
                  subtitle: l10n.settingsExportSubtitle,
                  icon: const Icon(LucideIcons.download,
                      color: AppColors.primary, size: 20),
                  onTap: _showExportDialog,
                ),
                const Divider(),
                SettingsRow(
                  title: l10n.settingsImportTitle,
                  subtitle: l10n.settingsImportSubtitle,
                  icon: const Icon(LucideIcons.upload,
                      color: AppColors.primary, size: 20),
                  onTap: _importBackup,
                ),
                const Divider(),
                SettingsRow(
                  title: l10n.settingsCloudSync,
                  subtitle: l10n.settingsCloudSyncSubtitle,
                  icon: const Icon(LucideIcons.cloud,
                      color: AppColors.textLight, size: 20),
                  trailing: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: AppColors.border,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      l10n.settingsComingSoon,
                      style: AppTypography.captionMedium.copyWith(
                        color: AppColors.textMuted,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),

          // Lock & Exit Button
          AppButton(
            text: l10n.settingsLockAndExit,
            variant: AppButtonVariant.outline,
            icon: const Icon(LucideIcons.lock,
                size: 18, color: AppColors.destructive),
            textStyle: AppTypography.bodyMedium.copyWith(
              color: AppColors.destructive,
              fontWeight: FontWeight.w600,
            ),
            onPressed: () {
              authNotifier.lock();
            },
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }
}
