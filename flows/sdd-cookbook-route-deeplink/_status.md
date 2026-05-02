# Status: sdd-cookbook-route-deeplink

## Current Phase

SPECIFICATIONS

## Phase Status

DRAFTING

## Last Updated

2026-05-02

## Blockers

- None

## Progress

- [x] Requirements drafted
- [ ] Requirements approved
- [x] Specifications drafted
- [ ] Specifications approved
- [x] Plan drafted
- [ ] Plan approved
- [ ] Implementation started
- [ ] Implementation complete

## Context Notes

- Источник URL стора и веб-базы: `app/cookbook/.env` (`WEBAPP_URL`, `APPSTORE_URL`, `GOOGLEPLAY_URL`, `RUSTORE_URL`, `RUMARKET_URL`).
- Кастомная схема приложения: `cookbook`.
- Хостинг веба по `.env`: GitHub Pages под подпутём `/cookbook/web/` — для path-based роутинга на статике нужен fallback (например `404.html` → `index.html` или hash-стратегия).

## Next Actions

1. Утвердить `01-requirements.md`.
2. Утвердить `02-specifications.md` и при необходимости поправить маппинг страна→стор.
3. После «plan approved» — реализация по `03-plan.md`.
