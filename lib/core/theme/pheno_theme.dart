import 'package:flutter/material.dart';

abstract final class PhenoColors {
  static const burgundy = Color(0xFF7A263A);
  static const cream = Color(0xFFF3F1EF);
  static const ivory = Color(0xFFF8F6F3);
  static const charcoal = Color(0xFF29282A);
  static const warmGray = Color(0xFF8B8784);
  static const sage = Color(0xFF6F806C);
  static const sageSoft = Color(0xFFE7ECE5);
  static const warning = Color(0xFFC78A32);
  static const danger = Color(0xFFB44A4A);
}

abstract final class PhenoTheme {
  static ThemeData light() {
    final scheme = ColorScheme.fromSeed(
      seedColor: PhenoColors.burgundy,
      brightness: Brightness.light,
      surface: PhenoColors.ivory,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme.copyWith(
        primary: PhenoColors.burgundy,
        onPrimary: Colors.white,
        surface: PhenoColors.ivory,
        onSurface: PhenoColors.charcoal,
      ),
      scaffoldBackgroundColor: PhenoColors.cream,
      fontFamily: 'sans-serif',
      appBarTheme: const AppBarTheme(
        backgroundColor: PhenoColors.cream,
        foregroundColor: PhenoColors.charcoal,
        elevation: 0,
        centerTitle: false,
      ),
      cardTheme: CardThemeData(
        color: PhenoColors.ivory,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: PhenoColors.ivory,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
