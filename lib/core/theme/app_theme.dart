import 'package:flutter/material.dart';

class AppTheme {
  AppTheme._(); // prevents instantiation

  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    colorScheme: ColorScheme.fromSeed(
      seedColor: Colors.indigo,
      primary: Colors.indigo,
      secondary: Colors.indigoAccent,
      surface: const Color(0xFFF8F9FE),
      onTertiary: Colors.black,
    ),
    scaffoldBackgroundColor: const Color(0xFFF8F9FE),
    cardTheme: CardTheme(
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        color: Colors.indigoAccent.withValues(alpha: 0.1)),
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: TextStyle(
        color: Colors.black,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    ),
    textTheme: const TextTheme(
      displayLarge: TextStyle(fontWeight: FontWeight.bold, fontSize: 32),
      titleLarge: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
      titleMedium: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
      bodyLarge: TextStyle(fontSize: 16, height: 1.5),
      bodyMedium: TextStyle(fontSize: 14, height: 1.4),
    ),
  );

  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    colorScheme: ColorScheme.fromSeed(
      seedColor: Colors.indigo,
      primary: Colors.indigo,
      secondary: const Color(0xFFF8F9FE),
      brightness: Brightness.dark,
      surface: const Color(0xFF121212),
      onTertiary: Colors.white,
    ),
    scaffoldBackgroundColor: const Color(0xFF121212),
    cardTheme: CardTheme(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      color: const Color(0xFF1E1E1E),
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: TextStyle(
        color: Colors.white,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    ),
    textTheme: const TextTheme(
      displayLarge: TextStyle(
          fontWeight: FontWeight.bold, fontSize: 32, color: Colors.white),
      titleLarge: TextStyle(
          fontWeight: FontWeight.bold, fontSize: 22, color: Colors.white),
      titleMedium: TextStyle(
          fontWeight: FontWeight.w600, fontSize: 16, color: Colors.white70),
      bodyLarge: TextStyle(fontSize: 16, height: 1.5, color: Colors.white),
      bodyMedium: TextStyle(fontSize: 14, height: 1.4, color: Colors.white70),
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      selectedItemColor: Colors.indigo,
      unselectedItemColor: Colors.grey,
      backgroundColor: Color(0xFF1E1E1E),
      elevation: 8,
    ),
  );
}
