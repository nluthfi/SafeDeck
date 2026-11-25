import 'package:material_ui/material_ui.dart';
import '../l10n/locale_provider.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';

enum PasswordStrength {
  weak,
  fair,
  strong,
  veryStrong,
}

class PasswordStrengthResult {
  const PasswordStrengthResult({
    required this.strength,
    required this.score,
    required this.label,
    required this.detail,
  });

  final PasswordStrength strength;
  final int score; // 1 to 4
  final String label;
  final String detail;

  Color get color {
    switch (strength) {
      case PasswordStrength.weak:
        return AppColors.destructive;
      case PasswordStrength.fair:
        return AppColors.warning;
      case PasswordStrength.strong:
      case PasswordStrength.veryStrong:
        return AppColors.success;
    }
  }

  Color get softColor {
    switch (strength) {
      case PasswordStrength.weak:
        return AppColors.destructiveSoft;
      case PasswordStrength.fair:
        return AppColors.warningSoft;
      case PasswordStrength.strong:
      case PasswordStrength.veryStrong:
        return AppColors.successSoft;
    }
  }
}

class PasswordStrengthEvaluator {
  static PasswordStrengthResult evaluate(String password) {
    if (password.isEmpty) {
      return const PasswordStrengthResult(
        strength: PasswordStrength.weak,
        score: 0,
        label: 'Kosong',
        detail: 'Masukkan kata sandi',
      );
    }

    int score = 0;
    final length = password.length;
    final hasUpper = RegExp(r'[A-Z]').hasMatch(password);
    final hasLower = RegExp(r'[a-z]').hasMatch(password);
    final hasDigits = RegExp(r'[0-9]').hasMatch(password);
    final hasSpecial = RegExp(r'[!@#\$%^&*()_+\-=\[\]{};:,.<>?/~`|\\]').hasMatch(password);

    if (length >= 8) score++;
    if (length >= 12) score++;
    if (hasUpper && hasLower && hasDigits) score++;
    if (hasSpecial && length >= 10) score++;

    if (score <= 1 || length < 8) {
      return PasswordStrengthResult(
        strength: PasswordStrength.weak,
        score: 1,
        label: 'Lemah',
        detail: 'Kurang dari 8 karakter atau terlalu sederhana',
      );
    } else if (score == 2) {
      return PasswordStrengthResult(
        strength: PasswordStrength.fair,
        score: 2,
        label: 'Sedang',
        detail: 'Kombinasi huruf dan angka cukup, tambahkan simbol',
      );
    } else if (score == 3) {
      return PasswordStrengthResult(
        strength: PasswordStrength.strong,
        score: 3,
        label: 'Kuat',
        detail: '$length karakter unik dengan variasi karakter',
      );
    } else {
      return PasswordStrengthResult(
        strength: PasswordStrength.veryStrong,
        score: 4,
        label: 'Sangat Kuat',
        detail: '$length Karakter: Angka & Simbol',
      );
    }
  }
}

class StrengthBadge extends StatelessWidget {
  const StrengthBadge({
    super.key,
    required this.strength,
    this.customLabel,
  });

  final PasswordStrength strength;
  final String? customLabel;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    Color bg;
    Color fg;
    String label;

    switch (strength) {
      case PasswordStrength.weak:
        bg = AppColors.destructiveSoft;
        fg = AppColors.destructive;
        label = customLabel ?? l10n.strengthWeak;
        break;
      case PasswordStrength.fair:
        bg = AppColors.warningSoft;
        fg = AppColors.warning;
        label = customLabel ?? l10n.strengthFair;
        break;
      case PasswordStrength.strong:
        bg = AppColors.successSoft;
        fg = AppColors.success;
        label = customLabel ?? l10n.strengthStrong;
        break;
      case PasswordStrength.veryStrong:
        bg = AppColors.successSoft;
        fg = AppColors.success;
        label = customLabel ?? l10n.strengthVeryStrong;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        label,
        style: AppTypography.captionMedium.copyWith(
          color: fg,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class StrengthBar extends StatelessWidget {
  const StrengthBar({
    super.key,
    required this.score, // 1 to 4
    this.height = 4,
  });

  final int score;
  final double height;

  Color _colorForScore(int currentScore) {
    if (currentScore <= 1) return AppColors.destructive;
    if (currentScore == 2) return AppColors.warning;
    return AppColors.success;
  }

  @override
  Widget build(BuildContext context) {
    final activeColor = _colorForScore(score);

    return Row(
      children: List.generate(4, (index) {
        final isActive = index < score;
        return Expanded(
          child: Container(
            margin: EdgeInsets.only(right: index < 3 ? 6.0 : 0.0),
            height: height,
            decoration: BoxDecoration(
              color: isActive ? activeColor : AppColors.border,
              borderRadius: BorderRadius.circular(height / 2),
            ),
          ),
        );
      }),
    );
  }
}
