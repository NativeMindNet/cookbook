import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'settings_event.dart';
import 'settings_state.dart';

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  static const _localeKey = 'settings_locale';
  static const _themeModeKey = 'settings_theme_mode';
  static const _fontSizeKey = 'settings_font_size';
  static const _autoplayKey = 'settings_autoplay_audio';

  SettingsBloc() : super(const SettingsState()) {
    on<SettingsLoadRequested>(_onLoadRequested);
    on<SettingsLanguageChanged>(_onLanguageChanged);
    on<SettingsThemeModeChanged>(_onThemeModeChanged);
    on<SettingsFontSizeChanged>(_onFontSizeChanged);
    on<SettingsAutoplayAudioChanged>(_onAutoplayChanged);
  }

  Future<void> _onLoadRequested(
    SettingsLoadRequested event,
    Emitter<SettingsState> emit,
  ) async {
    emit(state.copyWith(status: SettingsStatus.loading));

    try {
      final prefs = await SharedPreferences.getInstance();

      final localeCode = prefs.getString(_localeKey) ?? 'ru';
      final themeModeIndex = prefs.getInt(_themeModeKey) ?? ThemeMode.system.index;
      final fontSize = prefs.getDouble(_fontSizeKey) ?? SettingsState.defaultFontSize;
      final autoplay = prefs.getBool(_autoplayKey) ?? false;

      emit(state.copyWith(
        status: SettingsStatus.loaded,
        locale: Locale(localeCode),
        themeMode: ThemeMode.values[themeModeIndex],
        fontSize: fontSize,
        autoplayAudio: autoplay,
      ));
    } catch (e) {
      emit(state.copyWith(status: SettingsStatus.error));
    }
  }

  Future<void> _onLanguageChanged(
    SettingsLanguageChanged event,
    Emitter<SettingsState> emit,
  ) async {
    emit(state.copyWith(locale: event.locale));

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_localeKey, event.locale.languageCode);
  }

  Future<void> _onThemeModeChanged(
    SettingsThemeModeChanged event,
    Emitter<SettingsState> emit,
  ) async {
    emit(state.copyWith(themeMode: event.themeMode));

    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_themeModeKey, event.themeMode.index);
  }

  Future<void> _onFontSizeChanged(
    SettingsFontSizeChanged event,
    Emitter<SettingsState> emit,
  ) async {
    emit(state.copyWith(fontSize: event.fontSize));

    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(_fontSizeKey, event.fontSize);
  }

  Future<void> _onAutoplayChanged(
    SettingsAutoplayAudioChanged event,
    Emitter<SettingsState> emit,
  ) async {
    emit(state.copyWith(autoplayAudio: event.autoplay));

    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_autoplayKey, event.autoplay);
  }
}
