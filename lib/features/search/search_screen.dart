import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:material_ui/material_ui.dart';
import '../../core/l10n/locale_provider.dart';
import '../../core/security/auth_provider.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/widgets/account_card.dart';
import '../../core/widgets/app_text_field.dart';
import '../../core/widgets/app_toast.dart';
import '../../core/widgets/service_card.dart';
import '../../core/widgets/strength_indicator.dart';
import '../../data/repositories/vault_repository.dart';
import '../accounts/account_detail_screen.dart';
import '../accounts/service_accounts_screen.dart';
import '../services/widgets/service_options_bottom_sheet.dart';

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  final _searchController = TextEditingController();
  Timer? _debounceTimer;
  SearchResults _results = const SearchResults(services: [], accounts: []);
  bool _isLoading = false;
  String _currentQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    _debounceTimer?.cancel();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 250), () async {
      final q = query.trim();
      if (!mounted) return;
      setState(() {
        _currentQuery = q;
        _isLoading = true;
      });

      if (q.isEmpty) {
        setState(() {
          _results = const SearchResults(services: [], accounts: []);
          _isLoading = false;
        });
        return;
      }

      final repo = ref.read(vaultRepositoryProvider);
      final res = await repo.search(q);
      if (mounted) {
        setState(() {
          _results = res;
          _isLoading = false;
        });
      }
    });
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
    final totalFound = _results.services.length + _results.accounts.length;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        titleSpacing: 0,
        leading: IconButton(
          icon: const Icon(LucideIcons.arrowLeft, color: AppColors.textPrimary),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Padding(
          padding: const EdgeInsets.only(right: 16),
          child: AppTextField(
            controller: _searchController,
            hintText: l10n.servicesSearchHint,
            variant: AppTextFieldVariant.search,
            autofocus: true,
            onChanged: _onSearchChanged,
          ),
        ),
        backgroundColor: AppColors.background,
        elevation: 0,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _currentQuery.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 64,
                        height: 64,
                        decoration: const BoxDecoration(
                          color: AppColors.primarySoft,
                          shape: BoxShape.circle,
                        ),
                        child: const Center(
                          child: Icon(LucideIcons.search,
                              size: 28, color: AppColors.primary),
                        ),
                      ),
                      const SizedBox(height: 14),
                      Text(
                        l10n.searchEmptyTitle,
                        style: AppTypography.h3.copyWith(
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        l10n.searchEmptySubtitle,
                        style: AppTypography.small.copyWith(
                          color: AppColors.textMuted,
                        ),
                      ),
                    ],
                  ),
                )
              : totalFound == 0
                  ? Center(
                      child: Padding(
                        padding: const EdgeInsets.all(24),
                        child: Text(
                          l10n.searchNoResults(_currentQuery),
                          style: AppTypography.body.copyWith(
                            color: AppColors.textMuted,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    )
                  : ListView(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 16),
                      children: [
                        // Services group
                        if (_results.services.isNotEmpty) ...[
                          Text(
                            l10n.searchServicesGroup(_results.services.length),
                            style: AppTypography.captionMedium.copyWith(
                              color: AppColors.textMuted,
                              letterSpacing: 0.8,
                            ),
                          ),
                          const SizedBox(height: 10),
                          ..._results.services.map((s) {
                            Color color = AppColors.primary;
                            try {
                              final hex =
                                  s.service.colorHex.replaceAll('#', '');
                              color = Color(int.parse('FF$hex', radix: 16));
                            } catch (_) {}

                            return Padding(
                              padding: const EdgeInsets.only(bottom: 10),
                              child: ServiceCard(
                                name: s.service.name,
                                category: s.service.category,
                                accountCount: s.accountCount,
                                color: color,
                                iconKey: s.service.iconKey,
                                onTap: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          ServiceAccountsScreen(
                                              serviceId: s.service.id),
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
                          }),
                          const SizedBox(height: 18),
                        ],

                        // Accounts group
                        if (_results.accounts.isNotEmpty) ...[
                          Text(
                            l10n.searchAccountsGroup(_results.accounts.length),
                            style: AppTypography.captionMedium.copyWith(
                              color: AppColors.textMuted,
                              letterSpacing: 0.8,
                            ),
                          ),
                          const SizedBox(height: 10),
                          ..._results.accounts.map((item) {
                            final eval = PasswordStrengthEvaluator.evaluate(
                                item.account.password);
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 12),
                              child: AccountCard(
                                label:
                                    '${item.service.name}: ${item.account.label}',
                                strength: eval.strength,
                                username: item.account.username,
                                email: item.account.email,
                                onTap: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          AccountDetailScreen(
                                              accountId: item.account.id),
                                    ),
                                  );
                                },
                                onCopyId: () {
                                  final idToCopy = (item.account.username !=
                                              null &&
                                          item.account.username!.isNotEmpty)
                                      ? item.account.username!
                                      : (item.account.email ?? '');
                                  if (idToCopy.isNotEmpty) {
                                    _copy(idToCopy, l10n.idLabel);
                                  }
                                },
                                onCopyPassword: () {
                                  _copy(item.account.password, l10n.passwordLabel,
                                      isPassword: true);
                                },
                              ),
                            );
                          }),
                        ],
                      ],
                    ),
    );
  }
}
