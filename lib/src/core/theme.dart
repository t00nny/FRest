// lib/src/core/theme.dart

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static final ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: const Color(0xFF121212),
    primaryColor: const Color(0xFF4A90E2), // A calm, motivating blue
    colorScheme: const ColorScheme.dark(
      primary: Color(0xFF4A90E2),
      secondary:
          Color(0xFF50E3C2), // A vibrant accent for success/positive actions
      background: Color(0xFF121212),
      surface: Color(0xFF1E1E1E), // For cards and dialogs
      onPrimary: Colors.white,
      onSecondary: Colors.black,
      onBackground: Colors.white,
      onSurface: Colors.white,
      error: Color(0xFFCF6679),
      onError: Colors.black,
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: const Color(0xFF1E1E1E),
      elevation: 0,
      titleTextStyle: GoogleFonts.lato(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
      iconTheme: const IconThemeData(color: Colors.white),
    ),
    // CORRECTED: Used CardThemeData instead of CardTheme
    cardTheme: CardThemeData(
      color: const Color(0xFF1E1E1E),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    ),
    textTheme: GoogleFonts.latoTextTheme(
      const TextTheme(
        displayLarge: TextStyle(fontSize: 57.0, fontWeight: FontWeight.bold),
        displayMedium: TextStyle(fontSize: 45.0, fontWeight: FontWeight.bold),
        displaySmall: TextStyle(fontSize: 36.0, fontWeight: FontWeight.bold),
        headlineLarge: TextStyle(fontSize: 32.0, fontWeight: FontWeight.bold),
        headlineMedium:
            TextStyle(fontSize: 28.0, fontWeight: FontWeight.normal),
        headlineSmall: TextStyle(fontSize: 24.0, fontWeight: FontWeight.normal),
        titleLarge: TextStyle(fontSize: 22.0, fontWeight: FontWeight.bold),
        titleMedium: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w500),
        titleSmall: TextStyle(fontSize: 14.0, fontWeight: FontWeight.w500),
        bodyLarge: TextStyle(fontSize: 16.0, fontWeight: FontWeight.normal),
        bodyMedium: TextStyle(fontSize: 14.0, fontWeight: FontWeight.normal),
        bodySmall: TextStyle(fontSize: 12.0, fontWeight: FontWeight.normal),
        labelLarge: TextStyle(fontSize: 14.0, fontWeight: FontWeight.bold),
        labelMedium: TextStyle(fontSize: 12.0, fontWeight: FontWeight.bold),
        labelSmall: TextStyle(fontSize: 11.0, fontWeight: FontWeight.bold),
      ).apply(
        bodyColor: Colors.white,
        displayColor: Colors.white,
      ),
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: Color(0xFF1E1E1E),
      selectedItemColor: Color(0xFF4A90E2),
      unselectedItemColor: Colors.grey,
      type: BottomNavigationBarType.fixed,
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: Color(0xFF4A90E2),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF4A90E2),
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
      foregroundColor: const Color(0xFF4A90E2),
    )),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: const Color(0xFF2C2C2C),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide.none,
      ),
      hintStyle: TextStyle(color: Colors.grey[600]),
    ),
  );
}
