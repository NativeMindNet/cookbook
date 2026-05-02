# Implementation Log: cookbook-route-deeplink

> Started: 2026-05-02  
> Plan: [03-plan.md](./03-plan.md) (approved 2026-05-02)

## Preconditions

- Requirements, specifications, and plan approved on 2026-05-02 (chat).

## Progress Tracker

| Task | Status | Notes |
|------|--------|-------|
| 1.1 Dependencies and env | Done | `go_router`, `app_links`, `flutter_dotenv`, `url_launcher`, `flutter_web_plugins`; asset `.env` |
| 1.2 AppConfig | Done | `lib/config/app_config.dart` |
| 2.1 GoRouter | Done | `lib/router/app_router.dart`, screens under `lib/screens/` |
| 2.2 Deep link handler | Done | `lib/router/deep_link_listener.dart`, initial link in `main.dart` |
| 3.1 Android | Done | `AndroidManifest.xml` — https App Links + `cookbook` scheme |
| 3.2 iOS | Done | URL scheme, `Runner.entitlements` + `CODE_SIGN_ENTITLEMENTS`, queries schemes |
| 3.3 Web path + 404.html | Done | `usePathUrlStrategy()`, `tool/copy_web_404_for_github_pages.sh` |
| 4.1 Install prompt | Done | `lib/widgets/install_app_prompt.dart`, locale-based store pick |
| 4.2 Tests | Done | `test/uri_resolver_test.dart`, smoke `widget_test.dart` |

## Session Log

### Session 2026-05-02

**Completed**

- Единая нормализация URI: `lib/router/uri_resolver.dart` (https + `cookbook:`).
- Корень приложения: `CookbookRoot` + `MaterialApp.router`; на web внизу `InstallAppPrompt`.
- Пример маршрута контента: `/page/:pageId` (заглушка до подключения читалки).
- `.env.example` с корректным плейсхолдером App Store.

**Deviations**

- `RUMARKET_URL` загружается в `AppConfig`, но выбор стора для региона пока: RuStore для RU/BY/KZ на Android-web; расширение матрицы без смены контракта env.
- Файлы `assetlinks.json` / AASA не добавлены в репозиторий: их нужно выложить на **корень** `github.io` (см. `_status.md`), иначе Android/iOS не подтвердят App Links.

**Verification**

- `flutter test`, `dart analyze lib test`, `flutter build apk --debug`, `flutter build web --base-href /cookbook/web/`.

## Deviations Summary

| Planned | Actual | Reason |
|---------|--------|--------|
| RuMarket в матрице | Только RuStore для CIS Android-web | Упростить первую версию; URL остаётся в config |

## Learnings

- Для GitHub Pages при path-стратегии обязательно копировать `index.html` → `404.html` после сборки.

## Completion Checklist

- [x] All tasks completed or explicitly deferred
- [x] Tests passing
- [x] No regressions (counter demo заменён рабочим каркасом приложения)
- [ ] `assetlinks.json` / `apple-app-site-association` опубликованы на хосте (вне репозитория / вручную на корне домена)
- [x] Status updated in `_status.md`
