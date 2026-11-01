import 'package:flutter/material.dart';

const paper = Color(0xFFF6F6EE);
const forest = Color(0xFF214B38);
const lime = Color(0xFFD3EE98);

ThemeData portfolioTheme(Brightness brightness) {
  final dark = brightness == Brightness.dark;
  final scheme = ColorScheme.fromSeed(seedColor: forest, brightness: brightness)
      .copyWith(
        primary: dark ? lime : forest,
        onPrimary: dark ? forest : Colors.white,
        surface: dark ? const Color(0xFF1D3027) : const Color(0xFFFFFEF8),
        onSurface: dark ? const Color(0xFFEDF0E3) : const Color(0xFF243D31),
        secondaryContainer: dark ? const Color(0xFF35493C) : lime,
        onSecondaryContainer: dark ? lime : forest,
      );
  return ThemeData(
    useMaterial3: true,
    colorScheme: scheme,
    brightness: brightness,
    fontFamily: 'DM Sans',
    scaffoldBackgroundColor: dark ? const Color(0xFF15251F) : paper,
    appBarTheme: const AppBarTheme(
      centerTitle: false,
      elevation: 0,
      scrolledUnderElevation: 0,
    ),
    textTheme: TextTheme(
      displaySmall: const TextStyle(
        fontFamily: 'Manrope',
        fontSize: 40,
        height: 1.12,
        fontWeight: FontWeight.w800,
        letterSpacing: -1.8,
      ),
      headlineMedium: const TextStyle(
        fontFamily: 'Manrope',
        fontSize: 29,
        height: 1.2,
        fontWeight: FontWeight.w800,
        letterSpacing: -1,
      ),
      titleLarge: const TextStyle(
        fontFamily: 'Manrope',
        fontSize: 21,
        fontWeight: FontWeight.w800,
      ),
      bodyLarge: const TextStyle(fontSize: 16, height: 1.65),
      bodyMedium: TextStyle(
        fontSize: 14,
        height: 1.55,
        color: dark ? const Color(0xFFADBBAA) : const Color(0xFF6C746A),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: scheme.surface,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: BorderSide.none,
      ),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
    ),
  );
}
