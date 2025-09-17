import 'package:flutter/material.dart';

class AppColors {
  // Primary Colors - Vibrant Blue
  static const Color primaryBlue = Color(0xFF2196F3);
  static const Color primaryBlueDark = Color(0xFF1976D2);
  static const Color primaryBlueLight = Color(0xFF64B5F6);

  // Secondary Colors - Vibrant Purple
  static const Color secondaryPurple = Color(0xFF9C27B0);
  static const Color secondaryPurpleDark = Color(0xFF7B1FA2);
  static const Color secondaryPurpleLight = Color(0xFFBA68C8);

  // Accent Colors - Vibrant Orange
  static const Color accentOrange = Color(0xFFFF9800);
  static const Color accentOrangeDark = Color(0xFFF57C00);
  static const Color accentOrangeLight = Color(0xFFFFB74D);

  // Success Colors - Vibrant Green
  static const Color successGreen = Color(0xFF4CAF50);
  static const Color successGreenDark = Color(0xFF388E3C);
  static const Color successGreenLight = Color(0xFF81C784);

  // Warning Colors - Vibrant Yellow
  static const Color warningYellow = Color(0xFFFFC107);
  static const Color warningYellowDark = Color(0xFFF9A825);
  static const Color warningYellowLight = Color(0xFFFFD54F);

  // Error Colors - Vibrant Red
  static const Color errorRed = Color(0xFFF44336);
  static const Color errorRedDark = Color(0xFFD32F2F);
  static const Color errorRedLight = Color(0xFFEF5350);

  // Info Colors - Vibrant Cyan
  static const Color infoCyan = Color(0xFF00BCD4);
  static const Color infoCyanDark = Color(0xFF0097A7);
  static const Color infoCyanLight = Color(0xFF4DD0E1);

  // Neutral Colors - Light Theme
  static const Color lightBackground = Color(0xFFFAFAFA);
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightSurfaceVariant = Color(0xFFF5F5F5);
  static const Color lightOnBackground = Color(0xFF1C1C1C);
  static const Color lightOnSurface = Color(0xFF1C1C1C);
  static const Color lightOnSurfaceVariant = Color(0xFF424242);
  static const Color lightOutline = Color(0xFFE0E0E0);
  static const Color lightOutlineVariant = Color(0xFFF0F0F0);

  // Neutral Colors - Dark Theme
  static const Color darkBackground = Color(0xFF121212);
  static const Color darkSurface = Color(0xFF1E1E1E);
  static const Color darkSurfaceVariant = Color(0xFF2C2C2C);
  static const Color darkOnBackground = Color(0xFFE0E0E0);
  static const Color darkOnSurface = Color(0xFFE0E0E0);
  static const Color darkOnSurfaceVariant = Color(0xFFB0B0B0);
  static const Color darkOutline = Color(0xFF3C3C3C);
  static const Color darkOutlineVariant = Color(0xFF2C2C2C);

  // Gradient Colors
  static const List<Color> primaryGradient = [primaryBlue, secondaryPurple];

  static const List<Color> successGradient = [successGreen, successGreenLight];

  static const List<Color> warningGradient = [warningYellow, accentOrange];

  static const List<Color> errorGradient = [errorRed, errorRedLight];

  // Special Colors
  static const Color shimmerBase = Color(0xFFE0E0E0);
  static const Color shimmerHighlight = Color(0xFFF5F5F5);
  static const Color shimmerBaseDark = Color(0xFF3C3C3C);
  static const Color shimmerHighlightDark = Color(0xFF4C4C4C);

  // Transparent Colors
  static const Color transparent = Colors.transparent;
  static const Color whiteTransparent = Color(0x80FFFFFF);
  static const Color blackTransparent = Color(0x80000000);

  // Shadow Colors
  static const Color shadowLight = Color(0x1A000000);
  static const Color shadowMedium = Color(0x33000000);
  static const Color shadowDark = Color(0x4D000000);

  // Overlay Colors
  static const Color overlayLight = Color(0x80000000);
  static const Color overlayDark = Color(0xCC000000);

  // Glass Effect Colors
  static const Color glassLight = Color(0x80FFFFFF);
  static const Color glassDark = Color(0x80000000);
}
