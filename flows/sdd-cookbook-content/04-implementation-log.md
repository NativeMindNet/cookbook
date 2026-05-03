# Журнал реализации: sdd-cookbook-content

> План: [03-plan.md](./03-plan.md)

## Прогресс

| Задача | Статус | Примечание |
|--------|--------|------------|
| Каталог в `02-specifications.md` | Done | 2026-05-02: сохранено по референс-макетам |
| Маппинг book.xml | Done | §14 индийские ингредиенты ↔ `037.png`–`044.png`, `book_xml_mapping_indian_ingredients.json` |
| `data/assets` / `catalog/cuisine_hubs.json` | Done | 2026-05-03: свод §13 + запись в `catalog_index.json`, README в catalog |
| Каталог `assets/data/catalog/*.json` | Done | 2026-05-03 |
| `indian_main_recipes.json` + `book_xml_mapping_indian_mains.json` + `manifest.json` | Done | 2026-05-03: тексты по сканам, связь с `079.png`–`091.png` |
| Индийские основные 067–078 + §14.6 (043–044) | Done | 2026-05-03: prepend рецептов по скринам, маппинг `book.xml`, статьи-заглушки панир/чатни |

## Сессии

### 2026-05-03 (шестая итерация)

- В начало **`indian_main_recipes.json`** добавлены 12 рецептов (**067.png**–**078.png**): Мору расам, Дал, Рава упма, баклажаны с тофу, тушеный нут, зелень с кокосовым рисом, плов с томатом и кешью, хайдарабад брияни, махарани-дал, амритсари-дал, чоле (состав без шагов на скрине), рагу из нута с тамариндом.
- **`book_xml_mapping_indian_mains.json`**: строки `bookXmlLineApprox` для привязки к секциям `book.xml`.
- **`indian_ingredient_articles.json`**: `ing.book.indian.paneer`, `tomato_chutney`, `mint_chutney` (stub); **`book_xml_mapping_indian_ingredients.json`**: статьи на **043**–**044**.

### 2026-05-03 (пятая итерация)

- Перезаполнен **`indian_main_recipes.json`**: полные ингредиенты и шаги по сканам для 079–090 (кроме заглушки «Вегетарианская кима»), частично «Фаршированный картофель», только ингредиенты «Фаршированная горькая тыква», доп. рецепт «Фаршированная тыква (сладкая)» из печатного разворота.
- Добавлены **`book_xml_mapping_indian_mains.json`** и обновлён **`manifest.json`** (в т.ч. `chinese_recipes.json`).

### 2026-05-03 (четвёртая итерация)

- Доведён пакет до соответствия `manifest.json`: добавлены `content_navigation_map.json`, `nav_main_menu.json`, `scan_references.json`, `book_xml_mapping_indian_ingredients.json`, копия `replacements.json` из `ingredient_replacements.json`.
- Добавлен отсутствующий в индексе `indian_main_recipes.json` (заголовки и summary из `book.xml` для 079–091, плюс stub для «фаршированная тыква» по `book_xml_mapping_indian_mains.json`).
- В `catalog_index.json` зарегистрированы новые бандлы для рантайма/импорта.

### 2026-05-03

- Добавлены машиночитаемые JSON по `02-specifications.md`: обложка, меню, оглавление введения, меры, инлайн-меры, замены ингредиентов, знаменитые вегетарианцы, диета/питательность, духовность, хабы кухонь (индийская/китайская/японская/тайская), полные статьи `ing.book.indian.*`.
- Симлинк репозитория: `data/assets` → `app/cookbook/assets/data/catalog`.
- **`cuisine_hubs.json`**: сводный пакет §13 (вкладки, секции, пагинация, списки карточек по всем четырём кухням); зарегистрирован в `catalog_index.json`; в catalog добавлен `README.md`; в §11a спецификации зафиксирован путь `data/assets` ↔ `catalog/`.

### 2026-05-02

Создан поток SDD; детальная спецификация контента из приложенных изображений записана в `02-specifications.md`.

### 2026-05-02 (вторая итерация)

В `02-specifications.md` (v1.2): **§1.1** — таблица «носитель кадра → раздел спеки»; **§7.4** — инлайн-меры и количественные выражения; **§14** — печатные развороты «Индийская кухня / ИНГРЕДИЕНТЫ» (шапка, декор, шаблоны вёрстки, индекс `ing.book.indian.*`, полные русские тексты, сверка с 24 карточками приложения). Таксономия §11 дополнена сущностями книжного разворота и статей.

### 2026-05-03

Создан каталог **`data/assets/`** в корне репозитория: `manifest.json`, карта носителей, оглавление введения, главное меню, инлайн-меры, **21 статья** в `indian_ingredient_articles.json`, маппинг к секции `book.xml` и фонам `037.png`–`044.png` (`book_xml_mapping_indian_ingredients.json`), ссылки на PNG сканов, копии `measures.json` / `replacements.json` / `famous_vegetarians.json`. В **§12** спецификации добавлена строка про `data/assets/`.

### 2026-05-03

Проведен анализ `book.xml` и начат маппинг контента на структуру XML:
- Подтверждено, что `book.xml` использует позиционную индексацию страниц.
- `nav.introduction` (Введение) -> страница 3 (согласно `arg` в меню).
- `nav.ingredient_replacement` (Замена ингредиентов) -> страница 15.
- `reference.measures` (Меры емкостей) -> страница, соответствующая `006.png` (линия 421 в XML).
- Ингредиенты Индийской кухни (§13.1, §14) начинаются с линии 4668, используя изображения `037.png`–`042.png`, что соответствует спекам.
- Замечено, что многие страницы (например, "Знаменитые вегетарианцы") не имеют текстового представления в XML и полагаются на фоновые изображения, что подтверждает важность каталога в `02-specifications.md` как источника для поиска и индексации.

### 2026-05-03 (вторая итерация)

- Добавлена спецификация гибридного хранения данных (§11a в `02-specifications.md`).
- Создана структура для SQLite миграций и сидов:
  - `assets/db/migrations/001_init.sql`: таблицы `sections`, `recipes`, `ingredient_replacements`, `content_entries`, `bookmarks`.
  - `assets/db/seeds/001_seed.sql`: примеры мер, замен и знаменитостей.
- Обновлен `pubspec.yaml`:
  - Добавлены зависимости `sqflite` и `path`.
  - Зарегистрированы ассеты в папках `assets/db/migrations/` и `assets/db/seeds/`.
- Выполнено `flutter pub get`.

### 2026-05-03 (четвёртая итерация)

- Добавлен **`chinese_recipes.json`**: 16 полных рецептов китайской кухни; поля выровнены с **`indian_main_recipes.json`** (`titleRu`, `parchmentSection`, `timeRu`, `yieldRu`, `ingredientGroups[].label` / `rows[]` с `nameRu`/`amountRu`, `steps`, опционально `introRu`, `referenceImage`, `cuisineBannerRu`, `hubTabTitle`). Индекс: **`catalog_index.json`** → `recipe.book.chinese.*`; **`manifest.json`**.

### 2026-05-03 (третья итерация)

- Наполнены SQL сиды и JSON файлы данными из спецификаций:
  - `001_seed.sql`: добавлены основные разделы книги с маппингом на страницы `book.xml`.
  - `assets/data/replacements.json`: справочник замен (§10).
  - `assets/data/famous_vegetarians.json`: список знаменитостей по категориям (§9).
  - `assets/data/measures.json`: таблицы мер объемов и весов (§7).
