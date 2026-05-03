-- Minimal seed data for first launch

-- Example measures
INSERT INTO content_entries (id, type, category, title, value, sort_order) VALUES 
('m_cup_1_4', 'measure', 'Volume', '1/4 стакана', '60 мл', 1),
('m_cup_1_2', 'measure', 'Volume', '1/2 стакана', '125 мл', 2),
('m_cup_1', 'measure', 'Volume', '1 стакан', '250 мл', 3);

-- Example replacements
INSERT INTO ingredient_replacements (id, ingredient_name, replacement_text) VALUES 
('repl_sugar', 'Рафинированный сахар', 'мёд; агава; тростниковый сахар; нерафинированный кленовый или пальмовый сахар'),
('repl_peanut', 'Арахис', 'кешью или кунжут при аллергии на арахис');

-- Example famous vegetarians
INSERT INTO content_entries (id, type, category, title, sort_order) VALUES 
('fam_pitagor', 'famous_vegetarian', 'Мыслители и писатели', 'Пифагор', 1),
('fam_da_vinci', 'famous_vegetarian', 'Мыслители и писатели', 'Леонардо да Винчи', 2);

-- Main Sections mapping from book.xml analysis
INSERT INTO sections (id, title, start_page, sort_order) VALUES 
('nav_intro', 'Введение', 3, 1),
('nav_replacements', 'Замена ингредиентов', 15, 2),
('nav_measures', 'Меры емкостей', 27, 3), -- Based on XML line 421 corresponds to p27 approx
('nav_cuisine_indian', 'Индийская кухня', 17, 4),
('nav_cuisine_chinese', 'Китайская кухня', 22, 5),
('nav_cuisine_japanese', 'Японская кухня', 25, 6),
('nav_cuisine_thai', 'Тайская кухня', 27, 7);
