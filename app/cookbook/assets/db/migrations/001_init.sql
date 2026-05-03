-- Cookbook Database Schema v1.2
-- Optimized for typed data access

-- 1. Navigation & Structure
CREATE TABLE IF NOT EXISTS sections (
    id TEXT PRIMARY KEY,
    title TEXT NOT NULL,
    start_page INTEGER,
    parent_id TEXT,
    sort_order INTEGER,
    FOREIGN KEY (parent_id) REFERENCES sections(id)
);

-- 2. Recipes (The Core Catalog)
CREATE TABLE IF NOT EXISTS recipes (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    title TEXT NOT NULL,
    cuisine TEXT NOT NULL, -- 'indian', 'chinese', 'japanese', 'thai'
    category TEXT NOT NULL, -- 'main', 'salad', 'soup', 'dessert', 'curry', 'snack', 'sauce', 'drink', 'ingredient'
    ingredients TEXT, -- CSV or descriptive string
    cooking_time TEXT,
    page_number INTEGER
);

-- 3. Ingredient Replacements
CREATE TABLE IF NOT EXISTS ingredient_replacements (
    id TEXT PRIMARY KEY,
    ingredient_name TEXT NOT NULL,
    replacement_text TEXT NOT NULL,
    context TEXT,
    description TEXT,
    disclaimer TEXT
);

-- 4. Famous Vegetarians
CREATE TABLE IF NOT EXISTS famous_vegetarians (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    category TEXT NOT NULL,
    name TEXT NOT NULL,
    sort_order INTEGER
);

-- 5. Measures & Conversion
CREATE TABLE IF NOT EXISTS measures_volumes (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    unit TEXT NOT NULL,
    value TEXT NOT NULL,
    sort_order INTEGER
);

CREATE TABLE IF NOT EXISTS measures_products (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT NOT NULL,
    weight TEXT NOT NULL,
    sort_order INTEGER
);

-- 6. User Data
CREATE TABLE IF NOT EXISTS bookmarks (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    page_number INTEGER NOT NULL,
    title TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 7. Ingredient taxonomy: Ayurvedic rasa + app extensions
CREATE TABLE IF NOT EXISTS ref_taste (
    id TEXT PRIMARY KEY,
    kind TEXT NOT NULL,
    sanskrit TEXT,
    name_ru TEXT NOT NULL,
    sort_order INTEGER NOT NULL
);

-- 8. Dashavidha gunas (20 poles, 10 pairs) for ingredient / food tagging
CREATE TABLE IF NOT EXISTS ref_guna (
    id TEXT PRIMARY KEY,
    pair_code TEXT NOT NULL,
    pole TEXT NOT NULL,
    sanskrit TEXT NOT NULL,
    name_ru TEXT NOT NULL,
    sort_order INTEGER NOT NULL
);

-- 9. Mouthfeel (organoleptic) — separate from classical gunas
CREATE TABLE IF NOT EXISTS ref_mouthfeel (
    id TEXT PRIMARY KEY,
    name_ru TEXT NOT NULL,
    sort_order INTEGER NOT NULL
);
