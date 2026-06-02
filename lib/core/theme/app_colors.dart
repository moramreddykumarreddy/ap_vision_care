// lib/core/theme/app_colors.dart
import 'package:flutter/material.dart';

class AppColors {
  // Primary brand colors - AP Government Deep Blue
  static const Color primaryBlue = Color(0xFF1A3A6B);
  static const Color primaryBlueDark = Color(0xFF0D2347);
  static const Color primaryBlueLight = Color(0xFF2952A3);

  // Accent - Teal
  static const Color accent = Color(0xFF00897B);
  static const Color accentLight = Color(0xFF4DB6AC);
  static const Color accentDark = Color(0xFF00695C);

  // AP Government Gold
  static const Color gold = Color(0xFFD4A017);
  static const Color goldLight = Color(0xFFFFD54F);

  // Status Colors
  static const Color success = Color(0xFF2E7D32);
  static const Color successLight = Color(0xFF4CAF50);
  static const Color warning = Color(0xFFE65100);
  static const Color warningLight = Color(0xFFFF9800);
  static const Color error = Color(0xFFC62828);
  static const Color errorLight = Color(0xFFF44336);
  static const Color info = Color(0xFF01579B);
  static const Color infoLight = Color(0xFF2196F3);

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

  // Chart Colors
  static const List<Color> chartColors = [
    Color(0xFF1A3A6B),
    Color(0xFF00897B),
    Color(0xFFD4A017),
    Color(0xFFE65100),
    Color(0xFF6A1B9A),
    Color(0xFF0277BD),
    Color(0xFF2E7D32),
    Color(0xFFC62828),
  ];
}
