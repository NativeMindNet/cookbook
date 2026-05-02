# Implementation Plan: cookbook-route-deeplink

> Version: 1.0  
> Status: DRAFT  
> Last Updated: 2026-05-02  
> Specifications: [02-specifications.md](./02-specifications.md)

## Summary

Подключить загрузку конфигурации из `.env`, ввести `GoRouter` с парсингом начального и входящих URI (включая схему `cookbook`), настроить платформенные deeplink/App Links, обеспечить SPA-fallback для web и добавить баннер установки с выбором стора по стране.

## Task Breakdown

### Phase 1: Конфигурация и зависимости

#### Task 1.1: Зависимости и env

- **Description**: Добавить `go_router`, `app_links` (или аналог), `flutter_dotenv`, `url_launcher`; зарегистрировать `.env` в assets для нужных платформ или перейти на `--dart-define-from-file` для CI.
- **Files**:
  - `app/cookbook/pubspec.yaml` — Modify
  - `app/cookbook/.env.example` — Create (без секретов; те же ключи что в `.env`)
- **Dependencies**: None
- **Verification**: `flutter pub get`, приложение стартует с загрузкой env в debug
- **Complexity**: Low

#### Task 1.2: Модуль конфигурации стора и web base

- **Description**: Класс `AppConfig` / `StoreLinks`, читающий переменные из dotenv; валидация наличия URL.
- **Files**:
  - `app/cookbook/lib/config/app_config.dart` — Create
- **Dependencies**: Task 1.1
- **Verification**: Unit-тест парсинга base URL из `WEBAPP_URL`
- **Complexity**: Low

### Phase 2: Роутинг и нормализация URI

#### Task 2.1: GoRouter и карта маршрутов

- **Description**: Заменить/обернуть `MaterialApp` в `MaterialApp.router`; объявить маршруты экранов книги (плейсхолдеры согласовать с реальной навигацией при имплементации).
- **Files**:
  - `app/cookbook/lib/main.dart` — Modify
  - `app/cookbook/lib/router/app_router.dart` — Create
  - `app/cookbook/lib/router/uri_resolver.dart` — Create
- **Dependencies**: Task 1.2
- **Verification**: Навигация по `context.go('/...')` работает на всех платформах
- **Complexity**: Medium

#### Task 2.2: Начальный маршрут и входящие ссылки

- **Description**: Обработка initial route на mobile/desktop/web; подписка на `app_links` для foreground/background.
- **Files**:
  - `app/cookbook/lib/router/deep_link_handler.dart` — Create
- **Dependencies**: Task 2.1
- **Verification**: Ручной тест deeplink
- **Complexity**: Medium

### Phase 3: Платформы

#### Task 3.1: Android intent-filters и Digital Asset Links

- **Description**: `VIEW` для `cookbook://` и для `https` с host/path из `WEBAPP_URL`; документировать размещение `assetlinks.json` на сайте (путь `/.well-known/`).
- **Files**:
  - `app/cookbook/android/app/src/main/AndroidManifest.xml` — Modify
- **Dependencies**: Task 2.2
- **Verification**: Проверка через Google «Statement List Generator» и ручной запуск intent
- **Complexity**: Medium

#### Task 3.2: iOS URL scheme и Associated Domains

- **Description**: Зарегистрировать схему `cookbook`; capability Associated Domains; шаблон `apple-app-site-association`.
- **Files**:
  - `app/cookbook/ios/Runner/Info.plist` — Modify
  - `app/cookbook/ios/Runner/*.entitlements` — Create/Modify
- **Dependencies**: Task 2.2
- **Verification**: Тест в симуляторе
- **Complexity**: Medium

#### Task 3.3: Web path URL strategy и SPA fallback

- **Description**: `setUrlStrategy(PathUrlStrategy())`; в скрипте деплоя или README — копирование `build/web/index.html` → `build/web/404.html` для GitHub Pages.
- **Files**:
  - `app/cookbook/lib/main.dart` или `web/index.html` — Modify
  - Скрипт в `tools/` или док в репозитории — по принятому в проекте месту
- **Dependencies**: Task 2.1
- **Verification**: Прямой заход на под-URL на gh-pages
- **Complexity**: Low–Medium

### Phase 4: UI и полировка

#### Task 4.1: Виджет «Установить приложение» (web-only mobile)

- **Description**: Определение mobile web; страна; кнопки «Установить» / «Закрыть»; `url_launcher`.
- **Files**:
  - `app/cookbook/lib/widgets/install_app_prompt.dart` — Create
  - `app/cookbook/lib/services/store_country_resolver.dart` — Create
- **Dependencies**: Task 1.2
- **Verification**: Widget-тесты + ручной Safari/Chrome mobile emulation
- **Complexity**: Medium

#### Task 4.2: Тесты и документация для команды

- **Description**: Unit-тесты resolver; краткий раздел в существующем README **только если** в проекте уже принято — иначе ограничиться комментарием в SDD / `04-implementation-log.md`.
- **Files**:
  - `app/cookbook/test/uri_resolver_test.dart` — Create
- **Dependencies**: Tasks 2.1, 4.1
- **Verification**: `flutter test`
- **Complexity**: Low

## Dependency Graph

```
Task 1.1 ──→ Task 1.2 ──┬──→ Task 2.1 ──→ Task 2.2 ──→ Task 3.1
                        │              └────────────→ Task 3.2
                        │              └────────────→ Task 3.3
                        └──→ Task 4.1 ──→ Task 4.2
Task 2.1 ────────────────────────────────────────────────┘
```

## File Change Summary

| File | Action | Reason |
|------|--------|--------|
| `pubspec.yaml` | Modify | Зависимости, assets `.env` |
| `lib/config/app_config.dart` | Create | Централизованные URL из env |
| `lib/router/*` | Create | GoRouter + deeplink |
| `android/.../AndroidManifest.xml` | Modify | Intent filters |
| `ios/Runner/*` | Modify | Scheme + domains |
| `lib/widgets/install_app_prompt.dart` | Create | Баннер установки |
| `build/web/404.html` (артефакт) | Generate | SPA на GH Pages |

## Risk Assessment

| Risk | Likelihood | Impact | Mitigation |
|------|------------|--------|------------|
| AASA/assetlinks не размещены на домене | Med | High | Чеклист в логе имплементации; временно опираться на custom scheme |
| Неверный `WEBAPP_URL` в проде | Low | High | Валидация при старте в debug |
| App Store URL всё ещё заглушка | Med | Med | Явная задача в логе исправить перед iOS-релизом |

## Rollback Strategy

1. Откат коммита; удалить intent-filters если ломают установку.
2. Оставить только web routing без баннера.

## Checkpoints

- [ ] После Phase 2: роутинг без deeplink платформы работает.
- [ ] После Phase 3: минимум один успешный тест на Android.
- [ ] После Phase 4: тесты зелёные.

## Open Implementation Questions

- [ ] Точные имена маршрутов под текущие экраны книги (после рефакторинга main).

---

## Approval

- [ ] Reviewed by:
- [ ] Approved on:
- [ ] Notes:
