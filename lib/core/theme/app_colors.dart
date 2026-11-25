import 'package:material_ui/material_ui.dart';

abstract class AppColors {
  // Primary brand palette
  static const Color primary = Color(0xFF0284C7);
  static const Color primaryPressed = Color(0xFF0369A1);
  static const Color primaryForeground = Color(0xFFFFFFFF);
  static const Color primarySoft = Color(0xFFE0F2FE);
  static const Color primaryOutline = Color(0xFFBAE6FD);
  static const Color primaryDecorative = Color(0xFF38BDF8);

  // Background & surfaces
  static const Color background = Color(0xFFFFFFFF);
  static const Color surface = Color(0xFFF0F9FF);
  static const Color card = Color(0xFFFFFFFF);
  static const Color border = Color(0xFFE2E8F0);

  // Typography colors
  static const Color textPrimary = Color(0xFF0F172A);
  static const Color textMuted = Color(0xFF475569);
  static const Color textLight = Color(0xFF94A3B8);

  // Semantic states
  static const Color success = Color(0xFF16A34A);
  static const Color successSoft = Color(0xFFDCFCE7);
  static const Color warning = Color(0xFFD97706);
  static const Color warningSoft = Color(0xFFFEF3C7);
  static const Color destructive = Color(0xFFDC2626);
  static const Color destructiveSoft = Color(0xFFFEE2E2);

  // Swatch options for services
  static const List<Color> serviceSwatches = [
    Color(0xFF0284C7), // Sky Blue (Default)
    Color(0xFF4F46E5), // Indigo
    Color(0xFF16A34A), // Emerald Green
    Color(0xFFD97706), // Amber
    Color(0xFFDC2626), // Crimson
    Color(0xFF9333EA), // Purple
  ];
}
