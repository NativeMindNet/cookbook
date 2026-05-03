# Requirements: Database Integration

## Goal
Implement a robust SQLite-based data layer to replace placeholder data in the `BookBloc` and provide searchable, categorized access to all 219 recipes, ingredients, and reference lists.

## Functional Requirements
1. **Auto-Initialization**: Upon first launch, the app must create the SQLite database using `001_init.sql`.
2. **Data Seeding**: Populate the database from `001_seed.sql` and additional JSON files (`replacements.json`, etc.) if the database is fresh.
3. **Reactive Integration**: `BookBloc` must fetch real data from the database instead of using hardcoded placeholders.
4. **Cuisine & Category Filtering**: Support fetching recipes by cuisine (e.g., 'thai') and category (e.g., 'soup').
5. **Bookmark Persistence**: Allow users to save/remove bookmarks with persistence across app restarts.
6. **Error Handling**: Graceful handling of database file issues or migration failures.

## Acceptance Criteria
- App starts without errors and performs the initial migration.
- The "Main Menu" sections correctly navigate to pages mapped in the DB.
- Recipe lists in the UI (hubs) display actual names from the database.
- Bookmarks state is preserved in the database.
