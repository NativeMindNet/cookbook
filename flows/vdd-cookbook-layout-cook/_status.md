# Status: vdd-cookbook-layout-cook

## Current Phase

REVIEW (черновики requirements → plan готовы к утверждению)

## Phase Status

DRAFTING

## Last Updated

2026-05-02

## Blockers

- Нет

## Progress

- [x] Requirements drafted
- [ ] Requirements approved
- [x] Visual mockups drafted
- [ ] Visual approved
- [x] Specifications drafted
- [ ] Specifications approved
- [x] Plan drafted
- [ ] Plan approved
- [ ] Implementation started
- [ ] Implementation complete
- [ ] Documentation drafted
- [ ] Documentation approved

## Context Notes

- Дополняет базовый поток **`flows/vdd-cookbook-layout`** (ридер страниц, поиск, закладки): здесь зафиксированы **именно оболочки и раскладки «книги Востока»** по референсным макетам (RU).
- Экраны **хаба кухни** (вкладки + сетка блюд/секций по макетам из скринов) дополняют оболочку; специфика вкладки **«Ингредиенты»** как регионального справочника — в **`flows/vdd-cookbook-layout-ingredients`**.
- Экран **«Замена ингредиентов»** как мастер описан в **`flows/vdd-cookbook-layout-ingredients-replacement`** (точка входа с плитки главного меню книги).
- Визуальный код: бордо/золото, пергамент, бамбук, орнаменты; шрифт — контраст декоративных заголовков и читабельного основного текста.

## Связанные потоки

- `flows/vdd-cookbook-layout` — технический ридер и платформы.
- `flows/vdd-cookbook-layout-ingredients` — вкладка «Ингредиенты» в разделе кухни (миниатюра + название).
- `flows/vdd-cookbook-layout-ingredients-replacement` — мастер замены ингредиентов.

## Next Actions

1. Утвердить требования и ASCII в `02-visual.md`.
2. После approval — реализация по `04-plan.md` поверх существующего Flutter-проекта.
