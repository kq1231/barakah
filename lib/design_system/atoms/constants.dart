// Base level atoms that can't be broken down further
// Each atom should be a single, simple UI element

import 'package:flutter/material.dart';

class BarakahColors {
  static const primary = Color(0xFF4CAF50);
  static const secondary = Color(0xFF009688);
  static const background = Color(0xFFFFFFFF);
  static const surface = Color(0xFFF5F5F5);
  static const textPrimary = Color(0xFF212121);
  static const textSecondary = Color(0xFF757575);
  static const error = Color(0xFFD32F2F);
  static const success = Color(0xFF388E3C);
  static const warning = Color(0xFFF57C00);
  static const info = Color(0xFF1976D2);
}

class BarakahTypography {
  static const headline1 = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: BarakahColors.textPrimary,
  );

  static const headline2 = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
    color: BarakahColors.textPrimary,
  );

  static const headline3 = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
    color: BarakahColors.textPrimary,
  );

  static const subtitle1 = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: BarakahColors.textPrimary,
  );

  static const body1 = TextStyle(
    fontSize: 14,
    color: BarakahColors.textPrimary,
  );

  static const caption = TextStyle(
    fontSize: 12,
    color: BarakahColors.textSecondary,
  );
}

class BarakahSpacing {
  static const double xs = 4;
  static const double sm = 8;
  static const double md = 16;
  static const double lg = 24;
  static const double xl = 32;
}
