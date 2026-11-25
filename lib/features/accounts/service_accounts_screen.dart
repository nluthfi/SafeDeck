import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:material_ui/material_ui.dart';
import '../../core/l10n/locale_provider.dart';
import '../../core/security/auth_provider.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_shadows.dart';
import '../../core/theme/app_typography.dart';
import '../../core/widgets/account_card.dart';
import '../../core/widgets/app_button.dart';
import '../../core/widgets/app_header.dart';
import '../../core/widgets/app_text_field.dart';
import '../../core/widgets/app_toast.dart';
import '../../core/widgets/empty_state.dart';
import '../../core/widgets/service_brand_icon.dart';
import '../../core/widgets/strength_indicator.dart';
import '../../data/database/database.dart';
import '../../data/repositories/vault_repository.dart';
import '../services/widgets/service_options_bottom_sheet.dart';
import 'account_detail_screen.dart';
import 'edit_account_screen.dart';

class ServiceAccountsScreen extends ConsumerStatefulWidget {
  const ServiceAccountsScreen({
    super.key,
    required this.serviceId,
  });

  final String serviceId;

  @override
  ConsumerState<ServiceAccountsScreen> createState() =>
      _ServiceAccountsScreenState();
}

class _ServiceAccountsScreenState extends ConsumerState<ServiceAccountsScreen> {
  final _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _copy(String text, String label, {bool isPassword = false}) {
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

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final repo = ref.watch(vaultRepositoryProvider);
    final accountsStream = repo.watchAccountsForService(widget.serviceId);

    return FutureBuilder<ServiceWithAccounts?>(
      future: repo.getServiceById(widget.serviceId),
      builder: (context, sSnap) {
        final serviceWithAcc = sSnap.data;
        final service = serviceWithAcc?.service;
        final serviceName = service?.name ?? l10n.serviceFallback;

        Color serviceColor = AppColors.primary;
        if (service != null) {
          try {
            final hex = service.colorHex.replaceAll('#', '');
            serviceColor = Color(int.parse('FF$hex', radix: 16));
          } catch (_) {}
        }

        return Scaffold(
          appBar: AppHeader(
            title: serviceName,
            showBackButton: true,
            actions: [
              if (serviceWithAcc != null) ...[
                IconButton(
                  tooltip: l10n.serviceAccountsOptionsTooltip,
                  icon: const Icon(LucideIcons.ellipsisVertical,
                      size: 20, color: AppColors.textPrimary),
                  onPressed: () {
                    ServiceOptionsBottomSheet.show(
                      context,
                      serviceWithAccounts: serviceWithAcc,
                      onDeleted: () => Navigator.of(context).pop(),
                    );
                  },
                ),
              ],
            ],
          ),
          body: StreamBuilder<List<Account>>(
            stream: accountsStream,
            builder: (context, snapshot) {
              final allAccounts = snapshot.data ?? [];
              final filtered = allAccounts.where((acc) {
                if (_searchQuery.isEmpty) return true;
                final q = _searchQuery.toLowerCase();
                return acc.label.toLowerCase().contains(q) ||
                    (acc.username?.toLowerCase().contains(q) ?? false) ||
                    (acc.email?.toLowerCase().contains(q) ?? false);
              }).toList();

              return Column(
                children: [
                  Expanded(
                    child: ListView(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 12),
                      children: [
                        // Service Banner Card
                        if (service != null) ...[
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: AppColors.card,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                  color: AppColors.border, width: 1.2),
                              boxShadow: AppShadows.sm,
                            ),
                            child: Row(
                              children: [
                                ServiceAvatar(
                                  name: service.name,
                                  color: serviceColor,
                                  iconKey: service.iconKey,
                                  size: 48,
                                  borderRadius: 10,
                                ),
                                const SizedBox(width: 14),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        '${service.name} (${localizeCategory(l10n, service.category)})',
                                        style: AppTypography.h3.copyWith(
                                          fontWeight: FontWeight.w600,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        l10n.serviceAccountsActiveSummary(
                                          allAccounts.length,
                                          service.url ?? l10n.localLabel,
                                        ),
                                        style: AppTypography.small.copyWith(
                                          color: AppColors.textMuted,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 16),
                        ],

                        // Search Input
                        AppTextField(
                          controller: _searchController,
                          hintText: l10n.serviceAccountsSearchHint(serviceName),
                          variant: AppTextFieldVariant.search,
                          onChanged: (q) => setState(() => _searchQuery = q),
                        ),
                        const SizedBox(height: 16),

                        // List of accounts or empty state
                        if (allAccounts.isEmpty) ...[
                          EmptyState(
                            title: l10n.serviceAccountsEmptyTitle,
                            description:
                                l10n.serviceAccountsEmptyDesc(serviceName),
                            actionText: l10n.serviceAccountsAddButton(serviceName),
                            onAction: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => EditAccountScreen(
                                    initialServiceId: widget.serviceId,
                                  ),
                                ),
                              );
                            },
                          ),
                        ] else if (filtered.isEmpty) ...[
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 40),
                            child: Center(
                              child: Text(
                                l10n.serviceAccountsNoMatch(_searchQuery),
                                style: AppTypography.body
                                    .copyWith(color: AppColors.textMuted),
                              ),
                            ),
                          ),
                        ] else ...[
                          ...filtered.map((acc) {
                            final eval =
                                PasswordStrengthEvaluator.evaluate(acc.password);
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 12),
                              child: AccountCard(
                                label: acc.label,
                                strength: eval.strength,
                                username: acc.username,
                                email: acc.email,
                                onTap: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) => AccountDetailScreen(
                                          accountId: acc.id),
                                    ),
                                  );
                                },
                                onCopyId: () {
                                  final idToCopy = (acc.username != null &&
                                          acc.username!.isNotEmpty)
                                      ? acc.username!
                                      : (acc.email ?? '');
                                  if (idToCopy.isNotEmpty) {
                                    _copy(idToCopy, l10n.idLabel);
                                  }
                                },
                                onCopyPassword: () {
                                  _copy(acc.password, l10n.passwordLabel,
                                      isPassword: true);
                                },
                              ),
                            );
                          }),
                        ],
                      ],
                    ),
                  ),

                  // Bottom Button: Tambah Akun [Layanan]
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    decoration: const BoxDecoration(
                      color: AppColors.background,
                      border: Border(
                        top: BorderSide(color: AppColors.border, width: 1),
                      ),
                    ),
                    child: SafeArea(
                      top: false,
                      child: AppButton(
                        text: l10n.serviceAccountsAddButton(serviceName),
                        icon: const Icon(LucideIcons.plus,
                            size: 18, color: Colors.white),
                        width: double.infinity,
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => EditAccountScreen(
                                initialServiceId: widget.serviceId,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }
}
