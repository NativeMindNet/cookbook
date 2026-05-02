import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

abstract class SettingsEvent extends Equatable {
  const SettingsEvent();

  @override
  List<Object?> get props => [];
}

class SettingsLoadRequested extends SettingsEvent {
  const SettingsLoadRequested();
}

class SettingsLanguageChanged extends SettingsEvent {
  final Locale locale;

  const SettingsLanguageChanged(this.locale);

  @override
  List<Object?> get props => [locale];
}

class SettingsThemeModeChanged extends SettingsEvent {
  final ThemeMode themeMode;

  const SettingsThemeModeChanged(this.themeMode);

  @override
  List<Object?> get props => [themeMode];
}

class SettingsFontSizeChanged extends SettingsEvent {
  final double fontSize;

  const SettingsFontSizeChanged(this.fontSize);

  @override
  List<Object?> get props => [fontSize];
}

class SettingsAutoplayAudioChanged extends SettingsEvent {
  final bool autoplay;

  const SettingsAutoplayAudioChanged(this.autoplay);

  @override
  List<Object?> get props => [autoplay];
}
