-- Upgrade v1 -> v2: sensory taxonomy tables + seed (idempotent)

CREATE TABLE IF NOT EXISTS ref_taste (
    id TEXT PRIMARY KEY,
    kind TEXT NOT NULL,
    sanskrit TEXT,
    name_ru TEXT NOT NULL,
    sort_order INTEGER NOT NULL
);

CREATE TABLE IF NOT EXISTS ref_guna (
    id TEXT PRIMARY KEY,
    pair_code TEXT NOT NULL,
    pole TEXT NOT NULL,
    sanskrit TEXT NOT NULL,
    name_ru TEXT NOT NULL,
    sort_order INTEGER NOT NULL
);

CREATE TABLE IF NOT EXISTS ref_mouthfeel (
    id TEXT PRIMARY KEY,
    name_ru TEXT NOT NULL,
    sort_order INTEGER NOT NULL
);

INSERT OR IGNORE INTO ref_taste (id, kind, sanskrit, name_ru, sort_order) VALUES
('rasa_madhura', 'shad_rasa', 'मधुर', 'сладкий (мадхура)', 1),
('rasa_amla', 'shad_rasa', 'अम्ल', 'кислый (амла)', 2),
('rasa_lavana', 'shad_rasa', 'लवण', 'солёный (лавана)', 3),
('rasa_katu', 'shad_rasa', 'कटु', 'острый, жгучий (кату)', 4),
('rasa_tikta', 'shad_rasa', 'तिक्त', 'горький (тикта)', 5),
('rasa_kashaya', 'shad_rasa', 'कषाय', 'вяжущий (кашая)', 6),
('taste_umami', 'app_extended', NULL, 'умами', 101),
('taste_smoky', 'app_extended', NULL, 'копчёный', 102);

INSERT OR IGNORE INTO ref_guna (id, pair_code, pole, sanskrit, name_ru, sort_order) VALUES
('guna_guru', 'pair_guru_laghu', 'a', 'गुरु', 'тяжёлый (гуру)', 1),
('guna_laghu', 'pair_guru_laghu', 'b', 'लघु', 'лёгкий (лагху)', 2),
('guna_manda', 'pair_manda_tikshna', 'a', 'मन्द', 'тупой, вялый (манда)', 3),
('guna_tikshna', 'pair_manda_tikshna', 'b', 'तीक्ष्ण', 'режущий, острый (тикшна)', 4),
('guna_hima', 'pair_hima_ushna', 'a', 'हिम', 'холодный по потенции (хима / шита)', 5),
('guna_ushna', 'pair_hima_ushna', 'b', 'उष्ण', 'горячий по потенции (ушна)', 6),
('guna_snigdha', 'pair_snigdha_ruksha', 'a', 'स्निग्ध', 'маслянистый, смаз. (снигдха)', 7),
('guna_ruksha', 'pair_snigdha_ruksha', 'b', 'रूक्ष', 'сухой (рукша)', 8),
('guna_slakshna', 'pair_slakshna_khara', 'a', 'श्लक्ष्ण', 'гладкий (слакшна)', 9),
('guna_khara', 'pair_slakshna_khara', 'b', 'खर', 'шершавый (кхара)', 10),
('guna_sandra', 'pair_sandra_drava', 'a', 'सान्द्र', 'плотный, густой (сандра)', 11),
('guna_drava', 'pair_sandra_drava', 'b', 'द्रव', 'жидкий (драва)', 12),
('guna_mridu', 'pair_mridu_kathina', 'a', 'मृदु', 'мягкий (мриду)', 13),
('guna_kathina', 'pair_mridu_kathina', 'b', 'कठिन', 'твёрдый (катхина)', 14),
('guna_sthula', 'pair_sthula_sukshma', 'a', 'स्थूल', 'крупный, грубый (стхула)', 15),
('guna_sukshma', 'pair_sthula_sukshma', 'b', 'सूक्ष्म', 'тонкий (сукшма)', 16),
('guna_picchila', 'pair_picchila_vishada', 'a', 'पिच्छिल', 'слизистый (пиччхила)', 17),
('guna_vishada', 'pair_picchila_vishada', 'b', 'विशद', 'не слизистый (вишада)', 18),
('guna_sthira', 'pair_sthira_sara', 'a', 'स्थिर', 'устойчивый (стхира)', 19),
('guna_sara', 'pair_sthira_sara', 'b', 'सर', 'подвижный, текучий (сара)', 20);

INSERT OR IGNORE INTO ref_mouthfeel (id, name_ru, sort_order) VALUES
('mouthfeel_crispy', 'хрустящая', 1),
('mouthfeel_tender', 'нежная', 2),
('mouthfeel_slimy', 'слизистая', 3),
('mouthfeel_porous', 'пористая', 4),
('mouthfeel_dense', 'плотная', 5),
('mouthfeel_melting', 'тающая', 6),
('mouthfeel_flaky', 'хлопьястая', 7),
('mouthfeel_liquid', 'жидкая', 8),
('mouthfeel_thick', 'густая', 9),
('mouthfeel_chewy', 'упругая', 10);
