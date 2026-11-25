import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:material_ui/material_ui.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';

enum AppTextFieldVariant {
  standard,
  password,
  search,
}

class AppTextField extends StatefulWidget {
  const AppTextField({
    super.key,
    this.label,
    this.hintText,
    this.controller,
    this.variant = AppTextFieldVariant.standard,
    this.obscureText,
    this.keyboardType,
    this.textInputAction,
    this.onChanged,
    this.onSubmitted,
    this.validator,
    this.errorText,
    this.prefixIcon,
    this.suffixIcon,
    this.readOnly = false,
    this.maxLines = 1,
    this.autofocus = false,
    this.focusNode,
  });

  final String? label;
  final String? hintText;
  final TextEditingController? controller;
  final AppTextFieldVariant variant;
  final bool? obscureText;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final FormFieldValidator<String>? validator;
  final String? errorText;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final bool readOnly;
  final int maxLines;
  final bool autofocus;
  final FocusNode? focusNode;

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  late bool _obscured;
  late TextEditingController _controller;
  bool _showClear = false;

  @override
  void initState() {
    super.initState();
    _obscured = widget.variant == AppTextFieldVariant.password;
    _controller = widget.controller ?? TextEditingController();
    _showClear = _controller.text.isNotEmpty;
    _controller.addListener(_handleControllerChange);
  }

  void _handleControllerChange() {
    final hasText = _controller.text.isNotEmpty;
    if (_showClear != hasText) {
      setState(() {
        _showClear = hasText;
      });
    }
  }

  @override
  void dispose() {
    if (widget.controller == null) {
      _controller.dispose();
    } else {
      _controller.removeListener(_handleControllerChange);
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget? effectivePrefix = widget.prefixIcon;
    Widget? effectiveSuffix = widget.suffixIcon;

    if (widget.variant == AppTextFieldVariant.search) {
      effectivePrefix ??= const Padding(
        padding: EdgeInsets.only(left: 14, right: 10),
        child: Icon(
          LucideIcons.search,
          size: 18,
          color: AppColors.textLight,
        ),
      );
      if (_showClear) {
        effectiveSuffix = IconButton(
          icon: const Icon(LucideIcons.xCircle, size: 18, color: AppColors.textLight),
          onPressed: () {
            _controller.clear();
            widget.onChanged?.call('');
          },
        );
      }
    } else if (widget.variant == AppTextFieldVariant.password) {
      effectiveSuffix = IconButton(
        icon: Icon(
          _obscured ? LucideIcons.eyeOff : LucideIcons.eye,
          size: 20,
          color: AppColors.textMuted,
        ),
        onPressed: () {
          setState(() {
            _obscured = !_obscured;
          });
        },
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (widget.label != null) ...[
          Text(
            widget.label!,
            style: AppTypography.smallMedium.copyWith(
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 6),
        ],
        TextFormField(
          controller: _controller,
          focusNode: widget.focusNode,
          autofocus: widget.autofocus,
          readOnly: widget.readOnly,
          obscureText: widget.variant == AppTextFieldVariant.password ? _obscured : (widget.obscureText ?? false),
          keyboardType: widget.keyboardType,
          textInputAction: widget.textInputAction,
          onChanged: widget.onChanged,
          onFieldSubmitted: widget.onSubmitted,
          validator: widget.validator,
          maxLines: widget.variant == AppTextFieldVariant.password ? 1 : widget.maxLines,
          style: AppTypography.body.copyWith(color: AppColors.textPrimary),
          decoration: InputDecoration(
            hintText: widget.hintText,
            hintStyle: AppTypography.body.copyWith(color: AppColors.textLight),
            errorText: widget.errorText,
            errorMaxLines: 2,
            contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            filled: true,
            fillColor: AppColors.background,
            prefixIcon: effectivePrefix,
            prefixIconConstraints: const BoxConstraints(minWidth: 40, minHeight: 44),
            suffixIcon: effectiveSuffix,
            suffixIconConstraints: const BoxConstraints(minWidth: 44, minHeight: 44),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: AppColors.border, width: 1.2),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: AppColors.destructive, width: 1.2),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: AppColors.destructive, width: 1.5),
            ),
          ),
        ),
      ],
    );
  }
}
