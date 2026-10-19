import 'package:flutter/material.dart';

// Tema Material 3 bernuansa indigo (sesuai contoh UI worksheet & modern design).
final ThemeData appTheme = ThemeData(
  useMaterial3: true,
  colorScheme: ColorScheme.fromSeed(
    seedColor: const Color(0xFF4F46E5),
    primary: const Color(0xFF4F46E5),
    surface: const Color(0xFFF8FAFC),
  ),
  scaffoldBackgroundColor: const Color(0xFFF8FAFC),
  appBarTheme: const AppBarTheme(
    elevation: 0,
    scrolledUnderElevation: 1,
    backgroundColor: Colors.white,
    centerTitle: false,
    titleTextStyle: TextStyle(
      color: Color(0xFF1E293B),
      fontSize: 18,
      fontWeight: FontWeight.bold,
    ),
    iconTheme: IconThemeData(color: Color(0xFF334155)),
  ),
  cardTheme: CardThemeData(
    elevation: 0,
    color: Colors.white,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(16),
      side: const BorderSide(color: Color(0xFFE2E8F0)),
    ),
  ),
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: Colors.white,
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: const BorderSide(color: Color(0xFFCBD5E1)),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: const BorderSide(color: Color(0xFF4F46E5), width: 2),
    ),
  ),
);
