import 'package:material_ui/material_ui.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';

enum AppButtonVariant {
  primary,
  outline,
  soft,
  destructive,
  ghost,
}

class AppButton extends StatelessWidget {
  const AppButton({
    super.key,
    required this.text,
    this.onPressed,
    this.variant = AppButtonVariant.primary,
    this.icon,
    this.isLoading = false,
    this.height = 48,
    this.width,
    this.padding,
    this.textStyle,
  });

  final String text;
  final VoidCallback? onPressed;
  final AppButtonVariant variant;
  final Widget? icon;
  final bool isLoading;
  final double height;
  final double? width;
  final EdgeInsetsGeometry? padding;
  final TextStyle? textStyle;

  @override
  Widget build(BuildContext context) {
    final bool isDisabled = onPressed == null || isLoading;

    Color backgroundColor;
    Color foregroundColor;
    BorderSide? border;

    switch (variant) {
      case AppButtonVariant.primary:
        backgroundColor = isDisabled ? AppColors.border : AppColors.primary;
        foregroundColor = isDisabled ? AppColors.textLight : AppColors.primaryForeground;
        break;
      case AppButtonVariant.outline:
        backgroundColor = Colors.transparent;
        foregroundColor = isDisabled ? AppColors.textLight : AppColors.primary;
        border = BorderSide(
          color: isDisabled ? AppColors.border : AppColors.primaryOutline,
          width: 1.5,
        );
        break;
      case AppButtonVariant.soft:
        backgroundColor = isDisabled ? AppColors.surface : AppColors.primarySoft;
        foregroundColor = isDisabled ? AppColors.textLight : AppColors.primary;
        break;
      case AppButtonVariant.destructive:
        backgroundColor = isDisabled ? AppColors.border : AppColors.destructive;
        foregroundColor = isDisabled ? AppColors.textLight : Colors.white;
        break;
      case AppButtonVariant.ghost:
        backgroundColor = Colors.transparent;
        foregroundColor = isDisabled ? AppColors.textLight : AppColors.textPrimary;
        break;
    }

    final effectiveTextStyle = (textStyle ?? AppTypography.bodyMedium).copyWith(
      color: foregroundColor,
      fontWeight: FontWeight.w600,
    );

    return SizedBox(
      height: height,
      width: width,
      child: Material(
        color: backgroundColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: border ?? BorderSide.none,
        ),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: isDisabled ? null : onPressed,
          splashColor: variant == AppButtonVariant.primary
              ? AppColors.primaryPressed.withOpacity(0.3)
              : null,
          highlightColor: variant == AppButtonVariant.primary
              ? AppColors.primaryPressed.withOpacity(0.2)
              : null,
          child: Padding(
            padding: padding ?? const EdgeInsets.symmetric(horizontal: 16),
            child: Center(
              child: isLoading
                  ? SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.2,
                        valueColor: AlwaysStoppedAnimation<Color>(foregroundColor),
                      ),
                    )
                  : Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (icon != null) ...[
                          icon!,
                          const SizedBox(width: 8),
                        ],
                        Flexible(
                          child: Text(
                            text,
                            style: effectiveTextStyle,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
            ),
          ),
        ),
      ),
    );
  }
}
