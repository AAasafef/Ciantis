import 'package:flutter/material.dart';

class CiantisTheme {
  CiantisTheme._();

  static ThemeData buildTheme() {
    const primary = Color(0xFF1F2228);
    const accent = Color(0xFFB89C6D);
    const background = Color(0xFFF5F3EF);

    final base = ThemeData.light();

    return base.copyWith(
      primaryColor: primary,
      scaffoldBackgroundColor: background,
      colorScheme: base.colorScheme.copyWith(
        primary: primary,
        secondary: accent,
        background: background,
      ),
      textTheme: _textTheme(base.textTheme),
      appBarTheme: const AppBarTheme(
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: primary,
        centerTitle: true,
      ),
      cardTheme: CardTheme(
        color: Colors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      visualDensity: VisualDensity.adaptivePlatformDensity,
    );
  }

  static TextTheme _textTheme(TextTheme base) {
    return base.copyWith(
      headlineMedium: base.headlineMedium?.copyWith(
        fontWeight: FontWeight.w600,
        letterSpacing: 0.2,
      ),
      titleMedium: base.titleMedium?.copyWith(
        fontWeight: FontWeight.w500,
      ),
      bodyMedium: base.bodyMedium?.copyWith(
        height: 1.4,
      ),
    );
  }
}
