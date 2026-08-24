import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppSettings {
  final Locale locale;
  const AppSettings({required this.locale});
}

class SettingsNotifier extends StateNotifier<AppSettings> {
  final SharedPreferences _prefs;

  SettingsNotifier(this._prefs)
      : super(AppSettings(
          locale: Locale(_prefs.getString('locale') ?? 'hu'),
        ));

  Future<void> setLocale(String languageCode) async {
    await _prefs.setString('locale', languageCode);
    state = AppSettings(locale: Locale(languageCode));
  }
}

// Provided via ProviderScope override in main.dart
final settingsProvider =
    StateNotifierProvider<SettingsNotifier, AppSettings>((ref) {
  throw UnimplementedError('Override settingsProvider in ProviderScope');
});
