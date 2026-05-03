# Specifications: Database Architecture

## 1. Components

### 1.1 `DatabaseService`
- **Path**: `lib/services/database_service.dart`
- **Role**: Singleton to manage `sqflite` database lifecycle.
- **Methods**:
    - `init()`: Opens the DB, runs `001_init.sql` from assets.
    - `seed()`: Executes `001_seed.sql`.
    - `db`: Getter for the `Database` instance.

### 1.2 `BookRepository`
- **Path**: `lib/services/book_repository.dart`
- **Role**: Data access layer for recipes, sections, and references.
- **Methods**:
    - `getSections()`: Fetches all top-level book sections.
    - `getRecipes(String cuisine, String category)`: Fetches filtered recipes.
    - `getReplacements()`: Fetches from `ingredient_replacements`.
    - `getMeasures()`: Fetches from `measures_volumes` and `measures_products`.

### 1.3 `BookBloc` Integration
- Replace `_createPlaceholderBook()` with a call to `BookRepository`.
- `BookLoadRequested` will trigger `repository.getSections()`.

## 2. Migration & Seeding Logic
1. Check if database file exists.
2. If not:
    - Load `001_init.sql` string from assets.
    - Split by `;` and execute each statement.
    - Load `001_seed.sql` and execute.
    - (Optional) Load JSONs and insert into corresponding tables.

## 3. Data Mapping (Main Menu)
- **Introduction** -> Section `nav_intro` (Page 3).
- **Replacements** -> Section `nav_replacements` (Page 15).
- **Measures** -> Section `nav_measures` (Page 27).
- **Cuisines** -> Map to `nav_cuisine_*` sections.
