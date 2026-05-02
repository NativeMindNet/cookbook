# Status: vdd-cookbook-layout-ingredients

## Current Phase

REVIEW (черновики готовы к утверждению)

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

## Context Notes

- Экран входит в **`RegionalCuisineShell`** из `vdd-cookbook-layout-cook`; отличается только активной вкладкой, заголовком **ИНГРЕДИЕНТЫ** и источником данных (ингредиенты региона, не рецепты).
- На референсах у Тайланда и части списков есть **пагинация** («1 из 2», «2 из 2» и т.д.) — поддерживается данными (`pageIndex`, `pageCount`).
- Не смешивать с мастером **`vdd-cookbook-layout-ingredients-replacement`**.

## Связанные потоки

- `flows/vdd-cookbook-layout-cook/`
- `flows/vdd-cookbook-layout-ingredients-replacement/`

## Next Actions

1. Утвердить требования и визуал.
2. Связать индексы контента XML с табами «Ингредиенты» по каждой кухне.
