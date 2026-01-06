import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsLocalDataSource {
  static const String _themeKey = 'theme_mode';
  static const String _languageKey = 'language_code';

  final SharedPreferences sharedPreferences;

  SettingsLocalDataSource({required this.sharedPreferences});

  Future<void> cacheThemeMode(ThemeMode themeMode) async {
    await sharedPreferences.setString(_themeKey, themeMode.name);
  }

  ThemeMode getThemeMode() {
    final themeName = sharedPreferences.getString(_themeKey);
    return ThemeMode.values.firstWhere(
      (e) => e.name == themeName,
      orElse: () => ThemeMode.system,
    );
  }

  Future<void> cacheLanguageCode(String languageCode) async {
    await sharedPreferences.setString(_languageKey, languageCode);
  }

  String getLanguageCode() {
    return sharedPreferences.getString(_languageKey) ?? 'ar';
  }
}
