import 'package:flutter/material.dart';
import 'app_theme_dark.dart'; // Imports the Telegram dark theme

class AppTheme {
  AppTheme._();

  static const Color primaryColor = Color(0xFFC4AA29);

  // Pure White Light Mode Configuration
  static ThemeData get light {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: Colors.white, // Updated to pure white as requested
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryColor,
        brightness: Brightness.light,
        surface: Colors.white, // Sets standard container surfaces to match
      ),
      appBarTheme: const AppBarTheme(
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        surfaceTintColor: Colors.transparent,
      ),
      dividerColor: Colors.black12,
    );
  }

  // Links to the separate dark theme file
  static ThemeData get dark => TelegramDarkTheme.theme;
}