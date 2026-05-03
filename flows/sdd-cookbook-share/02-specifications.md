# Specifications: cookbook-share

> Version: 1.0  
> Status: DRAFT  
> Last Updated: 2026-05-03  
> Requirements: [01-requirements.md](./01-requirements.md)

## Overview

Добавляется **построение публичного веб-URL** из текущего `GoRouter` state и `AppConfig`, плюс **единый UI** «Поделиться» на экранах с контентом. Формула URL согласована с тем, как `UriResolver` снимает базу: итоговый HTTPS-URL открывает ту же логическую страницу, что и `location` в приложении.

## Affected Systems

| System | Impact | Notes |
|--------|--------|-------|
| `lib/router/` | Modify / extend | Возможен helper рядом с `UriResolver` или метод на `AppConfig` |
| Экраны (`MainScreen`, `SearchScreen`, `BookmarksScreen`, …) | Modify | Подключение share action; либо один общий `Scaffold` / обёртка |
| `SplashScreen`, `UnknownRouteScreen` | Modify или skip | По ответам на open questions в requirements |
| `pubspec.yaml` | Modify | Зависимость `share_plus` (или аналог) |
| Тесты | Create | Юнит-тесты сборки URL без `WidgetTester` там, где возможно |

## Architecture

### URL construction (концептуально)

Обратная операция к `_stripWebBase`:

1. Взять `location` = `GoRouterState.of(context).uri` (или эквивалент: path + query без лишнего фрагмента, если фрагменты не используются).
2. Нормализовать: путь должен начинаться с `/` (как в `go_router`).
3. Склеить: `base = config.webAppBaseUri` (уже с path prefix и обычно trailing `/`), затем **убрать завершающий `/` у base path** или использовать `Uri.resolve`:  
   `final public = config.webAppBaseUri.resolve(location.startsWith('/') ? '.$location' : location);`  
   Уточнить в реализации: `Uri.parse(base.toString()).resolve(location)` избегает двойных слэшей.

Инвариант: для `u = builtShareUri`, `uriResolver.normalizeToLocation(u) == location` (для того же `config`), если `u.host` совпадает с `webAppBaseUri.host` и путь под префиксом.

### UI

- **Предпочтительно**: одна точка входа — например `ShareAppBarAction` или mixin/listener, чтобы не дублировать логику на каждом файле.
- **Иконка**: `Icons.share` / `Icons.ios_share` в зависимости от платформы (опционально).
- Вызов: `Share.shareUri(uri)` (API `share_plus` 10+) или `Share.share(uri.toString())`.

### Data Flow

1. Пользователь нажимает «Поделиться».
2. Читается `GoRouter` → `uri` (path + query).
3. Строится `Uri` веб-ссылки через `AppConfig`.
4. `Share.share*` / Web fallback.

## Behavior Specifications

### Happy Path

1. Пользователь на `/book/12?highlight=foo`.
2. Нажимает «Поделиться».
3. В share sheet строка вида `https://<host>/<prefix>/book/12?highlight=foo` (точный вид = результат `Uri.toString()`).

### Edge Cases

| Case | Trigger | Expected Behavior |
|------|---------|-------------------|
| Пустой query | location без `?` | URL без query |
| Trailing slash в `WEBAPP_URL` | конфиг из `.env` | Корректная склейка без `//` в середине пути |
| Web | `kIsWeb` | Share или copy; не падать, если `share_plus` ограничен |

### Error Handling

| Error | Response |
|-------|----------|
| Нет контекста роутера | Не показывать кнопку или no-op с debug log |
| Share отменён пользователем | Игнорировать |

## Dependencies

### Requires

- Рабочий `AppConfig` с `webAppBaseUri` (уже есть).
- Согласованность с `UriResolver` (желательно тест парity).

### Blocks

- Нет.

## Testing Strategy

### Unit Tests

- [ ] Функция/класс `location → Uri`: кейсы с query, с `/book`, с `/`.
- [ ] Round-trip с фиктивным `AppConfig.fake(webAppBaseUri: ...)`.

### Manual Verification

- [ ] Android / iOS: share sheet с валидной ссылкой.
- [ ] Открыть ссылку в браузере — нужный экран веб-сборки.

## Open Design Questions

- [ ] Размещение кнопки: в каждом `AppBar` vs один родительский route shell (если появится).
- [ ] Splash: см. requirements.

---

## Approval

- [ ] Reviewed by:
- [ ] Approved on:
- [ ] Notes:
