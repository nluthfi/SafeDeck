import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:material_ui/material_ui.dart';
import '../../core/l10n/locale_provider.dart';
import '../../core/security/auth_provider.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/widgets/app_button.dart';
import '../../core/widgets/app_header.dart';
import '../../core/widgets/app_toast.dart';
import '../../core/widgets/confirm_dialog.dart';
import '../../core/widgets/field_card.dart';
import '../../core/widgets/service_brand_icon.dart';
import '../../core/widgets/strength_indicator.dart';
import '../../data/database/database.dart';
import '../../data/repositories/vault_repository.dart';
import 'edit_account_screen.dart';

class AccountDetailScreen extends ConsumerWidget {
  const AccountDetailScreen({
    super.key,
    required this.accountId,
  });

  final String accountId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final localeCode = Localizations.maybeLocaleOf(context)?.languageCode ?? 'id';
    final repo = ref.watch(vaultRepositoryProvider);
    final accountStream = repo.watchAccountById(accountId);

    return StreamBuilder<Account?>(
      stream: accountStream,
      builder: (context, snapshot) {
        final account = snapshot.data;

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            appBar: AppHeader(title: l10n.accountDetailTitle),
            body: const Center(child: CircularProgressIndicator()),
          );
        }

        if (account == null) {
          return Scaffold(
            appBar: AppHeader(title: l10n.accountDetailTitle),
            body: Center(
              child: Text(
                l10n.accountDetailNotFound,
                style: AppTypography.body.copyWith(color: AppColors.textMuted),
              ),
            ),
          );
        }

        final pwdEval = PasswordStrengthEvaluator.evaluate(account.password);
        final strengthLabel = localizeStrengthLabel(
          l10n,
          pwdEval.strength,
          isEmpty: pwdEval.score == 0,
        );
        final strengthDetail = localizeStrengthDetail(
          l10n,
          pwdEval,
          account.password.length,
        );

        String formatDate(DateTime dt) {
          try {
            return DateFormat('dd MMM yyyy', localeCode).format(dt);
          } catch (_) {
            const monthsId = [
              'Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Jun',
              'Jul', 'Agu', 'Sep', 'Okt', 'Nov', 'Des'
            ];
            const monthsEn = [
              'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
              'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
            ];
            final months = localeCode == 'en' ? monthsEn : monthsId;
            final m = dt.month >= 1 && dt.month <= 12
                ? months[dt.month - 1]
                : '${dt.month}';
            return '${dt.day.toString().padLeft(2, '0')} $m ${dt.year}';
          }
        }

        final createdStr = formatDate(account.createdAt);
        final updatedStr = formatDate(account.updatedAt);

        return Scaffold(
          appBar: AppHeader(
            title: l10n.accountDetailTitle,
            showBackButton: true,
            actions: [
              IconButton(
                tooltip: l10n.accountDetailEditTooltip,
                icon: const Icon(LucideIcons.pencil, size: 20, color: AppColors.primary),
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => EditAccountScreen(accountId: account.id),
                    ),
                  );
                },
              ),
            ],
          ),
          body: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            children: [
              // Badges
              Row(
                children: [
                  FutureBuilder<ServiceWithAccounts?>(
                    future: repo.getServiceById(account.serviceId),
                    builder: (context, sSnap) {
                      final service = sSnap.data?.service;
                      final serviceName = service?.name ?? l10n.serviceFallback;
                      final resolvedKey = ServiceIconHelper.resolveIconKey(
                        iconKey: service?.iconKey,
                        serviceName: serviceName,
                      );

                      return Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.primarySoft,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (resolvedKey != null) ...[
                              ServiceBrandIcon(
                                iconKey: resolvedKey,
                                size: 14,
                                color: AppColors.primary,
                              ),
                              const SizedBox(width: 5),
                            ],
                            Text(
                              serviceName,
                              style: AppTypography.captionMedium.copyWith(
                                color: AppColors.primary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                  const SizedBox(width: 8),
                  StrengthBadge(
                    strength: pwdEval.strength,
                    customLabel: strengthLabel,
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Title
              Text(
                account.label,
                style: AppTypography.h1.copyWith(
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 20),

              // Field 1: Username / ID
              if (account.username != null && account.username!.isNotEmpty) ...[
                FieldCard(
                  label: l10n.accountDetailUsernameField,
                  value: account.username!,
                  onCopy: () => _copy(context, ref, account.username!, l10n.idLabel),
                ),
                const SizedBox(height: 12),
              ],

              // Field 2: Email
              if (account.email != null && account.email!.isNotEmpty) ...[
                FieldCard(
                  label: l10n.accountDetailEmailField,
                  value: account.email!,
                  onCopy: () => _copy(context, ref, account.email!, l10n.emailLabel),
                ),
                const SizedBox(height: 12),
              ],

              // Field 3: Password
              FieldCard(
                label: l10n.accountDetailPasswordField,
                value: account.password,
                isPassword: true,
                onCopy: () => _copy(context, ref, account.password, l10n.passwordLabel, isPassword: true),
                bottomWidget: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    StrengthBar(score: pwdEval.score),
                    const SizedBox(height: 6),
                    Text(
                      '$strengthLabel ($strengthDetail)',
                      style: AppTypography.captionMedium.copyWith(
                        color: pwdEval.color,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),

              // Field 4: Recovery Code
              if (account.recoveryCode != null && account.recoveryCode!.isNotEmpty) ...[
                FieldCard(
                  label: l10n.accountDetailRecoveryField,
                  value: account.recoveryCode!,
                  onCopy: () => _copy(context, ref, account.recoveryCode!, l10n.recoveryCodeShort),
                ),
                const SizedBox(height: 12),
              ],

              // Field 5: Note
              if (account.note != null && account.note!.isNotEmpty) ...[
                FieldCard(
                  label: l10n.accountDetailNoteField,
                  value: account.note!,
                ),
                const SizedBox(height: 12),
              ],

              // Timestamps
              const SizedBox(height: 4),
              Text(
                l10n.accountDetailTimestamps(createdStr, updatedStr),
                style: AppTypography.caption.copyWith(
                  color: AppColors.textLight,
                ),
              ),
              const SizedBox(height: 28),

              // Action: Salin Semua Info Akun
              AppButton(
                text: l10n.accountDetailCopyAll,
                variant: AppButtonVariant.primary,
                icon: const Icon(LucideIcons.copy, size: 18, color: Colors.white),
                onPressed: () {
                  final buffer = StringBuffer();
                  buffer.writeln('${l10n.serviceFallback}: ${account.label}');
                  if (account.username != null) buffer.writeln('Username: ${account.username}');
                  if (account.email != null) buffer.writeln('Email: ${account.email}');
                  buffer.writeln('Password: ${account.password}');
                  if (account.recoveryCode != null) buffer.writeln('2FA: ${account.recoveryCode}');
                  _copy(context, ref, buffer.toString(), l10n.allAccountInfo, isPassword: true);
                },
              ),
              const SizedBox(height: 12),

              // Action: Hapus Akun Ini
              AppButton(
                text: l10n.accountDetailDelete,
                variant: AppButtonVariant.destructive,
                icon: const Icon(LucideIcons.trash2, size: 18, color: Colors.white),
                onPressed: () async {
                  final confirmed = await ConfirmDialog.show(
                    context,
                    title: l10n.accountDetailDeleteTitle,
                    message: l10n.accountDetailDeleteMessage(account.label),
                    confirmText: l10n.accountDetailDeleteConfirm,
                  );
                  if (confirmed == true) {
                    await repo.deleteAccount(account.id);
                    if (context.mounted) {
                      AppToast.show(context, title: l10n.accountDetailDeletedToast);
                      Navigator.of(context).pop();
                    }
                  }
                },
              ),
              const SizedBox(height: 24),
            ],
          ),
        );
      },
    );
  }

  void _copy(
    BuildContext context,
    WidgetRef ref,
    String text,
    String label, {
    bool isPassword = false,
  }) {
    final l10n = context.l10n;
    final clipSec = ref.read(authNotifierProvider).clipboardDuration;
    ref.read(securityServiceProvider).copyToClipboard(text, seconds: clipSec);

    AppToast.show(
      context,
      title: l10n.copiedSuccess(label),
      subtitle: isPassword && clipSec > 0
          ? l10n.clipboardAutoClearNotice(clipSec)
          : null,
    );
  }
}
