# Status: vdd-cookbook-layout-ingredients-replacement

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

- Точка входа: плитка **«Замена ингредиентов»** в **`vdd-cookbook-layout-cook`** (главное меню книги).
- Референс-макет: двухколоночный пергамент, заголовок **ЗАМЕНА ИНГРЕДИЕНТОВ**, маркеры-декор перед блоками, **жирное** название ингредиента, длинные пояснения замен (в т.ч. кокосовое молоко).
- Данные: структурированный список записей `{ title, bodyMarkdown или spans, tags }`; локализация согласована с книгой.

## Связанные потоки

- `flows/vdd-cookbook-layout-cook` — меню книги.
- `flows/vdd-cookbook-layout` — общий ридер (при возврате назад).

## Next Actions

1. Утвердить сценарий мастера (шаги поиска vs одна длинная страница).
2. После approval — имплементация по `04-plan.md`.
