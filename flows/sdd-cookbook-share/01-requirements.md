# Requirements: cookbook-share

> Version: 1.0  
> Status: DRAFT  
> Last Updated: 2026-05-03

## Problem Statement

Пользователи хотят отправить собеседнику ссылку на тот же экран книги (страница, поиск, закладки) так, чтобы получатель открыл **веб-версию** в браузере с тем же контекстом (путь и при необходимости query). Сейчас нет единого UI для копирования/отправки такой ссылки из приложения. Базовый URL сайта задаётся в `.env` (`WEBAPP_URL`), его нельзя дублировать в коде.

## User Stories

### Primary

**As a** читатель  
**I want** на любом экране приложения нажать «Поделиться» и получить ссылку на веб-версию с текущими аргументами маршрута  
**So that** я могу отправить её в мессенджер или почту, и открывший увидит тот же раздел на сайте

### Secondary

**As a** пользователь веб-версии (или получатель ссылки)  
**I want** чтобы URL совпадал с правилами deeplink / роутера приложения  
**So that** поведение сайта и приложения согласовано (один «логический» location)

## Acceptance Criteria

### Must Have

1. **Given** пользователь на экране с известным маршрутом (`/book`, `/book/:pageIndex`, `/search`, `/bookmarks` и т.д. по мере расширения роутера)  
   **When** он нажимает «Поделиться»  
   **Then** открывается системный share (или эквивалент) с **полным HTTPS-URL**, составленным из `AppConfig.webAppBaseUri` + path prefix + текущий `location` (path + query), без ручного хардкода хоста

2. **Given** текущий маршрут содержит query-параметры  
   **When** пользователь делится ссылкой  
   **Then** query сохраняется в URL так же, как в `GoRouter` state (если параметры есть в location)

3. **Given** разные окружения / `.env` с разным `WEBAPP_URL`  
   **When** формируется ссылка  
   **Then** используется только конфигурация из приложения (как для deeplink), без второго источника правды

4. **Given** любой основной экран приложения (где есть осмысленный контент для шаринга)  
   **When** открыт UI  
   **Then** доступна кнопка или действие «Поделиться» в едином стиле с остальным приложением (размещение: AppBar / общий shell — зафиксировать в спецификации)

### Should Have

- На **web** (Flutter Web): «Поделиться» через Web Share API или копирование URL в буфер, если системный share недоступен.
- Короткий подзаголовок / превью-текст в share sheet (например название приложения), без утечки PII.

### Won't Have (This Iteration)

- Серверные короткие ссылки (bit.ly и т.п.).
- Шаринг изображений / PDF страницы — только URL.
- Персональные токены или секреты в URL.

## Constraints

- **Technical**: Flutter `app/cookbook`; `go_router`; `AppConfig` / `UriResolver` из потока route-deeplink.
- **Platform**: iOS и Android — `share_plus` или платформенный канал; Web — см. Should Have.
- **Consistency**: Формат публичного URL должен быть обратим к тому же `location`, что ожидает `UriResolver.normalizeToLocation` для HTTPS-ссылок с хостом из `WEBAPP_URL`.

## Open Questions

- [ ] Экран **splash** (`/`): показывать «Поделиться» (на что вести — `/book`?) или скрывать до перехода на книгу.
- [ ] **Unknown route** / ошибка роутера: шарить текущий «сырой» URI или не показывать кнопку.
- [ ] Локализация строки «Поделиться» (RU/EN) — взять из существующих ARB или добавить ключи.

## References

- `flows/sdd-cookbook-route-deeplink/02-specifications.md` — модель URL и префикс веба.
- `app/cookbook/lib/config/app_config.dart` — `webAppBaseUri`, `webPathPrefix`.
- `app/cookbook/lib/router/uri_resolver.dart` — нормализация входящих HTTPS → location.
- `app/cookbook/lib/router/app_router.dart` — список маршрутов.

---

## Approval

- [ ] Reviewed by:
- [ ] Approved on:
- [ ] Notes:
