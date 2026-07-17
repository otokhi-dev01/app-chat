import 'package:flutter/material.dart';

class TelegramDarkTheme {
  TelegramDarkTheme._();

  // Telegram's classic brand blue accent color
  static const Color telegramBlue = Color(0xFF24A1DE);

  static ThemeData get theme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      // Telegram's dark mode color codes:
      // Scaffold background: deep blue-black (0xFF0E1621)
      scaffoldBackgroundColor: const Color(0xFF0E1621),
      colorScheme: ColorScheme.fromSeed(
        seedColor: telegramBlue,
        brightness: Brightness.dark,
        // Elevated surfaces: deep blue-gray (0xFF17212B)
        surface: const Color(0xFF17212B),
      ),
      appBarTheme: const AppBarTheme(
        elevation: 0,
        // Header background matching elevated surface (0xFF17212B)
        backgroundColor: Color(0xFF17212B),
        foregroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
      ),
      // Clean divider matching Telegram's styling
      dividerColor: const Color(0xFF101921),
    );
  }
}