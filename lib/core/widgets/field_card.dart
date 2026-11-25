import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:material_ui/material_ui.dart';
import '../l10n/locale_provider.dart';
import '../theme/app_colors.dart';
import '../theme/app_shadows.dart';
import '../theme/app_typography.dart';

class FieldCard extends StatefulWidget {
  const FieldCard({
    super.key,
    required this.label,
    required this.value,
    this.isPassword = false,
    this.onCopy,
    this.bottomWidget,
  });

  final String label;
  final String value;
  final bool isPassword;
  final VoidCallback? onCopy;
  final Widget? bottomWidget;

  @override
  State<FieldCard> createState() => _FieldCardState();
}

class _FieldCardState extends State<FieldCard> {
  bool _revealed = false;

  @override
  Widget build(BuildContext context) {
    final displayValue = widget.isPassword && !_revealed
        ? '••••••••••••••••'
        : (widget.value.isEmpty ? '-' : widget.value);

    return Container(
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border, width: 1.2),
        boxShadow: AppShadows.sm,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.label.toUpperCase(),
            style: AppTypography.captionMedium.copyWith(
              color: AppColors.textMuted,
              letterSpacing: 0.8,
            ),
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              Expanded(
                child: Text(
                  displayValue,
                  style: AppTypography.bodyMedium.copyWith(
                    color: AppColors.textPrimary,
                    fontFamily: widget.isPassword && !_revealed ? null : 'Inter',
                    letterSpacing: widget.isPassword && !_revealed ? 2.0 : 0.0,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (widget.isPassword) ...[
                IconButton(
                  tooltip: _revealed
                      ? context.l10n.hidePassword
                      : context.l10n.showPassword,
                  icon: Icon(
                    _revealed ? LucideIcons.eyeOff : LucideIcons.eye,
                    size: 20,
                    color: AppColors.textMuted,
                  ),
                  onPressed: () {
                    setState(() {
                      _revealed = !_revealed;
                    });
                  },
                ),
              ],
              if (widget.onCopy != null) ...[
                IconButton(
                  tooltip: context.l10n.copyValue,
                  icon: const Icon(
                    LucideIcons.copy,
                    size: 20,
                    color: AppColors.primary,
                  ),
                  onPressed: widget.onCopy,
                ),
              ],
            ],
          ),
          if (widget.bottomWidget != null) ...[
            const SizedBox(height: 10),
            widget.bottomWidget!,
          ],
        ],
      ),
    );
  }
}
