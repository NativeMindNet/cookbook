# Status: sdd-cookbook-route-deeplink

## Current Phase

IMPLEMENTATION

## Phase Status

APPROVED

## Last Updated

2026-05-02 — implementation landed (routing, deeplink, web install prompt)

## Blockers

- None

## Progress

- [x] Requirements drafted
- [x] Requirements approved
- [x] Specifications drafted
- [x] Specifications approved
- [x] Plan drafted
- [x] Plan approved
- [x] Implementation started
- [x] Implementation complete (hosting verification: publish assetlinks + AASA at domain root)

## Context Notes

- Источник URL стора и веб-базы: `app/cookbook/.env` (`WEBAPP_URL`, `APPSTORE_URL`, `GOOGLEPLAY_URL`, `RUSTORE_URL`, `RUMARKET_URL`).
- Кастомная схема приложения: `cookbook`.
- Хостинг веба по `.env`: GitHub Pages под подпутём `/cookbook/web/` — для path-based роутинга на статике нужен fallback (например `404.html` → `index.html` или hash-стратегия).

## Next Actions

1. Опубликовать на **корне** хоста `nativemindnet.github.io` файлы `.well-known/assetlinks.json` и `.well-known/apple-app-site-association` (не под `/cookbook/web/`).
2. После `flutter build web --base-href /cookbook/web/` выполнить `tool/copy_web_404_for_github_pages.sh`.
3. Заменить `APPSTORE_URL` в `.env` на реальную ссылку App Store перед релизом iOS.
