# Status: sdd-cookbook-content

## Current Phase

IMPLEMENTATION

## Phase Status

CONTENT_PACKAGE

## Last Updated

2026-05-03 — пакет `data/assets/` ↔ `app/cookbook/assets/data/catalog/`: рецепты индийских основных **067–078** (скрины) в `indian_main_recipes.json`, маппинг в `book_xml_mapping_indian_mains.json`, заглушки §14.6 для **043–044** в `indian_ingredient_articles.json` и `book_xml_mapping_indian_ingredients.json`

## Blockers

- Нет

## Progress

- [x] Requirements drafted
- [x] Requirements approved
- [x] Specifications drafted (каталог сущностей из референс-макетов + §13 хабы кухонь по скринам приложения)
- [x] Specifications approved
- [x] Plan drafted
- [ ] Plan approved
- [x] Implementation started (`data/assets/` заполнен)
- [x] Implementation complete (каталог JSON + маппинг `037`–`044` + основные рецепты `067`–`078`)

## Context Notes

- Источник инвентаризации: **скрины приложения** и **сканы печатной книги** (PNG в `.cursor/projects/.../assets/` и макеты в потоках VDD).
- Цель потока: зафиксировать **именования разделов, тем оглавления, таблицу мер и инлайн-меры (§7.4), блок замены ингредиентов, категории знаменитых вегетарианцев**, **вкладки и списки блюд/ингредиентов региональных хабов** (§13), а также **статьи ингредиентов Индии по сканам** (§14, `ing.book.indian.*`) для сверки с `book.xml` и VDD.
- **Данные:** корень `data/assets/` → симлинк на `app/cookbook/assets/data/catalog/`; свод §13 в **`cuisine_hubs.json`**, индекс пакета — **`catalog_index.json`**.

## Next Actions

1. При необходимости утвердить `03-plan.md` / связку с админкой (Supabase JSONB или экспорт в assets).
2. Импорт в SQLite по §11a: чтение `catalog_index.json` и связанных файлов.
