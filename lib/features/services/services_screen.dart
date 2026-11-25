import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:material_ui/material_ui.dart';
import '../../core/l10n/locale_provider.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_shadows.dart';
import '../../core/theme/app_typography.dart';
import '../../core/widgets/app_text_field.dart';
import '../../core/widgets/app_toast.dart';
import '../../core/widgets/category_chip.dart';
import '../../core/widgets/empty_state.dart';
import '../../core/widgets/service_card.dart';
import '../../core/widgets/skeleton_card.dart';
import '../../data/repositories/vault_repository.dart';
import '../accounts/service_accounts_screen.dart';
import '../search/search_screen.dart';
import 'edit_service_screen.dart';
import 'widgets/service_options_bottom_sheet.dart';

class ServicesScreen extends ConsumerStatefulWidget {
  const ServicesScreen({super.key});

  @override
  ConsumerState<ServicesScreen> createState() => _ServicesScreenState();
}

class _ServicesScreenState extends ConsumerState<ServicesScreen> {
  String _selectedCategory = 'Semua';
  final List<String> _categories = [
    'Semua',
    'Game',
    'Sosial',
    'Kerja',
    'Hiburan',
  ];

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final repo = ref.watch(vaultRepositoryProvider);
    final summaryStream = repo.watchSecuritySummary();
    final servicesStream = repo.watchServices(
      category: _selectedCategory == 'Semua' ? null : _selectedCategory,
    );

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // Top Header: Logo + Title + Notification + Avatar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              child: Row(
                children: [
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: AppColors.primarySoft,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Center(
                      child: Icon(
                        LucideIcons.shieldCheck,
                        size: 20,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    'SafeDeck',
                    style: AppTypography.h1.copyWith(
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    tooltip: l10n.servicesSecurityNotification,
                    icon: const Icon(LucideIcons.bell,
                        size: 20, color: AppColors.textPrimary),
                    onPressed: () {
                      AppToast.show(
                        context,
                        title: l10n.servicesAllSafeTitle,
                        subtitle: l10n.servicesAllSafeSubtitle,
                      );
                    },
                  ),
                  const SizedBox(width: 4),
                  Container(
                    width: 36,
                    height: 36,
                    decoration: const BoxDecoration(
                      color: AppColors.primary,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        'L',
                        style: AppTypography.smallMedium.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            Expanded(
              child: ListView(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
                children: [
                  // Security Overview Card
                  StreamBuilder<SecuritySummary>(
                    stream: summaryStream,
                    builder: (context, snapshot) {
                      final summary = snapshot.data ??
                          const SecuritySummary(
                            totalAccounts: 0,
                            totalServices: 0,
                            safeScorePercent: 100,
                          );

                      return Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                              color: AppColors.primaryOutline, width: 1.2),
                          boxShadow: AppShadows.sm,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Icon(LucideIcons.shieldCheck,
                                    size: 16, color: AppColors.primary),
                                const SizedBox(width: 6),
                                Text(
                                  l10n.servicesEncryptedBanner,
                                  style: AppTypography.captionMedium.copyWith(
                                    color: AppColors.primary,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 14),
                            Row(
                              children: [
                                // Metric 1: Akun
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        l10n.servicesMetricAccounts(summary.totalAccounts),
                                        style: AppTypography.h3.copyWith(
                                          fontWeight: FontWeight.w700,
                                          color: AppColors.textPrimary,
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        l10n.servicesMetricSaved,
                                        style: AppTypography.caption.copyWith(
                                          color: AppColors.textMuted,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  width: 1,
                                  height: 28,
                                  color: AppColors.border,
                                ),
                                // Metric 2: Layanan
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 12),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          l10n.servicesMetricServices(summary.totalServices),
                                          style: AppTypography.h3.copyWith(
                                            fontWeight: FontWeight.w700,
                                            color: AppColors.textPrimary,
                                          ),
                                        ),
                                        const SizedBox(height: 2),
                                        Text(
                                          l10n.servicesMetricCategories,
                                          style: AppTypography.caption.copyWith(
                                            color: AppColors.textMuted,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Container(
                                  width: 1,
                                  height: 28,
                                  color: AppColors.border,
                                ),
                                // Metric 3: Skor Aman
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 12),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          '${summary.safeScorePercent}%',
                                          style: AppTypography.h3.copyWith(
                                            fontWeight: FontWeight.w700,
                                            color: summary.safeScorePercent >=
                                                    80
                                                ? AppColors.success
                                                : (summary.safeScorePercent >=
                                                        50
                                                    ? AppColors.warning
                                                    : AppColors.destructive),
                                          ),
                                        ),
                                        const SizedBox(height: 2),
                                        Text(
                                          l10n.servicesMetricSafeScore,
                                          style: AppTypography.caption.copyWith(
                                            color: AppColors.textMuted,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 16),

                  // Search bar
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const SearchScreen(),
                        ),
                      );
                    },
                    child: AbsorbPointer(
                      child: AppTextField(
                        hintText: l10n.servicesSearchHint,
                        variant: AppTextFieldVariant.search,
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),

                  // Category Chips
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: _categories.map((cat) {
                        return Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: CategoryChip(
                            label: localizeCategory(l10n, cat),
                            isSelected: _selectedCategory == cat,
                            onTap: () {
                              setState(() => _selectedCategory = cat);
                            },
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                  const SizedBox(height: 18),

                  // Services list
                  StreamBuilder<List<ServiceWithAccounts>>(
                    stream: servicesStream,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState ==
                          ConnectionState.waiting) {
                        return const Column(
                          children: [
                            SkeletonCard(),
                            SizedBox(height: 10),
                            SkeletonCard(),
                            SizedBox(height: 10),
                            SkeletonCard(),
                          ],
                        );
                      }

                      final services =
                          List<ServiceWithAccounts>.from(snapshot.data ?? []);

                      if (services.isEmpty) {
                        return EmptyState(
                          title: l10n.servicesEmptyTitle,
                          description: l10n.servicesEmptyDesc,
                          actionText: l10n.servicesEmptyAction,
                          tipText: l10n.servicesEmptyTip,
                          onAction: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => const EditServiceScreen(),
                              ),
                            );
                          },
                        );
                      }

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(bottom: 10, top: 4),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  l10n.servicesListHeader(services.length),
                                  style: AppTypography.captionMedium.copyWith(
                                    color: AppColors.textMuted,
                                    letterSpacing: 0.8,
                                  ),
                                ),
                                Row(
                                  children: [
                                    const Icon(
                                      LucideIcons.gripVertical,
                                      size: 13,
                                      color: AppColors.textLight,
                                    ),
                                    const SizedBox(width: 2),
                                    Text(
                                      l10n.servicesDragHint,
                                      style: AppTypography.caption.copyWith(
                                        color: AppColors.textMuted,
                                        fontSize: 11,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          ReorderableListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            buildDefaultDragHandles: false,
                            itemCount: services.length,
                            onReorder: (oldIndex, newIndex) async {
                              if (newIndex > oldIndex) {
                                newIndex -= 1;
                              }
                              final item = services.removeAt(oldIndex);
                              services.insert(newIndex, item);
                              final ids =
                                  services.map((s) => s.service.id).toList();
                              await ref
                                  .read(vaultRepositoryProvider)
                                  .reorderServices(ids);
                            },
                            itemBuilder: (context, index) {
                              final s = services[index];
                              Color color = AppColors.primary;
                              try {
                                final hex =
                                    s.service.colorHex.replaceAll('#', '');
                                color = Color(int.parse('FF$hex', radix: 16));
                              } catch (_) {}

                              return Padding(
                                key: ValueKey(s.service.id),
                                padding: const EdgeInsets.only(bottom: 10),
                                child: ServiceCard(
                                  name: s.service.name,
                                  category: s.service.category,
                                  accountCount: s.accountCount,
                                  color: color,
                                  iconKey: s.service.iconKey,
                                  url: s.service.url,
                                  dragHandle: ReorderableDragStartListener(
                                    index: index,
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 4,
                                        vertical: 6,
                                      ),
                                      color: Colors.transparent,
                                      child: const Icon(
                                        LucideIcons.gripVertical,
                                        size: 20,
                                        color: AppColors.textLight,
                                      ),
                                    ),
                                  ),
                                  onTap: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            ServiceAccountsScreen(
                                          serviceId: s.service.id,
                                        ),
                                      ),
                                    );
                                  },
                                  onLongPress: () {
                                    ServiceOptionsBottomSheet.show(
                                      context,
                                      serviceWithAccounts: s,
                                    );
                                  },
                                ),
                              );
                            },
                          ),
                        ],
                      );
                    },
                  ),
                  const SizedBox(height: 80),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: AppColors.primary,
        icon: const Icon(LucideIcons.plus, color: Colors.white, size: 20),
        label: Text(
          l10n.servicesAddButton,
          style: AppTypography.smallMedium.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const EditServiceScreen(),
            ),
          );
        },
      ),
    );
  }
}
