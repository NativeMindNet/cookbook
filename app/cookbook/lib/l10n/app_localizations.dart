import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_hi.dart';
import 'app_localizations_ja.dart';
import 'app_localizations_ru.dart';
import 'app_localizations_th.dart';
import 'app_localizations_zh.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('hi'),
    Locale('ja'),
    Locale('ru'),
    Locale('th'),
    Locale('zh'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In ru, this message translates to:
  /// **'Вегетарианская кулинарная книга'**
  String get appTitle;

  /// No description provided for @search.
  ///
  /// In ru, this message translates to:
  /// **'Поиск'**
  String get search;

  /// No description provided for @bookmarks.
  ///
  /// In ru, this message translates to:
  /// **'Закладки'**
  String get bookmarks;

  /// No description provided for @settings.
  ///
  /// In ru, this message translates to:
  /// **'Настройки'**
  String get settings;

  /// No description provided for @language.
  ///
  /// In ru, this message translates to:
  /// **'Язык'**
  String get language;

  /// No description provided for @searchPlaceholder.
  ///
  /// In ru, this message translates to:
  /// **'Введите текст для поиска...'**
  String get searchPlaceholder;

  /// No description provided for @searchTabText.
  ///
  /// In ru, this message translates to:
  /// **'Текст'**
  String get searchTabText;

  /// No description provided for @searchTabTitles.
  ///
  /// In ru, this message translates to:
  /// **'Заголовки'**
  String get searchTabTitles;

  /// No description provided for @searchTabComments.
  ///
  /// In ru, this message translates to:
  /// **'Заметки'**
  String get searchTabComments;

  /// No description provided for @noResults.
  ///
  /// In ru, this message translates to:
  /// **'Ничего не найдено'**
  String get noResults;

  /// No description provided for @resultsCount.
  ///
  /// In ru, this message translates to:
  /// **'{count} результатов'**
  String resultsCount(int count);

  /// No description provided for @pageOf.
  ///
  /// In ru, this message translates to:
  /// **'Страница {current} из {total}'**
  String pageOf(int current, int total);

  /// No description provided for @loading.
  ///
  /// In ru, this message translates to:
  /// **'Загрузка...'**
  String get loading;

  /// No description provided for @error.
  ///
  /// In ru, this message translates to:
  /// **'Ошибка'**
  String get error;

  /// No description provided for @retry.
  ///
  /// In ru, this message translates to:
  /// **'Повторить'**
  String get retry;

  /// No description provided for @cancel.
  ///
  /// In ru, this message translates to:
  /// **'Отмена'**
  String get cancel;

  /// No description provided for @addBookmark.
  ///
  /// In ru, this message translates to:
  /// **'Добавить закладку'**
  String get addBookmark;

  /// No description provided for @removeBookmark.
  ///
  /// In ru, this message translates to:
  /// **'Удалить закладку'**
  String get removeBookmark;

  /// No description provided for @noBookmarks.
  ///
  /// In ru, this message translates to:
  /// **'У вас пока нет закладок'**
  String get noBookmarks;

  /// No description provided for @audioPlayer.
  ///
  /// In ru, this message translates to:
  /// **'Аудио плеер'**
  String get audioPlayer;

  /// No description provided for @sections.
  ///
  /// In ru, this message translates to:
  /// **'Разделы'**
  String get sections;

  /// No description provided for @salads.
  ///
  /// In ru, this message translates to:
  /// **'Салаты'**
  String get salads;

  /// No description provided for @soups.
  ///
  /// In ru, this message translates to:
  /// **'Супы'**
  String get soups;

  /// No description provided for @mainCourses.
  ///
  /// In ru, this message translates to:
  /// **'Горячее'**
  String get mainCourses;

  /// No description provided for @desserts.
  ///
  /// In ru, this message translates to:
  /// **'Десерты'**
  String get desserts;

  /// No description provided for @drinks.
  ///
  /// In ru, this message translates to:
  /// **'Напитки'**
  String get drinks;

  /// No description provided for @ingredients.
  ///
  /// In ru, this message translates to:
  /// **'Ингредиенты'**
  String get ingredients;

  /// No description provided for @preparation.
  ///
  /// In ru, this message translates to:
  /// **'Приготовление'**
  String get preparation;

  /// No description provided for @servings.
  ///
  /// In ru, this message translates to:
  /// **'Порций'**
  String get servings;

  /// No description provided for @prepTime.
  ///
  /// In ru, this message translates to:
  /// **'Время подготовки'**
  String get prepTime;

  /// No description provided for @cookTime.
  ///
  /// In ru, this message translates to:
  /// **'Время приготовления'**
  String get cookTime;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['hi', 'ja', 'ru', 'th', 'zh'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'hi':
      return AppLocalizationsHi();
    case 'ja':
      return AppLocalizationsJa();
    case 'ru':
      return AppLocalizationsRu();
    case 'th':
      return AppLocalizationsTh();
    case 'zh':
      return AppLocalizationsZh();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
