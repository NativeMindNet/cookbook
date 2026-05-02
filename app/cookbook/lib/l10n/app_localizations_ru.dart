// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Russian (`ru`).
class AppLocalizationsRu extends AppLocalizations {
  AppLocalizationsRu([String locale = 'ru']) : super(locale);

  @override
  String get appTitle => 'Вегетарианская кулинарная книга';

  @override
  String get search => 'Поиск';

  @override
  String get bookmarks => 'Закладки';

  @override
  String get settings => 'Настройки';

  @override
  String get language => 'Язык';

  @override
  String get searchPlaceholder => 'Введите текст для поиска...';

  @override
  String get searchTabText => 'Текст';

  @override
  String get searchTabTitles => 'Заголовки';

  @override
  String get searchTabComments => 'Заметки';

  @override
  String get noResults => 'Ничего не найдено';

  @override
  String resultsCount(int count) {
    return '$count результатов';
  }

  @override
  String pageOf(int current, int total) {
    return 'Страница $current из $total';
  }

  @override
  String get loading => 'Загрузка...';

  @override
  String get error => 'Ошибка';

  @override
  String get retry => 'Повторить';

  @override
  String get cancel => 'Отмена';

  @override
  String get addBookmark => 'Добавить закладку';

  @override
  String get removeBookmark => 'Удалить закладку';

  @override
  String get noBookmarks => 'У вас пока нет закладок';

  @override
  String get audioPlayer => 'Аудио плеер';

  @override
  String get sections => 'Разделы';

  @override
  String get salads => 'Салаты';

  @override
  String get soups => 'Супы';

  @override
  String get mainCourses => 'Горячее';

  @override
  String get desserts => 'Десерты';

  @override
  String get drinks => 'Напитки';

  @override
  String get ingredients => 'Ингредиенты';

  @override
  String get preparation => 'Приготовление';

  @override
  String get servings => 'Порций';

  @override
  String get prepTime => 'Время подготовки';

  @override
  String get cookTime => 'Время приготовления';
}
