# План имплементации: Vegetarian Cookbook Flutter App

> Version: 1.0
> Status: DRAFT
> Last Updated: 2026-05-02
> Specifications: [03-specifications.md](03-specifications.md)

## Краткое описание

Поэтапная имплементация Flutter-приложения вегетарианской кулинарной книги. План разбит на 6 фаз: от создания проекта до полировки и тестирования.

---

## Фаза 1: Инициализация проекта

### Task 1.1: Создать Flutter проект
- **Описание**: Инициализировать новый Flutter проект с поддержкой всех платформ
- **Файлы**:
  - `app/cookbook/` - Создать (flutter create)
  - `app/cookbook/pubspec.yaml` - Настроить
- **Зависимости**: Нет
- **Проверка**: `flutter doctor` без ошибок, `flutter run` запускается
- **Сложность**: Low

### Task 1.2: Настроить pubspec.yaml
- **Описание**: Добавить все зависимости и настроить assets
- **Файлы**:
  - `app/cookbook/pubspec.yaml` - Изменить
- **Зависимости**: Task 1.1
- **Проверка**: `flutter pub get` без ошибок
- **Сложность**: Low

```yaml
dependencies:
  flutter_bloc: ^8.1.0
  equatable: ^2.0.0
  just_audio: ^0.9.0
  xml: ^6.4.0
  shared_preferences: ^2.2.0
  intl: ^0.18.0

flutter:
  assets:
    - assets/images/content/
    - assets/images/covers/
    - assets/images/sprites/
    - assets/data/
  fonts:
    - family: MurariChandUni
      fonts:
        - asset: assets/fonts/MurariChandUni.ttf
```

### Task 1.3: Скопировать ресурсы из legacy
- **Описание**: Перенести изображения, шрифты и XML данные
- **Файлы**:
  - `app/cookbook/assets/images/content/` - Создать (441 файлов)
  - `app/cookbook/assets/images/covers/` - Создать (5 файлов)
  - `app/cookbook/assets/images/sprites/` - Создать (47 файлов)
  - `app/cookbook/assets/fonts/MurariChandUni.ttf` - Создать
  - `app/cookbook/assets/data/book.xml` - Создать
- **Зависимости**: Task 1.1
- **Проверка**: Все файлы на месте, размер ~620MB
- **Сложность**: Low

### Task 1.4: Настроить локализацию
- **Описание**: Создать базовые ARB файлы для 5 языков
- **Файлы**:
  - `app/cookbook/lib/l10n/app_ru.arb` - Создать
  - `app/cookbook/lib/l10n/app_zh.arb` - Создать
  - `app/cookbook/lib/l10n/app_th.arb` - Создать
  - `app/cookbook/lib/l10n/app_hi.arb` - Создать
  - `app/cookbook/lib/l10n/app_ja.arb` - Создать
  - `app/cookbook/l10n.yaml` - Создать
- **Зависимости**: Task 1.2
- **Проверка**: `flutter gen-l10n` генерирует файлы
- **Сложность**: Medium

---

## Фаза 2: Модели данных и парсинг

### Task 2.1: Создать базовые модели
- **Описание**: Реализовать все модели данных из спецификации
- **Файлы**:
  - `lib/models/book.dart` - Создать
  - `lib/models/book_page.dart` - Создать
  - `lib/models/book_section.dart` - Создать
  - `lib/models/paragraph.dart` - Создать
  - `lib/models/paragraph_style.dart` - Создать
  - `lib/models/models.dart` - Создать (barrel export)
- **Зависимости**: Task 1.2
- **Проверка**: Unit tests проходят
- **Сложность**: Medium

### Task 2.2: Создать модели анимаций и контролов
- **Описание**: Модели для анимаций и элементов управления
- **Файлы**:
  - `lib/models/animation_config.dart` - Создать
  - `lib/models/control_info.dart` - Создать
  - `lib/models/bookmark.dart` - Создать
- **Зависимости**: Task 2.1
- **Проверка**: Unit tests проходят
- **Сложность**: Medium

### Task 2.3: Реализовать BookParserService
- **Описание**: Парсинг XML книги в модели Dart
- **Файлы**:
  - `lib/services/book_parser_service.dart` - Создать
- **Зависимости**: Task 2.1, Task 2.2
- **Проверка**: Парсинг example.xml без ошибок, все 441 страница загружены
- **Сложность**: High

### Task 2.4: Написать тесты для парсера
- **Описание**: Unit tests для BookParserService
- **Файлы**:
  - `test/services/book_parser_service_test.dart` - Создать
  - `test/fixtures/test_book.xml` - Создать (минимальный XML)
- **Зависимости**: Task 2.3
- **Проверка**: Все тесты проходят
- **Сложность**: Medium

---

## Фаза 3: State Management (Bloc)

### Task 3.1: Реализовать BookBloc
- **Описание**: Bloc для управления книгой и навигацией
- **Файлы**:
  - `lib/bloc/book/book_bloc.dart` - Создать
  - `lib/bloc/book/book_event.dart` - Создать
  - `lib/bloc/book/book_state.dart` - Создать
- **Зависимости**: Task 2.3
- **Проверка**: Bloc tests проходят
- **Сложность**: Medium

### Task 3.2: Реализовать SearchBloc и SearchService
- **Описание**: Поиск по тексту, заголовкам и комментариям
- **Файлы**:
  - `lib/services/search_service.dart` - Создать
  - `lib/bloc/search/search_bloc.dart` - Создать
  - `lib/bloc/search/search_event.dart` - Создать
  - `lib/bloc/search/search_state.dart` - Создать
- **Зависимости**: Task 3.1
- **Проверка**: Поиск находит текст, debounce работает
- **Сложность**: Medium

### Task 3.3: Реализовать BookmarksBloc и Storage
- **Описание**: CRUD закладок с персистентным хранением
- **Файлы**:
  - `lib/services/bookmark_storage_service.dart` - Создать
  - `lib/bloc/bookmarks/bookmarks_bloc.dart` - Создать
  - `lib/bloc/bookmarks/bookmarks_event.dart` - Создать
  - `lib/bloc/bookmarks/bookmarks_state.dart` - Создать
- **Зависимости**: Task 2.2
- **Проверка**: Закладки сохраняются между сессиями
- **Сложность**: Medium

### Task 3.4: Реализовать AudioBloc и AudioService
- **Описание**: Воспроизведение аудио страниц
- **Файлы**:
  - `lib/services/audio_service.dart` - Создать
  - `lib/bloc/audio/audio_bloc.dart` - Создать
  - `lib/bloc/audio/audio_event.dart` - Создать
  - `lib/bloc/audio/audio_state.dart` - Создать
- **Зависимости**: Task 1.2
- **Проверка**: Аудио воспроизводится, seek работает
- **Сложность**: Medium

### Task 3.5: Реализовать SettingsBloc
- **Описание**: Настройки языка и темы
- **Файлы**:
  - `lib/bloc/settings/settings_bloc.dart` - Создать
  - `lib/bloc/settings/settings_event.dart` - Создать
  - `lib/bloc/settings/settings_state.dart` - Создать
- **Зависимости**: Task 1.4
- **Проверка**: Смена языка работает
- **Сложность**: Low

### Task 3.6: Написать Bloc tests
- **Описание**: Unit tests для всех Bloc
- **Файлы**:
  - `test/bloc/book_bloc_test.dart` - Создать
  - `test/bloc/search_bloc_test.dart` - Создать
  - `test/bloc/bookmarks_bloc_test.dart` - Создать
  - `test/bloc/audio_bloc_test.dart` - Создать
- **Зависимости**: Task 3.1-3.5
- **Проверка**: Все тесты проходят
- **Сложность**: Medium

---

## Фаза 4: UI компоненты

### Task 4.1: Создать ResponsiveLayout
- **Описание**: Базовый виджет для адаптивной верстки
- **Файлы**:
  - `lib/utils/responsive_breakpoints.dart` - Создать
  - `lib/widgets/common/responsive_layout.dart` - Создать
- **Зависимости**: Task 1.1
- **Проверка**: Корректные breakpoints на разных размерах экрана
- **Сложность**: Low

### Task 4.2: Реализовать BookPageView
- **Описание**: Виджет отображения страницы книги
- **Файлы**:
  - `lib/widgets/page_view/book_page_view.dart` - Создать
  - `lib/widgets/page_view/page_content.dart` - Создать
  - `lib/widgets/page_view/page_background.dart` - Создать
- **Зависимости**: Task 4.1, Task 3.1
- **Проверка**: Страница рендерится с фоном и текстом
- **Сложность**: High

### Task 4.3: Реализовать Controls Overlay
- **Описание**: Интерактивные элементы управления на странице
- **Файлы**:
  - `lib/widgets/controls/page_controls.dart` - Создать
  - `lib/widgets/controls/control_button.dart` - Создать
  - `lib/widgets/controls/draggable_control.dart` - Создать
- **Зависимости**: Task 4.2
- **Проверка**: Контролы отображаются, нажатие работает
- **Сложность**: Medium

### Task 4.4: Реализовать анимации
- **Описание**: Виджеты для спрайтов и трансформаций
- **Файлы**:
  - `lib/widgets/animations/sprite_animation.dart` - Создать
  - `lib/widgets/animations/fade_animation.dart` - Создать
  - `lib/widgets/animations/rotate_animation.dart` - Создать
  - `lib/widgets/animations/scale_animation.dart` - Создать
  - `lib/widgets/animations/animation_overlay.dart` - Создать
- **Зависимости**: Task 4.2
- **Проверка**: Спрайты анимируются, трансформации работают
- **Сложность**: High

### Task 4.5: Реализовать AudioPlayerBar
- **Описание**: Свернутый и развернутый аудио плеер
- **Файлы**:
  - `lib/widgets/audio/audio_player_bar.dart` - Создать
  - `lib/widgets/audio/audio_player_expanded.dart` - Создать
- **Зависимости**: Task 3.4
- **Проверка**: Play/pause, seek, progress bar работают
- **Сложность**: Medium

### Task 4.6: Реализовать Search UI
- **Описание**: Экран поиска с табами и результатами
- **Файлы**:
  - `lib/widgets/search/search_field.dart` - Создать
  - `lib/widgets/search/search_tabs.dart` - Создать
  - `lib/widgets/search/search_result_item.dart` - Создать
- **Зависимости**: Task 3.2
- **Проверка**: Поиск работает, подсветка результатов
- **Сложность**: Medium

### Task 4.7: Реализовать AppDrawer
- **Описание**: Боковое меню с навигацией
- **Файлы**:
  - `lib/widgets/drawer/app_drawer.dart` - Создать
  - `lib/widgets/common/language_selector.dart` - Создать
- **Зависимости**: Task 3.5, Task 4.1
- **Проверка**: Drawer открывается, разделы кликабельны
- **Сложность**: Medium

---

## Фаза 5: Экраны и навигация

### Task 5.1: Реализовать SplashScreen
- **Описание**: Экран загрузки с прогрессом
- **Файлы**:
  - `lib/screens/splash_screen.dart` - Создать
- **Зависимости**: Task 3.1
- **Проверка**: Показывает прогресс загрузки книги
- **Сложность**: Low

### Task 5.2: Реализовать MainScreen
- **Описание**: Главный экран с PageView и навигацией
- **Файлы**:
  - `lib/screens/main_screen.dart` - Создать
- **Зависимости**: Task 4.2, Task 4.3, Task 4.4, Task 4.5, Task 4.7
- **Проверка**: Свайп-навигация, адаптивный layout
- **Сложность**: High

### Task 5.3: Реализовать SearchScreen
- **Описание**: Экран поиска (модальный или полноэкранный)
- **Файлы**:
  - `lib/screens/search_screen.dart` - Создать
- **Зависимости**: Task 4.6
- **Проверка**: Поиск, переход к результату
- **Сложность**: Medium

### Task 5.4: Реализовать BookmarksScreen
- **Описание**: Список закладок с редактированием
- **Файлы**:
  - `lib/screens/bookmarks_screen.dart` - Создать
- **Зависимости**: Task 3.3
- **Проверка**: CRUD закладок, переход к странице
- **Сложность**: Medium

### Task 5.5: Настроить навигацию и App
- **Описание**: Роутинг и главный виджет приложения
- **Файлы**:
  - `lib/app.dart` - Создать
  - `lib/main.dart` - Изменить
- **Зависимости**: Task 5.1-5.4
- **Проверка**: Навигация между экранами работает
- **Сложность**: Medium

---

## Фаза 6: Полировка и тестирование

### Task 6.1: Адаптивная верстка для всех экранов
- **Описание**: Проверить и доработать layout для всех breakpoints
- **Файлы**:
  - `lib/screens/*.dart` - Изменить
  - `lib/widgets/**/*.dart` - Изменить
- **Зависимости**: Task 5.5
- **Проверка**: Корректное отображение на mobile/tablet/desktop
- **Сложность**: Medium

### Task 6.2: Landscape ориентация
- **Описание**: Оптимизировать layout для landscape
- **Файлы**:
  - `lib/screens/main_screen.dart` - Изменить
  - `lib/widgets/page_view/book_page_view.dart` - Изменить
- **Зависимости**: Task 6.1
- **Проверка**: 2-колоночный layout в landscape
- **Сложность**: Medium

### Task 6.3: Обработка ошибок и edge cases
- **Описание**: Error states, loading, empty states
- **Файлы**:
  - `lib/widgets/common/error_view.dart` - Создать
  - `lib/widgets/common/loading_indicator.dart` - Создать
  - `lib/widgets/common/empty_state.dart` - Создать
- **Зависимости**: Task 5.5
- **Проверка**: Graceful handling всех ошибок
- **Сложность**: Medium

### Task 6.4: Widget tests
- **Описание**: Тесты UI компонентов
- **Файлы**:
  - `test/widgets/book_page_view_test.dart` - Создать
  - `test/widgets/responsive_layout_test.dart` - Создать
  - `test/widgets/search_result_item_test.dart` - Создать
- **Зависимости**: Task 6.1
- **Проверка**: Все widget tests проходят
- **Сложность**: Medium

### Task 6.5: Integration tests
- **Описание**: End-to-end тесты основных сценариев
- **Файлы**:
  - `integration_test/app_test.dart` - Создать
- **Зависимости**: Task 6.4
- **Проверка**: Навигация, поиск, закладки работают
- **Сложность**: High

### Task 6.6: Платформо-специфичные настройки
- **Описание**: Иконки, splash, permissions для всех платформ
- **Файлы**:
  - `android/app/src/main/AndroidManifest.xml` - Изменить
  - `ios/Runner/Info.plist` - Изменить
  - `macos/Runner/Info.plist` - Изменить
  - `windows/runner/Runner.rc` - Изменить
  - `linux/my_application.cc` - Изменить
- **Зависимости**: Task 5.5
- **Проверка**: Сборка для всех 5 платформ
- **Сложность**: Medium

---

## Граф зависимостей

```
Phase 1: Инициализация
1.1 ─┬─> 1.2 ─┬─> 1.4
     │        │
     └─> 1.3  └─> Phase 2

Phase 2: Модели и парсинг
1.2 ──> 2.1 ──> 2.2 ──> 2.3 ──> 2.4
                         │
                         v
Phase 3: Bloc            │
         ┌───────────────┘
         v
        3.1 ──┬──> 3.2
              │
              ├──> 3.3
              │
              ├──> 3.4
              │
              └──> 3.5 ──> 3.6

Phase 4: UI
1.1 ──> 4.1 ──┬──> 4.2 ──┬──> 4.3
              │          │
              │          ├──> 4.4
              │          │
3.4 ──────────┴──> 4.5   │
                         │
3.2 ──────────────> 4.6  │
                         │
3.5 + 4.1 ────────> 4.7  │
                         v
Phase 5: Экраны          │
3.1 ──────────> 5.1      │
                         │
4.2-4.7 ───────> 5.2 <───┘
                  │
4.6 ──────> 5.3 <─┤
                  │
3.3 ──────> 5.4 <─┤
                  │
                  v
                5.5 ──> Phase 6

Phase 6: Полировка
5.5 ──> 6.1 ──> 6.2
         │
         ├──> 6.3
         │
         └──> 6.4 ──> 6.5
              │
              └──> 6.6
```

---

## Сводка изменений файлов

| Файл | Действие | Фаза |
|------|----------|------|
| `app/cookbook/` | Создать | 1 |
| `pubspec.yaml` | Создать/Изменить | 1 |
| `assets/**` | Создать (~500 файлов) | 1 |
| `lib/l10n/*.arb` | Создать (5 файлов) | 1 |
| `lib/models/*.dart` | Создать (~10 файлов) | 2 |
| `lib/services/*.dart` | Создать (4 файла) | 2-3 |
| `lib/bloc/**/*.dart` | Создать (~15 файлов) | 3 |
| `lib/widgets/**/*.dart` | Создать (~20 файлов) | 4 |
| `lib/screens/*.dart` | Создать (4 файла) | 5 |
| `lib/utils/*.dart` | Создать (3 файла) | 4 |
| `lib/app.dart` | Создать | 5 |
| `lib/main.dart` | Изменить | 5 |
| `test/**/*.dart` | Создать (~15 файлов) | 2-6 |
| Платформенные файлы | Изменить (5 файлов) | 6 |

**Итого**: ~80 файлов кода + ~500 ресурсов

---

## Оценка рисков

| Риск | Вероятность | Влияние | Митигация |
|------|-------------|---------|-----------|
| Сложность парсинга XML | Medium | High | Начать с минимального XML для тестов |
| Размер бандла (~620MB) | High | Medium | Оптимизировать изображения, lazy loading |
| Производительность анимаций | Medium | Medium | Использовать RepaintBoundary, кэширование |
| Кроссплатформенные баги | Medium | Medium | Тестировать на всех платформах параллельно |
| Проблемы с аудио на desktop | Low | Medium | Fallback к другой библиотеке при необходимости |

---

## Стратегия отката

Если имплементация провалится:

1. Git revert до последнего стабильного коммита
2. Откатить изменения в pubspec.yaml
3. Удалить созданные файлы

---

## Чекпоинты

После каждой фазы проверить:

- [ ] Все тесты проходят
- [ ] Нет новых warnings
- [ ] `flutter analyze` без ошибок
- [ ] Приложение запускается на минимум 2 платформах

---

## Approval

- [ ] Reviewed by: [name]
- [ ] Approved on: [date]
- [ ] Notes: [any conditions or clarifications]
