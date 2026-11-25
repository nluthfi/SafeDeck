import 'package:google_fonts/google_fonts.dart';
import 'package:material_ui/material_ui.dart';
import 'app_colors.dart';
import 'app_typography.dart';

@immutable
class BrankasThemeExtension extends ThemeExtension<BrankasThemeExtension> {
  const BrankasThemeExtension({
    required this.primary,
    required this.primaryPressed,
    required this.primaryForeground,
    required this.primarySoft,
    required this.primaryOutline,
    required this.primaryDecorative,
    required this.background,
    required this.surface,
    required this.card,
    required this.border,
    required this.textPrimary,
    required this.textMuted,
    required this.textLight,
    required this.success,
    required this.successSoft,
    required this.warning,
    required this.warningSoft,
    required this.destructive,
    required this.destructiveSoft,
  });

  final Color primary;
  final Color primaryPressed;
  final Color primaryForeground;
  final Color primarySoft;
  final Color primaryOutline;
  final Color primaryDecorative;
  final Color background;
  final Color surface;
  final Color card;
  final Color border;
  final Color textPrimary;
  final Color textMuted;
  final Color textLight;
  final Color success;
  final Color successSoft;
  final Color warning;
  final Color warningSoft;
  final Color destructive;
  final Color destructiveSoft;

  static const BrankasThemeExtension standard = BrankasThemeExtension(
    primary: AppColors.primary,
    primaryPressed: AppColors.primaryPressed,
    primaryForeground: AppColors.primaryForeground,
    primarySoft: AppColors.primarySoft,
    primaryOutline: AppColors.primaryOutline,
    primaryDecorative: AppColors.primaryDecorative,
    background: AppColors.background,
    surface: AppColors.surface,
    card: AppColors.card,
    border: AppColors.border,
    textPrimary: AppColors.textPrimary,
    textMuted: AppColors.textMuted,
    textLight: AppColors.textLight,
    success: AppColors.success,
    successSoft: AppColors.successSoft,
    warning: AppColors.warning,
    warningSoft: AppColors.warningSoft,
    destructive: AppColors.destructive,
    destructiveSoft: AppColors.destructiveSoft,
  );

  @override
  BrankasThemeExtension copyWith({
    Color? primary,
    Color? primaryPressed,
    Color? primaryForeground,
    Color? primarySoft,
    Color? primaryOutline,
    Color? primaryDecorative,
    Color? background,
    Color? surface,
    Color? card,
    Color? border,
    Color? textPrimary,
    Color? textMuted,
    Color? textLight,
    Color? success,
    Color? successSoft,
    Color? warning,
    Color? warningSoft,
    Color? destructive,
    Color? destructiveSoft,
  }) {
    return BrankasThemeExtension(
      primary: primary ?? this.primary,
      primaryPressed: primaryPressed ?? this.primaryPressed,
      primaryForeground: primaryForeground ?? this.primaryForeground,
      primarySoft: primarySoft ?? this.primarySoft,
      primaryOutline: primaryOutline ?? this.primaryOutline,
      primaryDecorative: primaryDecorative ?? this.primaryDecorative,
      background: background ?? this.background,
      surface: surface ?? this.surface,
      card: card ?? this.card,
      border: border ?? this.border,
      textPrimary: textPrimary ?? this.textPrimary,
      textMuted: textMuted ?? this.textMuted,
      textLight: textLight ?? this.textLight,
      success: success ?? this.success,
      successSoft: successSoft ?? this.successSoft,
      warning: warning ?? this.warning,
      warningSoft: warningSoft ?? this.warningSoft,
      destructive: destructive ?? this.destructive,
      destructiveSoft: destructiveSoft ?? this.destructiveSoft,
    );
  }

  @override
  BrankasThemeExtension lerp(
    covariant ThemeExtension<BrankasThemeExtension>? other,
    double t,
  ) {
    if (other is! BrankasThemeExtension) return this;
    return BrankasThemeExtension(
      primary: Color.lerp(primary, other.primary, t)!,
      primaryPressed: Color.lerp(primaryPressed, other.primaryPressed, t)!,
      primaryForeground:
          Color.lerp(primaryForeground, other.primaryForeground, t)!,
      primarySoft: Color.lerp(primarySoft, other.primarySoft, t)!,
      primaryOutline: Color.lerp(primaryOutline, other.primaryOutline, t)!,
      primaryDecorative:
          Color.lerp(primaryDecorative, other.primaryDecorative, t)!,
      background: Color.lerp(background, other.background, t)!,
      surface: Color.lerp(surface, other.surface, t)!,
      card: Color.lerp(card, other.card, t)!,
      border: Color.lerp(border, other.border, t)!,
      textPrimary: Color.lerp(textPrimary, other.textPrimary, t)!,
      textMuted: Color.lerp(textMuted, other.textMuted, t)!,
      textLight: Color.lerp(textLight, other.textLight, t)!,
      success: Color.lerp(success, other.success, t)!,
      successSoft: Color.lerp(successSoft, other.successSoft, t)!,
      warning: Color.lerp(warning, other.warning, t)!,
      warningSoft: Color.lerp(warningSoft, other.warningSoft, t)!,
      destructive: Color.lerp(destructive, other.destructive, t)!,
      destructiveSoft: Color.lerp(destructiveSoft, other.destructiveSoft, t)!,
    );
  }
}

extension BuildContextTheme on BuildContext {
  BrankasThemeExtension get tokens =>
      Theme.of(this).extension<BrankasThemeExtension>() ??
      BrankasThemeExtension.standard;
}

abstract class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: AppColors.background,
      colorScheme: const ColorScheme(
        brightness: Brightness.light,
        primary: AppColors.primary,
        onPrimary: AppColors.primaryForeground,
        secondary: AppColors.primaryDecorative,
        onSecondary: AppColors.primaryForeground,
        error: AppColors.destructive,
        onError: Colors.white,
        surface: AppColors.card,
        onSurface: AppColors.textPrimary,
      ),
      textTheme: GoogleFonts.interTextTheme().copyWith(
        titleLarge: AppTypography.title,
        headlineMedium: AppTypography.h1,
        headlineSmall: AppTypography.h2,
        titleMedium: AppTypography.h3,
        bodyLarge: AppTypography.body,
        bodyMedium: AppTypography.bodyMedium,
        bodySmall: AppTypography.small,
        labelMedium: AppTypography.smallMedium,
        labelSmall: AppTypography.captionMedium,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.background,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        iconTheme: IconThemeData(color: AppColors.textPrimary),
      ),
      dividerTheme: const DividerThemeData(
        color: AppColors.border,
        thickness: 1,
        space: 1,
      ),
      extensions: const [
        BrankasThemeExtension.standard,
      ],
    );
  }
}
