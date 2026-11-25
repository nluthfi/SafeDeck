import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:material_ui/material_ui.dart';
import '../../core/l10n/locale_provider.dart';
import '../../core/security/auth_provider.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_shadows.dart';
import '../../core/theme/app_typography.dart';
import '../../core/utils/password_generator.dart';
import '../../core/widgets/app_button.dart';
import '../../core/widgets/app_switch.dart';
import '../../core/widgets/app_toast.dart';
import '../../core/widgets/strength_indicator.dart';

class GeneratorScreen extends ConsumerStatefulWidget {
  const GeneratorScreen({super.key});

  @override
  ConsumerState<GeneratorScreen> createState() => _GeneratorScreenState();
}

class _GeneratorScreenState extends ConsumerState<GeneratorScreen> {
  PasswordGeneratorOptions _options = const PasswordGeneratorOptions();
  String _generatedPassword = '';

  @override
  void initState() {
    super.initState();
    _regenerate();
  }

  void _regenerate() {
    setState(() {
      _generatedPassword = PasswordGenerator.generate(_options);
    });
  }

  void _copy() {
    final l10n = context.l10n;
    final clipSec = ref.read(authNotifierProvider).clipboardDuration;
    ref.read(securityServiceProvider).copyToClipboard(_generatedPassword, seconds: clipSec);

    AppToast.show(
      context,
      title: l10n.copiedSuccess(l10n.passwordLabel),
      subtitle: clipSec > 0
          ? l10n.clipboardAutoClearNotice(clipSec)
          : null,
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final eval = PasswordStrengthEvaluator.evaluate(_generatedPassword);
    final strengthLabel = localizeStrengthLabel(
      l10n,
      eval.strength,
      isEmpty: eval.score == 0,
    );

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          l10n.generatorTitle,
          style: AppTypography.h2.copyWith(fontWeight: FontWeight.w600),
        ),
        automaticallyImplyLeading: false,
        backgroundColor: AppColors.background,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        children: [
          // Display Card
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.card,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.border, width: 1.2),
              boxShadow: AppShadows.sm,
            ),
            child: Column(
              children: [
                SelectableText(
                  _generatedPassword,
                  style: AppTypography.h1.copyWith(
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.2,
                    color: AppColors.textPrimary,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    StrengthBadge(
                      strength: eval.strength,
                      customLabel: l10n.generatorBadge(strengthLabel, _options.length),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: AppButton(
                        text: l10n.generatorRegenerate,
                        variant: AppButtonVariant.outline,
                        icon: const Icon(LucideIcons.refreshCw,
                            size: 16, color: AppColors.primary),
                        onPressed: _regenerate,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: AppButton(
                        text: l10n.copyPassword,
                        variant: AppButtonVariant.primary,
                        icon: const Icon(LucideIcons.copy,
                            size: 16, color: Colors.white),
                        onPressed: _copy,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Options Container
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.card,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.border, width: 1.2),
              boxShadow: AppShadows.sm,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Length Slider Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      l10n.generatorLength,
                      style: AppTypography.bodyMedium.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      '${_options.length}',
                      style: AppTypography.h3.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
                Slider(
                  value: _options.length.toDouble(),
                  min: 8,
                  max: 64,
                  divisions: 56,
                  activeColor: AppColors.primary,
                  inactiveColor: AppColors.border,
                  onChanged: (val) {
                    setState(() {
                      _options = _options.copyWith(length: val.round());
                    });
                    _regenerate();
                  },
                ),
                const Divider(),

                // Huruf Besar
                _buildOptionRow(
                  label: l10n.generatorUpper,
                  value: _options.includeUpper,
                  onChanged: (val) {
                    setState(() {
                      _options = _options.copyWith(includeUpper: val);
                    });
                    _regenerate();
                  },
                ),
                const Divider(),

                // Huruf Kecil
                _buildOptionRow(
                  label: l10n.generatorLower,
                  value: _options.includeLower,
                  onChanged: (val) {
                    setState(() {
                      _options = _options.copyWith(includeLower: val);
                    });
                    _regenerate();
                  },
                ),
                const Divider(),

                // Angka
                _buildOptionRow(
                  label: l10n.generatorNumbers,
                  value: _options.includeNumbers,
                  onChanged: (val) {
                    setState(() {
                      _options = _options.copyWith(includeNumbers: val);
                    });
                    _regenerate();
                  },
                ),
                const Divider(),

                // Simbol Khusus
                _buildOptionRow(
                  label: l10n.generatorSymbols,
                  value: _options.includeSymbols,
                  onChanged: (val) {
                    setState(() {
                      _options = _options.copyWith(includeSymbols: val);
                    });
                    _regenerate();
                  },
                ),
                const Divider(),

                // Hindari Karakter Mirip
                _buildOptionRow(
                  label: l10n.generatorAvoidAmbiguous,
                  value: _options.avoidAmbiguous,
                  onChanged: (val) {
                    setState(() {
                      _options = _options.copyWith(avoidAmbiguous: val);
                    });
                    _regenerate();
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildOptionRow({
    required String label,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              label,
              style: AppTypography.body.copyWith(
                color: AppColors.textPrimary,
              ),
            ),
          ),
          AppSwitch(
            value: value,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}
