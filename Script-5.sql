
-- creating table using fortnite stats 

CREATE TABLE player_stats (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    date DATE,
    time_of_day VARCHAR,
    placed INTEGER,
    mental_state VARCHAR,
    eliminations INTEGER,
    assists INTEGER,
    revives INTEGER,
    accuracy REAL,
    hits INTEGER,
    head_shots INTEGER,
    distance_traveled REAL,
    materials_gathered INTEGER,
    materials_used INTEGER,
    damage_taken INTEGER,
    damage_to_players INTEGER,
    damage_to_structures INTEGER
);

-- testing data imprort

select * from player_stats limit 10; 

-- removing mental_state column

CREATE TABLE player_stats_new (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    date DATE,
    time_of_day VARCHAR,
    placed INTEGER,
    eliminations INTEGER,
    assists INTEGER,
    revives INTEGER,
    accuracy REAL,
    hits INTEGER,
    head_shots INTEGER,
    distance_traveled REAL,
    materials_gathered INTEGER,
    materials_used INTEGER,
    damage_taken INTEGER,
    damage_to_players INTEGER,
    damage_to_structures INTEGER
);

INSERT INTO player_stats_new (id, date, time_of_day, placed, eliminations, assists, revives, accuracy, hits, head_shots, distance_traveled, materials_gathered, materials_used, damage_taken, damage_to_players, damage_to_structures)
SELECT id, date, time_of_day, placed, eliminations, assists, revives, accuracy, hits, head_shots, distance_traveled, materials_gathered, materials_used, damage_taken, damage_to_players, damage_to_structures
FROM player_stats;

DROP TABLE player_stats;

ALTER TABLE player_stats_new RENAME TO player_stats;

select * from player_stats limit 10 

-- practice with functions 

select * 
from player_stats 
where placed <= 10;

select * from player_stats 
where placed <= 10 AND eliminations > 5;

select time_of_day, sum(eliminations) as total_eliminations 
from player_stats 
group by time_of_day;

select 
avg(accuracy) as avg_accuracy,
min(accuracy) as min_accuracy, 
max(accuracy) as max_accuracy
from player_stats; 

select * from player_stats 
where damage_taken > damage_to_players;

select case when placed <= 5 then "Top 5"
when placed between 6 and 10 then "6-10"
when placed between 11 and 20 then "11-20"
else "Other"
end as placing_range, 
avg(accuracy) as avg_accuracy 
from player_stats 
group by placing_range;

select sum(distance_traveled) as "Total Distance Traveled"
from player_stats
where placed <= 10;

-- come back to try this one again - not showing in correct descending order 
select * 
from player_stats 
order by accuracy desc
limit 10; 





