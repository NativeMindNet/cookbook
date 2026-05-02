# Спецификации: Vegetarian Cookbook Flutter App

> Version: 1.0
> Status: APPROVED
> Last Updated: 2026-05-02
> Requirements: [01-requirements.md](01-requirements.md)
> Visual: [02-visual.md](02-visual.md)

## Обзор

Flutter-приложение вегетарианской кулинарной книги с адаптивной версткой для 5 платформ (iOS, Android, Windows, Linux, macOS). Архитектура на основе Bloc для state management, с поддержкой 5 языков локализации.

---

## Затрагиваемые системы

| Система | Действие | Описание |
|---------|----------|----------|
| `app/cookbook/` | Создать | Новый Flutter проект |
| `lib/bloc/` | Создать | Bloc-компоненты для управления состоянием |
| `lib/models/` | Создать | Модели данных (Book, Page, Recipe и т.д.) |
| `lib/screens/` | Создать | Экраны приложения |
| `lib/widgets/` | Создать | Переиспользуемые виджеты |
| `lib/services/` | Создать | Сервисы (XML парсинг, аудио, хранение) |
| `lib/l10n/` | Создать | Локализация (5 языков) |
| `assets/` | Создать | Изображения, шрифты, XML данные |

---

## Архитектура

### Структура проекта

```
app/cookbook/
├── lib/
│   ├── main.dart
│   ├── app.dart
│   │
│   ├── bloc/
│   │   ├── book/
│   │   │   ├── book_bloc.dart
│   │   │   ├── book_event.dart
│   │   │   └── book_state.dart
│   │   ├── search/
│   │   │   ├── search_bloc.dart
│   │   │   ├── search_event.dart
│   │   │   └── search_state.dart
│   │   ├── bookmarks/
│   │   │   ├── bookmarks_bloc.dart
│   │   │   ├── bookmarks_event.dart
│   │   │   └── bookmarks_state.dart
│   │   ├── audio/
│   │   │   ├── audio_bloc.dart
│   │   │   ├── audio_event.dart
│   │   │   └── audio_state.dart
│   │   └── settings/
│   │       ├── settings_bloc.dart
│   │       ├── settings_event.dart
│   │       └── settings_state.dart
│   │
│   ├── models/
│   │   ├── book.dart
│   │   ├── book_page.dart
│   │   ├── book_section.dart
│   │   ├── paragraph.dart
│   │   ├── paragraph_style.dart
│   │   ├── recipe.dart
│   │   ├── ingredient.dart
│   │   ├── animation_config.dart
│   │   ├── control_info.dart
│   │   └── bookmark.dart
│   │
│   ├── screens/
│   │   ├── splash_screen.dart
│   │   ├── main_screen.dart
│   │   ├── search_screen.dart
│   │   └── bookmarks_screen.dart
│   │
│   ├── widgets/
│   │   ├── page_view/
│   │   │   ├── book_page_view.dart
│   │   │   ├── page_content.dart
│   │   │   └── page_background.dart
│   │   ├── controls/
│   │   │   ├── page_controls.dart
│   │   │   ├── control_button.dart
│   │   │   └── draggable_control.dart
│   │   ├── animations/
│   │   │   ├── sprite_animation.dart
│   │   │   ├── fade_animation.dart
│   │   │   ├── rotate_animation.dart
│   │   │   └── scale_animation.dart
│   │   ├── audio/
│   │   │   ├── audio_player_bar.dart
│   │   │   └── audio_player_expanded.dart
│   │   ├── search/
│   │   │   ├── search_field.dart
│   │   │   ├── search_tabs.dart
│   │   │   └── search_result_item.dart
│   │   ├── drawer/
│   │   │   └── app_drawer.dart
│   │   └── common/
│   │       ├── responsive_layout.dart
│   │       ├── language_selector.dart
│   │       └── loading_indicator.dart
│   │
│   ├── services/
│   │   ├── book_parser_service.dart
│   │   ├── audio_service.dart
│   │   ├── bookmark_storage_service.dart
│   │   └── search_service.dart
│   │
│   ├── l10n/
│   │   ├── app_ru.arb
│   │   ├── app_zh.arb
│   │   ├── app_th.arb
│   │   ├── app_hi.arb
│   │   └── app_ja.arb
│   │
│   └── utils/
│       ├── responsive_breakpoints.dart
│       ├── color_extensions.dart
│       └── xml_helpers.dart
│
├── assets/
│   ├── images/
│   │   ├── content/          # 001.png - 441.png
│   │   ├── covers/           # cover_1.png - cover_5.png
│   │   └── sprites/          # Saraswati_0001.png - 0047.png
│   ├── fonts/
│   │   └── MurariChandUni.ttf
│   └── data/
│       └── book.xml
│
├── pubspec.yaml
└── test/
```

### Диаграмма компонентов

```
+------------------+     +------------------+     +------------------+
|    UI Layer      |     |   Bloc Layer     |     |  Service Layer   |
+------------------+     +------------------+     +------------------+
|                  |     |                  |     |                  |
| MainScreen       |<--->| BookBloc         |<--->| BookParserService|
| SearchScreen     |<--->| SearchBloc       |<--->| SearchService    |
| BookmarksScreen  |<--->| BookmarksBloc    |<--->| BookmarkStorage  |
| AudioPlayerBar   |<--->| AudioBloc        |<--->| AudioService     |
|                  |     | SettingsBloc     |     |                  |
+------------------+     +------------------+     +------------------+
         |                        |                       |
         v                        v                       v
+------------------------------------------------------------------+
|                         Models Layer                              |
+------------------------------------------------------------------+
| Book | BookPage | Recipe | Ingredient | Bookmark | AnimationConfig |
+------------------------------------------------------------------+
```

### Поток данных

```
[XML Book Data]
      |
      v
[BookParserService] --parse--> [Book Model]
      |
      v
[BookBloc] --state--> [UI Widgets]
      |
      v
[User Actions] --events--> [Bloc] --new state--> [UI Update]
```

---

## Модели данных

### Book (Книга)

```dart
class Book {
  final String id;
  final BookHeader header;
  final BookBody body;

  int get totalPages => body.pages.length;
  List<BookSection> get sections => body.sections;
}

class BookHeader {
  final String title;
  final String language;
  final String? sourceLanguage;
  final String? isbn;
  final String? genre;
  final Orientation orientation; // portrait | landscape | both
  final List<Person> authors;
  final List<Person> translators;
  final PublishInfo? publishInfo;
  final List<ControlInfo> globalControls;
}

class BookBody {
  final List<BookPage> pages;
  final List<BookSection> sections;
  final Map<String, ParagraphStyle> styles;
}
```

### BookPage (Страница)

```dart
class BookPage {
  final int number;
  final List<Paragraph> paragraphs;
  final String? backgroundImagePath;
  final Color? backgroundColor;
  final bool showPageNumber;
  final String? audioUrl;
  final bool autoplayAudio;
  final bool loopAudio;
  final String? comments;
  final List<AnimationConfig> animations;
  final List<ControlInfo> controls;

  // Вычисляемые поля
  String get plainText => paragraphs.map((p) => p.text).join('\n');
  bool get hasAudio => audioUrl != null;
  bool get hasAnimations => animations.isNotEmpty;
}
```

### Recipe (Рецепт) - расширение для вегетарианской книги

```dart
class Recipe {
  final String title;
  final String description;
  final List<Ingredient> ingredients;
  final List<String> steps;
  final Duration? prepTime;
  final Duration? cookTime;
  final int? servings;
  final List<String> tags; // vegetarian, vegan, gluten-free, etc.
  final NutritionalInfo? nutrition;
}

class Ingredient {
  final String name;
  final double amount;
  final String unit; // г, мл, шт, ч.л., ст.л.
  final String? note; // "по вкусу", "для украшения"

  String get formatted => '$amount $unit $name${note != null ? " ($note)" : ""}';
}
```

### Paragraph (Параграф)

```dart
class Paragraph {
  final String text;
  final String? styleName;
  final bool hasLargeCapital;
  final bool isHidden;
}

class ParagraphStyle {
  final String name;
  final String fontFamily;
  final double fontSize;
  final TextAlign textAlignment;
  final Color textColor;
  final Color? backgroundColor;
}
```

### AnimationConfig (Конфигурация анимации)

```dart
abstract class AnimationConfig {
  final String name;
  final Offset center;
  final Size size;
  final Duration startDelay;
  final Duration delayBetweenCycles;
  final bool autostart;
  final bool repeat;
}

class SpriteAnimationConfig extends AnimationConfig {
  final List<String> framePaths;
  final int fps;
}

class FadeAnimationConfig extends AnimationConfig {
  final double startAlpha;
  final double endAlpha;
  final Duration duration;
}

class RotateAnimationConfig extends AnimationConfig {
  final double startAngle;
  final double endAngle;
  final Duration duration;
}

class ScaleAnimationConfig extends AnimationConfig {
  final double startScale;
  final double endScale;
  final Duration duration;
}
```

### ControlInfo (Элемент управления)

```dart
enum ControlType {
  prevPage,
  nextPage,
  bookmarks,
  addBookmark,
  playSound,
  stopSound,
  togglePlayer,
  search,
  pageLink,
  toggleAnimations,
}

class ControlInfo {
  final ControlType type;
  final String? normalImagePath;
  final String? highlightedImagePath;
  final String? disabledImagePath;
  final int? targetPage; // для pageLink
  final bool isDraggable;
  final Offset position;
  final Size size;
}
```

### Bookmark (Закладка)

```dart
class Bookmark {
  final int pageNumber;
  final String? title;
  final DateTime createdAt;
  final String? note;
}
```

---

## Bloc спецификации

### BookBloc

```dart
// Events
abstract class BookEvent {}
class LoadBook extends BookEvent {}
class GoToPage extends BookEvent { final int pageNumber; }
class NextPage extends BookEvent {}
class PreviousPage extends BookEvent {}
class ToggleAnimations extends BookEvent {}

// States
abstract class BookState {}
class BookInitial extends BookState {}
class BookLoading extends BookState {}
class BookLoaded extends BookState {
  final Book book;
  final int currentPage;
  final bool animationsEnabled;
}
class BookError extends BookState { final String message; }
```

### SearchBloc

```dart
// Events
abstract class SearchEvent {}
class SearchTextChanged extends SearchEvent { final String query; }
class SearchTypeChanged extends SearchEvent { final SearchType type; }
class ClearSearch extends SearchEvent {}

enum SearchType { text, titles, comments }

// States
abstract class SearchState {}
class SearchInitial extends SearchState {}
class SearchInProgress extends SearchState {}
class SearchResults extends SearchState {
  final List<SearchResult> results;
  final String query;
  final SearchType type;
}
class SearchEmpty extends SearchState { final String query; }
```

### BookmarksBloc

```dart
// Events
abstract class BookmarksEvent {}
class LoadBookmarks extends BookmarksEvent {}
class AddBookmark extends BookmarksEvent { final int pageNumber; final String? title; }
class RemoveBookmark extends BookmarksEvent { final int pageNumber; }
class ReorderBookmarks extends BookmarksEvent { final int oldIndex; final int newIndex; }

// States
abstract class BookmarksState {}
class BookmarksInitial extends BookmarksState {}
class BookmarksLoaded extends BookmarksState { final List<Bookmark> bookmarks; }
```

### AudioBloc

```dart
// Events
abstract class AudioEvent {}
class PlayAudio extends AudioEvent { final String url; }
class PauseAudio extends AudioEvent {}
class ResumeAudio extends AudioEvent {}
class StopAudio extends AudioEvent {}
class SeekAudio extends AudioEvent { final Duration position; }
class SetLoop extends AudioEvent { final bool loop; }

// States
abstract class AudioState {}
class AudioIdle extends AudioState {}
class AudioPlaying extends AudioState {
  final String url;
  final Duration position;
  final Duration duration;
  final bool isLooping;
}
class AudioPaused extends AudioState {
  final String url;
  final Duration position;
  final Duration duration;
}
class AudioError extends AudioState { final String message; }
```

### SettingsBloc

```dart
// Events
abstract class SettingsEvent {}
class LoadSettings extends SettingsEvent {}
class ChangeLanguage extends SettingsEvent { final String locale; }
class ChangeTheme extends SettingsEvent { final ThemeMode theme; }

// States
class SettingsState {
  final String locale; // ru, zh, th, hi, ja
  final ThemeMode theme;
}
```

---

## Адаптивный Layout

### ResponsiveBreakpoints

```dart
class ResponsiveBreakpoints {
  static const double mobile = 600;
  static const double tablet = 1024;

  static bool isMobile(BuildContext context) =>
    MediaQuery.of(context).size.width < mobile;

  static bool isTablet(BuildContext context) =>
    MediaQuery.of(context).size.width >= mobile &&
    MediaQuery.of(context).size.width < tablet;

  static bool isDesktop(BuildContext context) =>
    MediaQuery.of(context).size.width >= tablet;

  static LayoutType getLayoutType(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width < mobile) return LayoutType.mobile;
    if (width < tablet) return LayoutType.tablet;
    return LayoutType.desktop;
  }
}

enum LayoutType { mobile, tablet, desktop }
```

### ResponsiveLayout Widget

```dart
class ResponsiveLayout extends StatelessWidget {
  final Widget mobile;
  final Widget? tablet;
  final Widget? desktop;

  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth >= 1024) {
          return desktop ?? tablet ?? mobile;
        }
        if (constraints.maxWidth >= 600) {
          return tablet ?? mobile;
        }
        return mobile;
      },
    );
  }
}
```

---

## Сервисы

### BookParserService

```dart
class BookParserService {
  Future<Book> parseFromAsset(String assetPath);
  Future<Book> parseFromXml(String xmlString);

  BookPage _parsePage(XmlElement element);
  Paragraph _parseParagraph(XmlElement element);
  AnimationConfig _parseAnimation(XmlElement element);
  ControlInfo _parseControl(XmlElement element);
}
```

### SearchService

```dart
class SearchService {
  final Book _book;

  Future<List<SearchResult>> searchText(String query);
  Future<List<SearchResult>> searchTitles(String query);
  Future<List<SearchResult>> searchComments(String query);

  String highlightMatches(String text, String query);
}

class SearchResult {
  final int pageNumber;
  final String matchedText;
  final String context; // текст вокруг совпадения
  final SearchType type;
}
```

### AudioService

```dart
class AudioService {
  Stream<AudioPosition> get positionStream;
  Stream<AudioPlayerState> get stateStream;

  Future<void> play(String url);
  Future<void> pause();
  Future<void> resume();
  Future<void> stop();
  Future<void> seek(Duration position);
  Future<void> setLoop(bool loop);

  Duration? get duration;
  Duration? get position;
  bool get isPlaying;
}
```

### BookmarkStorageService

```dart
class BookmarkStorageService {
  Future<List<Bookmark>> loadBookmarks();
  Future<void> saveBookmarks(List<Bookmark> bookmarks);
  Future<void> addBookmark(Bookmark bookmark);
  Future<void> removeBookmark(int pageNumber);
  Future<bool> isBookmarked(int pageNumber);
}
```

---

## Спецификации поведения

### Навигация по страницам

| Действие | Триггер | Результат |
|----------|---------|-----------|
| Следующая страница | Свайп влево / Тап [>>] | currentPage++ (если не последняя) |
| Предыдущая страница | Свайп вправо / Тап [<<] | currentPage-- (если не первая) |
| Переход на страницу | Тап на результат поиска / закладку / page-link | GoToPage(pageNumber) |
| Анимация перехода | Любой переход | PageView с curve animation (300ms) |

### Аудио воспроизведение

| Действие | Триггер | Результат |
|----------|---------|-----------|
| Автозапуск | Переход на страницу с autoplayAudio=true | Play(page.audioUrl) |
| Play | Тап [Play] | Play(currentPage.audioUrl) |
| Pause | Тап [Pause] | Pause() |
| Seek | Drag slider | Seek(position) |
| Stop | Переход на страницу без аудио | Stop() |

### Поиск

| Действие | Триггер | Результат |
|----------|---------|-----------|
| Поиск текста | Ввод в поле + таб "Текст" | searchText(query) в фоне |
| Поиск заголовков | Ввод + таб "Заголовки" | searchTitles(query) |
| Поиск заметок | Ввод + таб "Заметки" | searchComments(query) |
| Очистка | Тап [x] | ClearSearch() |
| Debounce | Ввод текста | 300ms задержка перед поиском |

### Закладки

| Действие | Триггер | Результат |
|----------|---------|-----------|
| Добавить | Тап [+] на странице | AddBookmark(currentPage) |
| Удалить | Свайп влево / Тап (-) в edit mode | RemoveBookmark(pageNumber) |
| Перейти | Тап на закладку | GoToPage(bookmark.pageNumber) |
| Изменить порядок | Long press + drag | ReorderBookmarks(old, new) |

---

## Edge Cases и обработка ошибок

| Случай | Триггер | Поведение |
|--------|---------|-----------|
| Книга не загружена | Ошибка парсинга XML | Показать экран ошибки с [Повторить] |
| Изображение не найдено | Путь не существует | Показать placeholder |
| Аудио недоступно | Файл не найден / ошибка воспроизведения | Показать toast с ошибкой |
| Пустой поиск | Нет результатов | Показать "Ничего не найдено" |
| Первая страница | Свайп вправо / [<<] | Игнорировать (bounce effect) |
| Последняя страница | Свайп влево / [>>] | Игнорировать (bounce effect) |
| Offline | Нет сети (если remote assets) | Использовать кэш / показать ошибку |

---

## Зависимости (pubspec.yaml)

```yaml
dependencies:
  flutter:
    sdk: flutter
  flutter_localizations:
    sdk: flutter

  # State management
  flutter_bloc: ^8.1.0
  equatable: ^2.0.0

  # Audio
  just_audio: ^0.9.0
  audio_session: ^0.1.0

  # Storage
  shared_preferences: ^2.2.0
  path_provider: ^2.1.0

  # XML parsing
  xml: ^6.4.0

  # UI
  flutter_svg: ^2.0.0
  cached_network_image: ^3.3.0 # если будут remote images

  # Utils
  intl: ^0.18.0
  collection: ^1.18.0

dev_dependencies:
  flutter_test:
    sdk: flutter
  bloc_test: ^9.1.0
  mocktail: ^1.0.0
```

---

## Локализация

### Поддерживаемые языки

| Код | Язык | Файл |
|-----|------|------|
| ru | Русский | app_ru.arb |
| zh | Китайский | app_zh.arb |
| th | Тайский | app_th.arb |
| hi | Хинди | app_hi.arb |
| ja | Японский | app_ja.arb |

### Ключи локализации (app_ru.arb)

```json
{
  "appTitle": "Вегетарианская кулинарная книга",
  "search": "Поиск",
  "bookmarks": "Закладки",
  "settings": "Настройки",
  "language": "Язык",
  "searchPlaceholder": "Введите текст для поиска...",
  "searchTabText": "Текст",
  "searchTabTitles": "Заголовки",
  "searchTabComments": "Заметки",
  "noResults": "Ничего не найдено",
  "resultsCount": "{count} результатов",
  "pageOf": "Страница {current} из {total}",
  "loading": "Загрузка...",
  "error": "Ошибка",
  "retry": "Повторить",
  "cancel": "Отмена",
  "addBookmark": "Добавить закладку",
  "removeBookmark": "Удалить закладку",
  "noBookmarks": "У вас пока нет закладок",
  "audioPlayer": "Аудио плеер"
}
```

---

## Тестирование

### Unit Tests

- [ ] BookParserService - парсинг XML
- [ ] SearchService - все типы поиска
- [ ] BookmarkStorageService - CRUD операции
- [ ] Все Bloc - events/states

### Widget Tests

- [ ] ResponsiveLayout - breakpoints
- [ ] BookPageView - отображение контента
- [ ] SearchResultItem - highlighting
- [ ] AudioPlayerBar - controls

### Integration Tests

- [ ] Навигация по страницам
- [ ] Поиск и переход к результату
- [ ] Добавление/удаление закладок
- [ ] Воспроизведение аудио

---

## Миграция ресурсов

| Источник (legacy) | Назначение (Flutter) |
|-------------------|---------------------|
| `Resources/Images/*.png` | `assets/images/content/` |
| `Resources/Images/cover/` | `assets/images/covers/` |
| `Resources/Images/saraswati_p_h/` | `assets/images/sprites/` |
| `Resources/MurariChandUni.ttf` | `assets/fonts/` |
| `Resources/example.xml` | `assets/data/book.xml` |

---

## Open Questions

- [ ] Использовать WebView для рендеринга HTML контента или нативные виджеты?
- [ ] Кэширование изображений - in-memory LRU или disk cache?
- [ ] Формат хранения закладок - SharedPreferences или SQLite?

---

## Approval

- [x] Reviewed by: Anton
- [x] Approved on: 2026-05-02
- [x] Notes: Bloc архитектура, 5 платформ, 5 языков локализации
