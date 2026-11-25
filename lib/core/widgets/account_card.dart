import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:material_ui/material_ui.dart';
import '../l10n/locale_provider.dart';
import '../theme/app_colors.dart';
import '../theme/app_shadows.dart';
import '../theme/app_typography.dart';
import 'app_button.dart';
import 'strength_indicator.dart';

class AccountCard extends StatelessWidget {
  const AccountCard({
    super.key,
    required this.label,
    required this.strength,
    this.username,
    this.email,
    this.onTap,
    this.onCopyId,
    this.onCopyPassword,
  });

  final String label;
  final PasswordStrength strength;
  final String? username;
  final String? email;
  final VoidCallback? onTap;
  final VoidCallback? onCopyId;
  final VoidCallback? onCopyPassword;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border, width: 1.2),
        boxShadow: AppShadows.sm,
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header: Label + Strength Badge
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        label,
                        style: AppTypography.h3.copyWith(
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 8),
                    StrengthBadge(strength: strength),
                  ],
                ),
                const SizedBox(height: 10),
                // Details (Username & Email)
                if (username != null && username!.isNotEmpty) ...[
                  Row(
                    children: [
                      const Icon(LucideIcons.user, size: 14, color: AppColors.textMuted),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          username!,
                          style: AppTypography.small.copyWith(
                            color: AppColors.textPrimary,
                            fontWeight: FontWeight.w500,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                ],
                if (email != null && email!.isNotEmpty) ...[
                  Row(
                    children: [
                      const Icon(LucideIcons.mail, size: 14, color: AppColors.textMuted),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          email!,
                          style: AppTypography.small.copyWith(
                            color: AppColors.textMuted,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                ] else ...[
                  const SizedBox(height: 6),
                ],
                // Action Buttons: Salin ID & Salin Password
                Row(
                  children: [
                    Expanded(
                      child: AppButton(
                        text: context.l10n.copyId,
                        variant: AppButtonVariant.outline,
                        height: 38,
                        icon: const Icon(LucideIcons.copy, size: 15, color: AppColors.primary),
                        onPressed: onCopyId,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: AppButton(
                        text: context.l10n.copyPassword,
                        variant: AppButtonVariant.primary,
                        height: 38,
                        icon: const Icon(LucideIcons.key, size: 15, color: Colors.white),
                        onPressed: onCopyPassword,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
