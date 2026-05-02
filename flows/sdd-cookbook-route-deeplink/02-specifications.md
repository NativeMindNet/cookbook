# Specifications: cookbook-route-deeplink

> Version: 1.0  
> Status: APPROVED  
> Last Updated: 2026-05-02  
> Requirements: [01-requirements.md](./01-requirements.md)

## Overview

Вводится единая модель **логических маршрутов** (path + query), которая:

1. Парсится из **custom scheme** `cookbook://host/path?query` (на практике host может быть пустым или `open` — зафиксировать один канонический вид).
2. Совпадает с **path** HTTPS-URL после базового префикса `WEBAPP_URL` (например `https://nativemindnet.github.io/cookbook/web/recipe/42` → логический маршрут `/recipe/42`).
3. На **веб** включается **Router** Flutter с `pathUrlStrategy` (без `#`), при этом для GitHub Pages требуется **SPA fallback**: копия `index.html` как `404.html` в артефакт деплоя или эквивалент на CDN.

Дополнительно на **web** показывается **виджет «Установить приложение»**, который выбирает целевой URL стора из `.env` по эвристике страны.

## Affected Systems

| System | Impact | Notes |
|--------|--------|-------|
| Flutter `lib/` | Modify | Роутер, инициализация маршрута из `platformDispatcher.defaultRouteName` / `Uri.base`, обработка `app_links` или встроенный `uni_links` |
| `pubspec.yaml` | Modify | Зависимости: `go_router`, загрузка env (`flutter_dotenv` или codegen из `.env`) |
| Android `AndroidManifest.xml` | Modify | `intent-filter` для `cookbook://`, `intent-filter` + `assetlinks.json` для HTTPS host из `WEBAPP_URL` |
| iOS `Info.plist`, Runner | Modify | URL scheme `cookbook`, Associated Domains для Universal Links |
| `web/index.html` | Modify при необходимости | Мета, базовый href уже через `--base-href` |
| CI / deploy (GitHub Actions или docs) | Modify | Генерация `404.html` = копия `index.html` под base path |
| `.env` / документация | Modify | Явно описать переменные; при необходимости `APPLE_TEAM_ID` и т.д. только для подписи, не для стора |

## Architecture

### Component Diagram

```
                    ┌─────────────────┐
                    │   .env (build) │
                    └────────┬────────┘
                             │ compile-time or asset load
                             ▼
┌──────────────┐    ┌─────────────────────┐    ┌──────────────────┐
│ OS / Browser │───▶│ Route URI resolver   │───▶│ GoRouter / Shell │
│ (deeplink)   │    │ (normalize path)     │    │ → экраны книги   │
└──────────────┘    └─────────────────────┘    └──────────────────┘
        │                       │
        │ Web mobile            │
        ▼                       ▼
┌──────────────────┐   ┌────────────────────────┐
│ Country hint      │   │ Store URLs from .env    │
│ (browser locale / │──▶│ GOOGLEPLAY / APPSTORE / │
│  Cloudflare CF-   │   │ RUSTORE / RUMARKET      │
│  IPCountry header)│   └────────────────────────┘
└──────────────────┘
```

### Data Flow

1. **Cold start по ссылке**: платформа передаёт начальный URI → нормализация до `RouteLocation` → `GoRouter.go(location)`.
2. **Warm start**: подписка на входящие URI (Android/iOS) → та же нормализация.
3. **Web прямой заход**: `Uri.base.path` относительно `base href` → начальный маршрут.
4. **Install banner**: после первого кадра на web + `!kIsWeb` guard наоборот — только `kIsWeb` && мобильный User-Agent → определить страну → показать виджет с `launchUrl(storeUrl)`.

## Конфигурация (.env)

Использовать существующие ключи:

| Key | Назначение |
|-----|------------|
| `WEBAPP_URL` | Базовый URL веб-сборки **с завершающим slash** (как сейчас). От него вычисляется host и path prefix для Universal/App Links и для проверки относительных путей. |
| `GOOGLEPLAY_URL` | Основной Android-стор для «остального мира» и fallback. |
| `APPSTORE_URL` | iOS App Store (исправить значение, если сейчас заглушка). |
| `RUSTORE_URL` | RuStore. |
| `RUMARKET_URL` | RuMarket / альтернативная витрина для РФ. |

При сборке web: подставлять `WEBAPP_URL` в метаданные или inject в `dart-define` для клиентского кода, если полноценный `.env` на web недоступен в проде.

## Интерфейсы

### Нормализация URI (Dart, концептуально)

```dart
/// Вход: https://host/cookbook/web/recipe/5?q=1
/// или cookbook://recipe/5?q=1
/// Выход: /recipe/5?q=1 (полный location для GoRouter)
String normalizeIncomingUri(Uri uri, {required Uri webBase});
```

Правила:

- Если `uri.scheme == 'cookbook'` (или `https`/`http` и host совпадает с host `WEBAPP_URL`): отбросить scheme/host и общий префикс пути веб-базы (например `/cookbook/web`).
- Неизвестные пути → безопасный fallback `/` или экран «не найдено» с поиском.

### Store resolution (Dart)

```dart
enum StoreVendor { googlePlay, appStore, ruStore, ruMarket }

StoreVendor resolveStoreForCountry(String? iso3166alpha2, {required bool isIOS});

Uri storeUrl(StoreVendor v, EnvStoreUrls env);
```

**Черновик матрицы** (уточнить продуктом):

| Условие | Магазин |
|---------|---------|
| `isIOS` и не РФ/нет спец. правила | `APPSTORE_URL` |
| Android и ISO ∈ {RU, BY, …} по решению продукта | приоритет `RUSTORE_URL` или `RUMARKET_URL` |
| Android прочие | `GOOGLEPLAY_URL` |

Если страна неизвестна: Android → `GOOGLEPLAY_URL`, iOS Safari → `APPSTORE_URL`.

Источники страны (по убыванию надёжности на web):

1. Заголовок ответа страницы `CF-IPCountry` (если включён Cloudflare на том же хосте).
2. `Accept-Language` / `navigator.language` (клиент).
3. Опционально позже: запрос к лёгкому geo-API (не в первой итерации).

## Behavior Specifications

### Happy Path

1. Пользователь открывает `WEBAPP_URL + "chapter/intro"` в браузере на десктопе → видит главу intro.
2. Пользователь открывает ту же ссылку на Android с установленным приложением → открывается приложение на том же логическом экране.
3. Пользователь открывает веб на iPhone → баннер «Открыть в App Store» с `APPSTORE_URL`.

### Edge Cases

| Case | Trigger | Expected Behavior |
|------|---------|-------------------|
| Двойной slash или trailing slash | Некорректный URL | Нормализовать по правилам `path` из RFC |
| Старый hash-url | Пользователь с закладкой `#/foo` | Либо редирект на path-strategy, либо поддержать оба один релиз |
| Приложение не установлено | HTTPS link | Открывается сайт; баннер предлагает установку |
| Неверный deeplink | Неподдерживаемый path | Fallback экран |

### Error Handling

| Error | Cause | Response |
|-------|-------|----------|
| Пустой `.env` в релизе | Конфиг не загружен | Assert/fallback только для debug; в prod — дефолтные URL из compile-time defines |
| Нет браузерного API | Старый WebView | Скрыть баннер или показать generic «Google Play» |

## Dependencies

### Requires

- Определённое дерево маршрутов приложения (экраны книги).
- Доступ к настройке **Digital Asset Links** и **apple-app-site-association** на домене из `WEBAPP_URL`.

### Blocks

- Маркетинговые кампании с финальными URL.

## Integration Points

### External Systems

- Google Play / App Store / RuStore / RuMarket — только как целевые HTTPS URL из `.env`.
- Хостинг статики (GitHub Pages) — `404.html` trick для SPA.

### Internal Systems

- Локализация и темы — без изменений в этой фиче, кроме строк для баннера.

## Testing Strategy

### Unit Tests

- [ ] `normalizeIncomingUri` — таблица кейсов HTTP + cookbook scheme.
- [ ] `resolveStoreForCountry` — ключевые страны и fallback.

### Integration Tests

- [ ] Widget-тест баннера (видимость при заданном User-Agent / mock).

### Manual Verification

- [ ] `adb shell am start -a android.intent.action.VIEW -d "cookbook://..." `
- [ ] iOS Simulator с пользовательским URL.
- [ ] Прямой переход по подпути на задеплоенном web.

## Migration / Rollout

1. Задеплоить `assetlinks.json` и AASA **до** включения жёсткой проверки ссылок.
2. Включить роутинг в приложении, затем обновить сайт с `404.html`.

## Open Design Questions

- [ ] Канонический вид custom URI: `cookbook:///path` vs `cookbook://open/path`.
- [ ] Нужен ли отдельный env-ключ для host Associated Domains, если `WEBAPP_URL` будет редиректить с другого домена.

---

## Approval

- [x] Reviewed by: Product (async / chat)
- [x] Approved on: 2026-05-02
- [x] Notes: Пункты в «Open Design Questions» могут уточняться в ходе имплементации без повторного полного цикла SDD, если не меняют контракт URL.
