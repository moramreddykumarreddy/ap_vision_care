// lib/core/theme/app_colors.dart
import 'package:flutter/material.dart';

class AppColors {
  // Primary brand colors - AP Government Deep Blue
  static const Color primaryBlue = Color(0xFF004990);
  static const Color primaryBlueDark = Color(0xFF003366);
  static const Color primaryBlueLight = Color(0xFF336B9F);

  // Accent - Red
  static const Color accent = Color(0xFFE31B23);
  static const Color accentLight = Color(0xFFE84A50);
  static const Color accentDark = Color(0xFFB5151C);

  // AP Government Gold (Mapped to Brand Colors per theme request)
  static const Color gold = primaryBlue;
  static const Color goldLight = primaryBlueLight;

  // Status Colors
  static const Color success = Color(0xFF2E7D32);
  static const Color successLight = Color(0xFF4CAF50);
  static const Color warning = Color(0xFFE65100);
  static const Color warningLight = Color(0xFFFF9800);
  static const Color error = Color(0xFFC62828);
  static const Color errorLight = Color(0xFFF44336);
  static const Color info = primaryBlue;
  static const Color infoLight = primaryBlueLight;
  static const Color clinical = primaryBlueDark;

  // Web Theme specific surfaces
  static const Color primaryContainer = Color(0xFFE8F4FC);
  static const Color accentSoft = Color(0xFFFFCDD2);
  static const Color bgApp = Color(0xFFF0F7FA);
  static const Color surfaceClinical = Color(0xFFF5F7FA);
  static const Color surfaceMuted = Color(0xFFECEFF1);

  // Neutral
  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF000000);
  static const Color grey50 = Color(0xFFFAFAFA);
  static const Color grey100 = Color(0xFFF5F5F5);
  static const Color grey200 = Color(0xFFEEEEEE);
  static const Color grey300 = Color(0xFFE0E0E0);
  static const Color grey400 = Color(0xFFBDBDBD);
  static const Color grey500 = Color(0xFF9E9E9E);
  static const Color grey600 = Color(0xFF757575);
  static const Color grey700 = Color(0xFF616161);
  static const Color grey800 = Color(0xFF424242);
  static const Color grey900 = Color(0xFF212121);

  // Dark theme surfaces
  static const Color darkBackground = Color(0xFF0D1117);
  static const Color darkSurface = Color(0xFF161B22);
  static const Color darkCard = Color(0xFF1C2333);
  static const Color darkBorder = Color(0xFF30363D);

  // Role-based colors - unified to the primary brand deep blue
  static const Color superAdminColor = primaryBlue;
  static const Color nodalOfficerColor = primaryBlue;
  static const Color screeningTeamColor = primaryBlue;
  static const Color teleDocColor = primaryBlue;
  static const Color vendorColor = primaryBlue;
  static const Color patientColor = primaryBlue;

  // Chart Colors (aligned with blue/red theme)
  static const List<Color> chartColors = [
    primaryBlue, // primary
    accent, // accent (red)
    clinical, // clinical
    primaryBlueLight, // primary-light
    accentDark, // accent-dark (red)
    info, // info
  ];
}
