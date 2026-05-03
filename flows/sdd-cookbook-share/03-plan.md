# Implementation Plan: cookbook-share

> Version: 1.0  
> Status: DRAFT  
> Last Updated: 2026-05-03  
> Specifications: [02-specifications.md](./02-specifications.md)

## Summary

Ввести утилиту сборки публичного веб-URL из `AppConfig` + строки location, покрыть тестами совместимость с `UriResolver`, добавить зависимость share и единое действие «Поделиться» в AppBar (или эквивалент) на экранах `/book`, `/book/:pageIndex`, `/search`, `/bookmarks`; поведение для `/` и unknown — после закрытия open questions.

## Task Breakdown

### Phase 1: URL helper + tests

#### Task 1.1: Share URL builder
- **Description**: Реализовать чистую функцию/метод `Uri shareWebUri(AppConfig config, String location)` (или `Uri` input) без `BuildContext`.
- **Files**: новый файл в `lib/router/` или `lib/config/` — по выбору при реализации.
- **Dependencies**: None
- **Verification**: Юнит-тесты, round-trip с `UriResolver`.
- **Complexity**: Low

#### Task 1.2: pubspec + share API
- **Description**: Добавить `share_plus`, минимальная обёртка сервиса `ShareService.shareUri(Uri)` для тестируемости.
- **Files**: `pubspec.yaml`, `lib/services/share_service.dart` (опционально)
- **Dependencies**: Task 1.1
- **Verification**: Анализатор без ошибок; smoke на устройстве.
- **Complexity**: Low

### Phase 2: UI на экранах

#### Task 2.1: Виджет действия AppBar
- **Description**: `ShareCurrentRouteAction` — читает `GoRouter`, `AppConfig` (через `InheritedWidget`/Riverpod/как в проекте), вызывает share.
- **Files**: `lib/widgets/...`, изменения в экранах
- **Dependencies**: Task 1.2
- **Verification**: Ручной прогон на 2+ маршрутах.
- **Complexity**: Medium

#### Task 2.2: Splash / unknown
- **Description**: По решению из requirements — скрыть кнопку или шарить `/book`.
- **Dependencies**: Task 2.1
- **Verification**: Соответствует зафиксированному решению.
- **Complexity**: Low

### Phase 3: Web (optional)

#### Task 3.1: Web share / clipboard fallback
- **Description**: Если `kIsWeb` — `Share.share` при поддержке, иначе копирование в буфер + snackbar.
- **Dependencies**: Task 2.1
- **Complexity**: Low–Medium

## Dependency Graph

```
Task 1.1 → Task 1.2 → Task 2.1 → Task 2.2
                      ↓
                   Task 3.1 (optional)
```

## File Change Summary

| File | Action | Reason |
|------|--------|--------|
| `lib/.../share_web_uri.dart` (имя TBD) | Create | Сборка URL |
| `test/..._test.dart` | Create | Round-trip / edge cases |
| `pubspec.yaml` | Modify | `share_plus` |
| `main_screen.dart`, `search_screen.dart`, `bookmarks_screen.dart` | Modify | Кнопка share |
| `splash_screen.dart`, `unknown_route_screen.dart` | Modify | По решению |

## Risk Assessment

| Risk | Likelihood | Impact | Mitigation |
|------|------------|--------|------------|
| Неверная склейка base + path | Med | High | Тесты + ручная проверка в браузере |
| share_plus на web | Med | Low | Fallback clipboard |

## Rollback Strategy

1. Revert коммит(ы) фичи.
2. Удалить зависимость, если не используется.

## Checkpoints

- [ ] `flutter test` зелёный
- [ ] Ссылка открывается на задеплоенной веб-сборке (или локально `flutter run -d chrome`)

## Open Implementation Questions

- [ ] Как в проекте передаётся `AppConfig` в виджеты (singleton, Provider, etc.) — следовать существующему паттерну.

---

## Approval

- [ ] Reviewed by:
- [ ] Approved on:
- [ ] Notes:
