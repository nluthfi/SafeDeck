import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:material_ui/material_ui.dart';
import '../../../core/l10n/locale_provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_toast.dart';
import '../../../core/widgets/confirm_dialog.dart';
import '../../../core/widgets/service_brand_icon.dart';
import '../../../data/repositories/vault_repository.dart';
import '../edit_service_screen.dart';

class ServiceOptionsBottomSheet extends ConsumerWidget {
  const ServiceOptionsBottomSheet({
    super.key,
    required this.serviceWithAccounts,
    this.onDeleted,
    this.parentContext,
  });

  final ServiceWithAccounts serviceWithAccounts;
  final VoidCallback? onDeleted;
  final BuildContext? parentContext;

  static Future<void> show(
    BuildContext context, {
    required ServiceWithAccounts serviceWithAccounts,
    VoidCallback? onDeleted,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => ServiceOptionsBottomSheet(
        serviceWithAccounts: serviceWithAccounts,
        onDeleted: onDeleted,
        parentContext: context,
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final repo = ref.read(vaultRepositoryProvider);
    final service = serviceWithAccounts.service;
    final accountCount = serviceWithAccounts.accountCount;

    Color serviceColor = AppColors.primary;
    try {
      final hex = service.colorHex.replaceAll('#', '');
      serviceColor = Color(int.parse('FF$hex', radix: 16));
    } catch (_) {}

    return Material(
      color: AppColors.card,
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(20),
        topRight: Radius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: SafeArea(
          top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Handle bar
            Center(
              child: Container(
                width: 36,
                height: 4,
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: AppColors.border,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            // Header with Avatar
            Row(
              children: [
                ServiceAvatar(
                  name: service.name,
                  color: serviceColor,
                  iconKey: service.iconKey,
                  size: 44,
                  borderRadius: 10,
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        service.name,
                        style: AppTypography.h2.copyWith(fontWeight: FontWeight.w600),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        l10n.serviceOptionsAccountCount(
                          localizeCategory(l10n, service.category),
                          accountCount,
                        ),
                        style: AppTypography.small.copyWith(color: AppColors.textMuted),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Divider(),

            // Item 1: Ubah Nama & Kategori Layanan
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(LucideIcons.pencil, color: AppColors.primary, size: 20),
              title: Text(
                l10n.serviceOptionsEdit,
                style: AppTypography.bodyMedium,
              ),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => EditServiceScreen(serviceId: service.id),
                  ),
                );
              },
            ),

            // Item 2: Duplikat Format Layanan
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(LucideIcons.copy, color: AppColors.primary, size: 20),
              title: Text(
                l10n.serviceOptionsDuplicate,
                style: AppTypography.bodyMedium,
              ),
              onTap: () async {
                final repo = ref.read(vaultRepositoryProvider);
                await repo.createService(
                  name: '${service.name} ${l10n.serviceOptionsCopySuffix}',
                  category: service.category,
                  colorHex: service.colorHex,
                  url: service.url,
                );
                if (context.mounted) {
                  Navigator.of(context).pop();
                  AppToast.show(context, title: l10n.serviceOptionsDuplicatedToast);
                }
              },
            ),

            // Item 3: Kunci dengan PIN Tambahan
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(LucideIcons.lockKeyhole, color: AppColors.primary, size: 20),
              title: Text(
                l10n.serviceOptionsExtraPin,
                style: AppTypography.bodyMedium,
              ),
              onTap: () {
                Navigator.of(context).pop();
                AppToast.show(
                  context,
                  title: l10n.serviceOptionsExtraPinToast(service.name),
                );
              },
            ),

            // Item 4: Hapus Layanan & Semua Akun
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(LucideIcons.trash2,
                  color: AppColors.destructive, size: 20),
              title: Text(
                l10n.serviceOptionsDelete,
                style: AppTypography.bodyMedium
                    .copyWith(color: AppColors.destructive),
              ),
              onTap: () async {
                final confirmed = await ConfirmDialog.show(
                  context,
                  title: l10n.editServiceDeleteConfirmTitle(service.name),
                  message: l10n.serviceOptionsDeleteMessage(accountCount, service.name),
                  confirmText: l10n.editServiceDeleteConfirmAction,
                );

                if (confirmed == true) {
                  if (context.mounted) {
                    Navigator.of(context).pop();
                  }
                  await repo.deleteService(service.id);
                  onDeleted?.call();
                }
              },
            ),
            const SizedBox(height: 12),

            // Batal button
            AppButton(
              text: l10n.cancel,
              variant: AppButtonVariant.ghost,
              width: double.infinity,
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        ),
      ),
    ),
  );
}
}
