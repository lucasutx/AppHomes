import 'package:flutter/material.dart';

abstract final class AppColors {
  static const red = Color(0xFFC6281C);
  static const darkRed = Color(0xFF8E1710);
  static const green = Color(0xFF176A3B);
  static const cream = Color(0xFFFFF8EC);
  static const ink = Color(0xFF241A17);
  static const muted = Color(0xFF746864);
  static const line = Color(0xFFE9DED3);
}

ThemeData buildAppTheme() {
  final scheme = ColorScheme.fromSeed(
    seedColor: AppColors.red,
    brightness: Brightness.light,
    primary: AppColors.red,
    secondary: AppColors.green,
    surface: Colors.white,
  );
  return ThemeData(
    useMaterial3: true,
    colorScheme: scheme,
    scaffoldBackgroundColor: AppColors.cream,
    fontFamily: 'Roboto',
    textTheme: const TextTheme(
      displaySmall: TextStyle(
          color: AppColors.ink,
          fontSize: 38,
          height: 1.05,
          fontWeight: FontWeight.w900,
          letterSpacing: -1.2),
      headlineMedium: TextStyle(
          color: AppColors.ink,
          fontSize: 28,
          height: 1.1,
          fontWeight: FontWeight.w800,
          letterSpacing: -.5),
      titleLarge: TextStyle(
          color: AppColors.ink, fontSize: 20, fontWeight: FontWeight.w800),
      bodyLarge: TextStyle(color: AppColors.ink, fontSize: 16, height: 1.5),
      bodyMedium: TextStyle(color: AppColors.muted, fontSize: 14, height: 1.45),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: AppColors.line)),
      enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: AppColors.line)),
      focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: AppColors.red, width: 2)),
      contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 17),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: AppColors.red,
        foregroundColor: Colors.white,
        minimumSize: const Size(0, 54),
        padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
      ),
    ),
    cardTheme: CardThemeData(
      color: Colors.white,
      elevation: 0,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
          side: const BorderSide(color: AppColors.line)),
    ),
  );
}
