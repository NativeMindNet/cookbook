import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

enum SettingsStatus { initial, loading, loaded, error }

class SettingsState extends Equatable {
  final SettingsStatus status;
  final Locale locale;
  final ThemeMode themeMode;
  final double fontSize;
  final bool autoplayAudio;

  static const defaultLocale = Locale('ru');
  static const defaultFontSize = 16.0;

  const SettingsState({
    this.status = SettingsStatus.initial,
    this.locale = defaultLocale,
    this.themeMode = ThemeMode.system,
    this.fontSize = defaultFontSize,
    this.autoplayAudio = false,
  });

  static const supportedLocales = [
    Locale('ru'),
    Locale('zh'),
    Locale('th'),
    Locale('hi'),
    Locale('ja'),
  ];

  String get languageCode => locale.languageCode;

  String get languageName {
    switch (locale.languageCode) {
      case 'ru':
        return 'Русский';
      case 'zh':
        return '中文';
      case 'th':
        return 'ไทย';
      case 'hi':
        return 'हिंदी';
      case 'ja':
        return '日本語';
      default:
        return locale.languageCode;
    }
  }

  SettingsState copyWith({
    SettingsStatus? status,
    Locale? locale,
    ThemeMode? themeMode,
    double? fontSize,
    bool? autoplayAudio,
  }) {
    return SettingsState(
      status: status ?? this.status,
      locale: locale ?? this.locale,
      themeMode: themeMode ?? this.themeMode,
      fontSize: fontSize ?? this.fontSize,
      autoplayAudio: autoplayAudio ?? this.autoplayAudio,
    );
  }

  @override
  List<Object?> get props => [
        status,
        locale,
        themeMode,
        fontSize,
        autoplayAudio,
      ];
}
