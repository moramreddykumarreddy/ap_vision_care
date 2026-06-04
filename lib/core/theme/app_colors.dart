// lib/core/theme/app_colors.dart
import 'package:flutter/material.dart';

/// Official AP Vision Care brand palette.
/// Blue #004990 · Red #e31b23 · Gray #6d6e71
class AppColors {
  AppColors._();

  static const Color brandBlue = Color(0xFF004990);
  static const Color brandRed = Color(0xFFE31B23);
  static const Color brandGray = Color(0xFF6D6E71);

  // Primary (brand blue)
  static const Color primaryBlue = brandBlue;
  static const Color primaryBlueDark = brandBlue;
  static const Color primaryBlueLight = brandBlue;

  // Accent / CTA (brand red — matches web Button primary)
  static const Color accent = brandRed;
  static const Color accentLight = brandRed;
  static const Color accentDark = brandRed;

  static const Color gold = brandRed;
  static const Color goldLight = brandRed;

  // Semantic — aligned with web theme
  static const Color success = brandBlue;
  static const Color successLight = brandBlue;
  static const Color warning = brandRed;
  static const Color warningLight = brandRed;
  static const Color error = brandRed;
  static const Color errorLight = brandRed;
  static const Color info = brandBlue;
  static const Color infoLight = brandBlue;
  static const Color clinical = brandBlue;

  // Surfaces (color-mix equivalents with white)
  static const Color primaryContainer = Color(0xFFE0E9F2); // 12% blue + white
  static const Color accentSoft = Color(0xFFFCE8E9); // 10% red + white
  static const Color bgApp = Color(0xFFF6F6F6); // 6% gray + white
  static const Color surfaceClinical = Color(0xFFF4F4F4); // 8% gray + white
  static const Color surfaceMuted = Color(0xFFF0F0F0); // 10% gray + white

  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF000000);

  static const Color grey50 = Color(0xFFF6F6F6);
  static const Color grey100 = Color(0xFFF0F0F0);
  static const Color grey200 = Color(0xFFE5E5E5);
  static const Color grey300 = Color(0xFFD6D6D6);
  static const Color grey400 = brandGray;
  static const Color grey500 = brandGray;
  static const Color grey600 = brandGray;
  static const Color grey700 = brandGray;
  static const Color grey800 = brandGray;
  static const Color grey900 = brandGray;

  /// Login / splash / hero banners
  static const List<Color> heroGradient = [brandBlue, brandBlue];

  // Dark theme — derived from brand blue + gray
  static const Color darkBackground = Color(0xFF001A33);
  static const Color darkSurface = Color(0xFF002952);
  static const Color darkCard = Color(0xFF003366);
  static const Color darkBorder = Color(0xFF4A4B4E);

  // Role colors — unified brand blue
  static const Color superAdminColor = brandBlue;
  static const Color nodalOfficerColor = brandBlue;
  static const Color screeningTeamColor = brandBlue;
  static const Color teleDocColor = brandBlue;
  static const Color vendorColor = brandBlue;
  static const Color patientColor = brandBlue;

  /// Charts & category icons — rotate blue, red, gray only
  static const List<Color> chartColors = [
    brandBlue,
    brandRed,
    brandGray,
    brandBlue,
    brandRed,
    brandGray,
  ];

  static Color chartColorAt(int index) => chartColors[index % chartColors.length];
}
