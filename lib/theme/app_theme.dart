import 'package:flutter/material.dart';

class AppColors {
  static const forest = Color(0xFF0F3B2E);
  static const forestDeep = Color(0xFF0B2A21);
  static const gold = Color(0xFFD4A017);
  static const sand = Color(0xFFF6F3EE);
  static const ink = Color(0xFF121815);
  static const mist = Color(0xFFE6EFEA);
  static const border = Color(0xFFE1E4E1);
  static const muted = Color(0xFF5A645E);
  static const hint = Color(0xFF6B6F6C);
  static const unselected = Color(0xFF8C948E);
  static const danger = Color(0xFFB42318);
  static const dangerSoft = Color(0xFFFEE4E2);
}

ThemeData buildAppTheme() {
  return ThemeData(
    useMaterial3: true,
    colorScheme: const ColorScheme.light(
      primary: AppColors.forest,
      onPrimary: Colors.white,
      secondary: AppColors.gold,
      onSecondary: AppColors.forestDeep,
      surface: Colors.white,
      onSurface: AppColors.ink,
      error: Color(0xFFB00020),
      onError: Colors.white,
      background: AppColors.sand,
      onBackground: AppColors.ink,
    ),
    scaffoldBackgroundColor: AppColors.sand,
    textTheme: const TextTheme(
      displaySmall: TextStyle(
        fontSize: 32,
        fontWeight: FontWeight.w700,
        height: 1.05,
        letterSpacing: -0.5,
      ),
      titleLarge: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
      titleMedium: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
      bodyLarge: TextStyle(fontSize: 15, height: 1.4),
      bodyMedium: TextStyle(fontSize: 14, height: 1.4),
      labelLarge: TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.4,
      ),
    ).apply(bodyColor: AppColors.ink, displayColor: AppColors.ink),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.white,
      hintStyle: const TextStyle(color: AppColors.hint),
      prefixIconColor: AppColors.forest,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: AppColors.border),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: AppColors.border),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: AppColors.forest, width: 1.2),
      ),
    ),
  );
}
