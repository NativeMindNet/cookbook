-- Initial database schema for Cookbook

-- Book Sections (Introduction, Chapters, etc.)
CREATE TABLE IF NOT EXISTS sections (
    id TEXT PRIMARY KEY,
    title TEXT,
    start_page INTEGER,
    parent_id TEXT,
    sort_order INTEGER,
    FOREIGN KEY (parent_id) REFERENCES sections(id)
);

-- Recipes and Ingredients from hubs
CREATE TABLE IF NOT EXISTS recipes (
    id TEXT PRIMARY KEY,
    title TEXT,
    cuisine TEXT,
    category TEXT, -- 'main', 'salad', 'soup', 'dessert', 'ingredient'
    page_number INTEGER
);

-- Ingredient Replacements
CREATE TABLE IF NOT EXISTS ingredient_replacements (
    id TEXT PRIMARY KEY,
    ingredient_name TEXT NOT NULL,
    replacement_text TEXT NOT NULL,
    context TEXT -- e.g., 'Thai cuisine'
);

-- Generic content for lists like 'Famous Vegetarians' or 'Measures'
CREATE TABLE IF NOT EXISTS content_entries (
    id TEXT PRIMARY KEY,
    type TEXT NOT NULL, -- 'famous_vegetarian', 'measure'
    category TEXT, -- e.g., 'Thinkers', 'Volume'
    title TEXT NOT NULL,
    subtitle TEXT,
    value TEXT, -- used for measures (e.g., '250 ml')
    sort_order INTEGER
);

-- User bookmarks
CREATE TABLE IF NOT EXISTS bookmarks (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    page_number INTEGER NOT NULL,
    title TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
