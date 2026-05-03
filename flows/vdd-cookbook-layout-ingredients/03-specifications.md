# Спецификации: вкладка «Ингредиенты»

> Версия: 1.1  
> Статус: DRAFT  
> Обновлено: 2026-05-03  
> Визуал: [02-visual.md](./02-visual.md)

## Обзор

Экран реализуется как **вариант состояния** того же маршрута хаба кухни, что и списки рецептов: меняется только `categoryId` (или аналог) на значение **ingredients** для данной `cuisineId`. Тело — список моделей **`IngredientListItem`**, опционально разбитый на страницы.

## Модель данных

```text
IngredientListPage {
  cuisineId: enum { india | china | japan | thailand }
  title: string  // локализованный "ИНГРЕДИЕНТЫ"
  items: List<IngredientListItem>
  pageIndex: int  // 1-based для отображения «N из M»
  pageCount: int
}

IngredientListItem {
  id: string       // стабильный ключ контента
  name: string     // локализованная подпись
  thumbnailAsset: string | null  // путь к изображению
  tasteIds: string[]   // опционально: FK на ref_taste.id
  textureIds: string[] // опционально: FK на ref_guna.id (органолептика + гуны)
}
```

Источник: парсинг XML книги или сгенерированный индекс при сборке; при имплементации не хардкодить полные списки в Dart — только fallback для превью.

---

## БД: seed справочников вкуса и «текстуры» (аюрведа)

Классика: **шад рasa** (шесть вкусов) и **даша гуна** в разрезе **десяти пар** (двадцать полюсов) — стандартная таксономия качеств вещества/пищи (Чарака и др.). Идентификаторы в `snake_case`, стабильные для миграций и JSON.

### DDL (новая миграция; в `001_init.sql` пока нет)

```sql
-- Вкус: шад рasa + расширения приложения (не часть классической шестёрки)
CREATE TABLE IF NOT EXISTS ref_taste (
  id TEXT PRIMARY KEY,
  kind TEXT NOT NULL, -- 'shad_rasa' | 'app_extended'
  sanskrit TEXT,
  name_ru TEXT NOT NULL,
  sort_order INTEGER NOT NULL
);

-- Качество / «текстура и натура» еды: полюса гун (каждый полюс — отдельная строка для тегов)
CREATE TABLE IF NOT EXISTS ref_guna (
  id TEXT PRIMARY KEY,
  pair_code TEXT NOT NULL,
  pole TEXT NOT NULL, -- 'a' | 'b' — два полюса одной пары
  sanskrit TEXT NOT NULL,
  name_ru TEXT NOT NULL,
  sort_order INTEGER NOT NULL
);

-- Связь ингредиент статьи (когда появится таблица статей) — опционально позже
-- CREATE TABLE ingredient_taste (ingredient_id TEXT, taste_id TEXT, PRIMARY KEY (...));
-- CREATE TABLE ingredient_guna (ingredient_id TEXT, guna_id TEXT, PRIMARY KEY (...));
```

### Seed: `ref_taste` — шад рasa + расширения из [02-visual](./02-visual.md)

Шесть вкусов — полный набор **rasa** в аюрведе. Дополнительные строки — для UI/контента книги (умами, копчёность не выводятся из шад рasa однозначно).

```sql
INSERT INTO ref_taste (id, kind, sanskrit, name_ru, sort_order) VALUES
  ('rasa_madhura', 'shad_rasa', 'मधुर', 'сладкий (мадхура)', 1),
  ('rasa_amla',    'shad_rasa', 'अम्ल', 'кислый (амла)', 2),
  ('rasa_lavana',  'shad_rasa', 'लवण', 'солёный (лавана)', 3),
  ('rasa_katu',    'shad_rasa', 'कटु', 'острый, жгучий (кату)', 4),
  ('rasa_tikta',   'shad_rasa', 'तिक्त', 'горький (тикта)', 5),
  ('rasa_kashaya', 'shad_rasa', 'कषाय', 'вяжущий (кашая)', 6),
  ('taste_umami',  'app_extended', NULL, 'умами', 101),
  ('taste_smoky',  'app_extended', NULL, 'копчёный', 102);
```

Соответствие бытовым терминам из визуала: острый → `rasa_katu`; сладкий → `rasa_madhura`; солёный → `rasa_lavana`; кислый → `rasa_amla`; горький → `rasa_tikta`; «вяжущий» (астрингентность, хурма, чай) → `rasa_kashaya`.

### Seed: `ref_guna` — все двадцать полюсов (десять пар)

Пары именованы `pair_*` для группировки в UI («маслянистое—сухое»). Каждая пара — два взаимодополняющих гуны; у ингредиента в тегах может быть один или оба полюса (если продукт смешанного качества), либо только релевантные полюса.

| `pair_code` | Полюс `a` (`id`, санскр., RU) | Полюс `b` (`id`, санскр., RU) |
|-------------|------------------------------|------------------------------|
| `pair_guru_laghu` | guru — гуру (тяжёлый) | laghu — лагху (лёгкий) |
| `pair_manda_tikshna` | manda — манда (тупой, вялый) | tikshna — тикшна (режущий, острый) |
| `pair_hima_ushna` | hima — хима (холодный потенциал) | ushna — ушна (горячий потенциал) |
| `pair_snigdha_ruksha` | snigdha — снигдха (маслянистый, смаз.) | ruksha — рукша (сухой) |
| `pair_slakshna_khara` | slakshna — слакшна (гладкий) | khara — кхара (шершавый) |
| `pair_sandra_drava` | sandra — сандра (плотный, густой) | drava — драва (жидкий) |
| `pair_mridu_kathina` | mridu — мриду (мягкий) | kathina — катхина (твёрдый) |
| `pair_sthula_sukshma` | sthula — стхула (крупный, грубый) | sukshma — сукшма (тонкий) |
| `pair_picchila_vishada` | picchila — пиччхила (слизистый) | vishada — вишада (не слизистый, «чистящий») |
| `pair_sthira_sara` | sthira — стхира (устойчивый) | sara — сара (подвижный, текучий) |

Полный `INSERT`:

```sql
INSERT INTO ref_guna (id, pair_code, pole, sanskrit, name_ru, sort_order) VALUES
  ('guna_guru',     'pair_guru_laghu',       'a', 'गुरु', 'тяжёлый (гуру)', 1),
  ('guna_laghu',    'pair_guru_laghu',       'b', 'लघु', 'лёгкий (лагху)', 2),
  ('guna_manda',    'pair_manda_tikshna',    'a', 'मन्द', 'тупой, вялый (манда)', 3),
  ('guna_tikshna',  'pair_manda_tikshna',    'b', 'तीक्ष्ण', 'режущий, острый (тикшна)', 4),
  ('guna_hima',     'pair_hima_ushna',       'a', 'हिम', 'холодный по потенции (хима / шита)', 5),
  ('guna_ushna',    'pair_hima_ushna',       'b', 'उष्ण', 'горячий по потенции (ушна)', 6),
  ('guna_snigdha',  'pair_snigdha_ruksha',   'a', 'स्निग्ध', 'маслянистый, смаз. (снигдха)', 7),
  ('guna_ruksha',   'pair_snigdha_ruksha',   'b', 'रूक्ष', 'сухой (рукша)', 8),
  ('guna_slakshna', 'pair_slakshna_khara',   'a', 'श्लक्ष्ण', 'гладкий (слакшна)', 9),
  ('guna_khara',    'pair_slakshna_khara',   'b', 'खर', 'шершавый (кхара)', 10),
  ('guna_sandra',   'pair_sandra_drava',     'a', 'सान्द्र', 'плотный, густой (сандра)', 11),
  ('guna_drava',    'pair_sandra_drava',     'b', 'द्रव', 'жидкий (драва)', 12),
  ('guna_mridu',    'pair_mridu_kathina',    'a', 'मृदु', 'мягкий (мриду)', 13),
  ('guna_kathina',  'pair_mridu_kathina',    'b', 'कठिन', 'твёрдый (катхина)', 14),
  ('guna_sthula',   'pair_sthula_sukshma',   'a', 'स्थूल', 'крупный, грубый (стхула)', 15),
  ('guna_sukshma',  'pair_sthula_sukshma',   'b', 'सूक्ष्म', 'тонкий (сукшма)', 16),
  ('guna_picchila', 'pair_picchila_vishada', 'a', 'पिच्छिल', 'слизистый (пиччхила)', 17),
  ('guna_vishada',  'pair_picchila_vishada', 'b', 'विशद', 'не слизистый (вишада)', 18),
  ('guna_sthira',   'pair_sthira_sara',      'a', 'स्थिर', 'устойчивый (стхира)', 19),
  ('guna_sara',     'pair_sthira_sara',      'b', 'सर', 'подвижный, текучий (сара)', 20);
```

### Органолептика во рту (не гуны классики)

Хрустящая, нежная, **упругая** (пример: вегетарианская селедка / сыр «косичка») и т. п. из визуала — отдельный справочник `ref_mouthfeel` (отдельная миграция), чтобы не смешивать с `ref_guna`. При необходимости связь `ingredient_mouthfeel`.

### Правила использования в seed контента

- Для строгой аюрведы в выборках использовать `kind = 'shad_rasa'` и только `ref_guna`.
- Фильтры «острый как перец» vs «острый как нож» разводить: вкус `rasa_katu`, качество режущее — `guna_tikshna` (пара манда—тикшна).
- Температура блюда в °C и «ушна/хима» — разные оси; в БД явно подписывать UI: «по потенции (аюрведа)».

## Маршрутизация

Рекомендуемый паттерн (согласовать с `vdd-cookbook-layout-cook`):

- `/book/cuisine/:cuisineId/tab/:tabId` где `tabId` для всех кухонь включает **`ingredients`**.
- Опционально query: `?page=2` для глубоких ссылок на вторую страницу списка.

Переход из других вкладок того же хаба — **без** сброса стека, только обновление состояния вкладки и загрузка модели.

## UI-компоненты

| Компонент | Примечание |
|-----------|------------|
| `RegionalCuisineShell` | Из `vdd-cookbook-layout-cook`; `activeTab = ingredients`. |
| `CookbookGridCard` | Тот же виджет, что для блюд; опционально другой `semanticLabel`. |
| `PaginationBar` | Показывать iff `pageCount > 1`; обновляет query-параметр или state. |

## Поведение

- **Тап по карточке**: по умолчанию без действия (до утверждения открытого вопроса в требованиях); можно поглощать тап, чтобы не дублировать навигацию.
- **Системная кнопка «Назад»**: к предыдущему экрану приложения (обычно другая вкладка или меню книги).

## Тестирование

- Golden: пергамент + сетка 3 колонки для одной кухни и локали `ru`.
- Widget: пагинация меняет `pageIndex` и список `items`.

---

## Утверждение

- [ ] Проверил(а):
- [ ] Дата:
- [ ] Примечания:
