CREATE TABLE my_table (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    date DATE,
    time_of_day TIME,
    placed INTEGER,
    mental_status TEXT,
    eliminations INTEGER,
    assists INTEGER,
    revives INTEGER,
    accuracy REAL,  -- For percentage, stored as a real number
    hits INTEGER,
    head_shots INTEGER,
    distance_traveled REAL,  -- For decimals
    materials_gathered INTEGER,
    materials_used INTEGER,
    damage_taken INTEGER,
    damage_to_players INTEGER,
    damage_to_structures INTEGER
);