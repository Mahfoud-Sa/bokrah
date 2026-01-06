import 'package:bokrah/app/features/settings/data/datasources/settings_local_datasource.dart';
import 'package:bokrah/app/features/settings/presentation/cubits/settings_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SettingsCubit extends Cubit<SettingsState> {
  final SettingsLocalDataSource localDataSource;

  SettingsCubit({required this.localDataSource})
    : super(SettingsState.initial()) {
    _loadSettings();
  }

  void _loadSettings() {
    final themeMode = localDataSource.getThemeMode();
    final languageCode = localDataSource.getLanguageCode();
    emit(SettingsState(themeMode: themeMode, locale: Locale(languageCode)));
  }

  Future<void> updateThemeMode(ThemeMode themeMode) async {
    await localDataSource.cacheThemeMode(themeMode);
    emit(state.copyWith(themeMode: themeMode));
  }

  Future<void> updateLanguageCode(String languageCode) async {
    await localDataSource.cacheLanguageCode(languageCode);
    emit(state.copyWith(locale: Locale(languageCode)));
  }

  void toggleLanguage() {
    final newLang = state.locale.languageCode == 'ar' ? 'en' : 'ar';
    updateLanguageCode(newLang);
  }
}
