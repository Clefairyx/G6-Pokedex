USE master
GO

/*Create database if it does not exist */
if not exists(select * from sys.databases where name = 'g6_pokedex')
  create database g6_pokedex
go

/*Use pokedex database*/
USE g6_pokedex
GO

/*Drop all of the foreign keys if they exist*/
if exists(select * from INFORMATION_SCHEMA. TABLE_CONSTRAINTS 
	where CONSTRAINT_NAME='fk_pokemon_generation_caught_in_id') 
	alter table pokemon drop CONSTRAINT fk_pokemon_generation_caught_in_id
GO

if exists(select * from INFORMATION_SCHEMA. TABLE_CONSTRAINTS 
	where CONSTRAINT_NAME='fk_pokemon_base_stat_pokemon_pokedex_id') 
	alter table pokemon_base_stats drop CONSTRAINT fk_pokemon_base_stat_pokemon_pokedex_id
GO	

if exists(select * from INFORMATION_SCHEMA. TABLE_CONSTRAINTS 
	where CONSTRAINT_NAME='fk_pokemon_type_type_id') 
	alter table pokemon_types drop CONSTRAINT fk_pokemon_type_type_id
GO	

if exists(select * from INFORMATION_SCHEMA. TABLE_CONSTRAINTS 
	where CONSTRAINT_NAME='fk_pokemon_user_id') 
	alter table pokemon drop CONSTRAINT fk_pokemon_user_id
GO	

if exists(select * from INFORMATION_SCHEMA. TABLE_CONSTRAINTS 
	where CONSTRAINT_NAME='fk_pokemon_base_stats_pokemon_base_stat_base_stat_id') 
	alter table pokemon_base_stats drop CONSTRAINT fk_pokemon_base_stats_pokemon_base_stat_base_stat_id
GO	

if exists(select * from INFORMATION_SCHEMA. TABLE_CONSTRAINTS 
	where CONSTRAINT_NAME='fk_pokemon_type_pokemon_pokedex_id') 
	alter table pokemon_types drop CONSTRAINT fk_pokemon_type_pokemon_pokedex_id
GO


/*Drop all of tables*/
drop table if exists pokemon
drop table if exists generations_caught_in
drop table if exists users
drop table if exists pokemon_base_stats
drop table if exists base_stats
drop table if exists pokemon_types
drop table if exists types
GO


/*Create all of the tables */

/* Create Pokemon table*/
CREATE TABLE pokemon (
pokemon_pokedex_id int not null,
pokemon_name varchar(50) not null,
pokemon_height decimal(10,2) null,
pokemon_weight decimal(10,2) null,
pokemon_evolve_level int null,
pokemon_rarity varchar(20) null,
pokemon_caught char(1) not null,
pokemon_watch_list char(1) null,
pokemon_generation_caught_in_id int not null,
pokemon_user_id int null,
constraint pk_pokemon_pokedex_id PRIMARY KEY (pokemon_pokedex_id),
)
GO

/*Create generations caught in table*/
CREATE TABLE generations_caught_in (
generation_caught_in_id int IDENTITY not null,
generation_caught_in_game_title varchar(50) not null,
generation_caught_in_game_release_date date not null,
generation_caught_in_game_release_price money null,
constraint pk_generations_generation_caught_in_id PRIMARY KEY (generation_caught_in_id),
constraint u_generations_generation_caught_in_game_title UNIQUE (generation_caught_in_game_title),
)
GO

/*Create users table*/
CREATE TABLE users (
user_id int IDENTITY not null,
user_email varchar(50) not null,
user_firstname varchar(50) not null,
user_lastname varchar(50) not null,
user_first_game varchar(50) null,
constraint pk_users_user_id PRIMARY KEY (user_id),
constraint u_users_user_email UNIQUE (user_email),
)
GO

/*Create Pokemon base stats table*/
CREATE TABLE pokemon_base_stats (
pokemon_base_stat_id int IDENTITY not null,
pokemon_base_stat_pokemon_pokedex_id int null,
pokemon_base_stats_base_stat_id int null,
constraint pk_pokemon_base_stat_id PRIMARY KEY (pokemon_base_stat_id),
)
GO

/*Create base stats table*/
CREATE TABLE base_stats (
base_stat_id int IDENTITY not null,
base_stat_hp int not null,
base_stat_speed int not null,
base_stat_phsyical_attack int not null,
base_stat_phsyical_defense int not null,
base_stat_special_attack int not null,
base_stat_special_defense int not null,
base_stat_capture_rate int not null,
constraint pk_pokemon_base_stats_base_stat_id PRIMARY KEY (base_stat_id),
)
GO

/*Create Pokemon types table*/
CREATE TABLE pokemon_types (
pokemon_type_id int IDENTITY not null,
pokemon_type_pokemon_pokedex_id int not null,
pokemon_type_type_id int not null,
constraint pk_pokemon_types_pokemon_type_id PRIMARY KEY (pokemon_type_id),
)
GO

/*Create types table*/
CREATE TABLE types (
type_id int IDENTITY not null,
type_name varchar(50) not null,
type_rarity_rank int not null,
type_supereffective_against varchar(50) null,
type_weak_agaianst varchar(50) null,
constraint pk_types_type_id PRIMARY KEY (type_id),
constraint u_type_name UNIQUE (type_name),
)
GO


/*Create indexes if they do not exist*/

/*generations_caught_in table*/
IF EXISTS (SELECT * FROM sys.indexes WHERE name = 'ix_generation_caught_in_game_title' AND object_id = OBJECT_ID('generations_caught_in'))
BEGIN
    DROP INDEX ix_generation_caught_in_game_title ON generations_caught_in;
END

CREATE NONCLUSTERED INDEX ix_generation_caught_in_game_title ON generations_caught_in (generation_caught_in_game_title);
GO

/*users table*/
IF EXISTS (SELECT * FROM sys.indexes WHERE name = 'IX_NonClustered_Users_UserEmail' AND object_id = OBJECT_ID('users'))
BEGIN
    DROP INDEX IX_NonClustered_Users_UserEmail ON users;
END

CREATE NONCLUSTERED INDEX IX_NonClustered_Users_UserEmail 
ON users (user_email);
GO

/*Pokemon base stats table*/
IF EXISTS (SELECT * FROM sys.indexes WHERE name = 'ix_NonClustered_PokemonBaseStats_PokemonPokedexID' AND object_id = OBJECT_ID('pokemon_base_stats'))
BEGIN
    DROP INDEX ix_NonClustered_PokemonBaseStats_PokemonPokedexID ON pokemon_base_stats;
END

CREATE NONCLUSTERED INDEX ix_NonClustered_PokemonBaseStats_PokemonPokedexID 
ON pokemon_base_stats (pokemon_base_stat_pokemon_pokedex_id);

/*Base stats table*/
IF EXISTS (SELECT * FROM sys.indexes WHERE name = 'ix_base_stat_speed' AND object_id = OBJECT_ID('base_stats'))
BEGIN
    DROP INDEX ix_base_stat_speed ON base_stats;
END

CREATE NONCLUSTERED INDEX ix_base_stat_speed ON base_stats (base_stat_speed, base_stat_hp);
GO

/*types table*/
IF EXISTS (SELECT * FROM sys.indexes WHERE name = 'ix_type_name' AND object_id = OBJECT_ID('types'))
BEGIN
    DROP INDEX ix_type_name ON types;
END

CREATE NONCLUSTERED INDEX ix_type_name ON types (type_name) INCLUDE (type_supereffective_against);
GO

/*Pokemon table*/
IF EXISTS (SELECT * FROM sys.indexes WHERE name = 'ix_pokemon_rarity' AND object_id = OBJECT_ID('pokemon'))
BEGIN
    DROP INDEX ix_pokemon_rarity ON pokemon;
END

CREATE NONCLUSTERED INDEX ix_pokemon_raritye ON pokemon (pokemon_rarity) INCLUDE (pokemon_name);
GO

/*Pokemon types table*/
IF EXISTS (SELECT * FROM sys.indexes WHERE name = 'ix_pokemon_types' AND object_id = OBJECT_ID('pokemon_types'))
BEGIN
    DROP INDEX ix_pokemon_types ON pokemon_types;
END

CREATE NONCLUSTERED INDEX ix_pokemon_types ON pokemon_types (pokemon_type_id) INCLUDE (pokemon_type_pokemon_pokedex_id, pokemon_type_type_id);
GO

/*Pokemon base stats table*/
IF EXISTS (SELECT * FROM sys.indexes WHERE name = 'ix_pokemon_base_stats' AND object_id = OBJECT_ID('pokemon_base_stats'))
BEGIN
    DROP INDEX ix_pokemon_base_stats ON pokemon_base_stats;
END

CREATE NONCLUSTERED INDEX ix_pokemon_base_stats ON pokemon_base_stats (pokemon_base_stat_id) INCLUDE (pokemon_base_stat_pokemon_pokedex_id, pokemon_base_stats_base_stat_id);
GO


/*Adds in the foreign keys*/

/*Pokemon table*/
ALTER TABLE pokemon
add constraint fk_pokemon_generation_caught_in_id FOREIGN KEY (pokemon_generation_caught_in_id)
REFERENCES generations_caught_in (generation_caught_in_id)
GO

ALTER TABLE pokemon
add constraint fk_pokemon_user_id FOREIGN KEY (pokemon_user_id)
REFERENCES users(user_id)
GO

/*Pokemon base stats table*/
ALTER TABLE pokemon_base_stats
add constraint fk_pokemon_base_stat_pokemon_pokedex_id FOREIGN KEY (pokemon_base_stat_pokemon_pokedex_id)
REFERENCES pokemon(pokemon_pokedex_id)
GO

ALTER TABLE pokemon_base_stats
add constraint fk_pokemon_base_stats_pokemon_base_stat_base_stat_id FOREIGN KEY (pokemon_base_stats_base_stat_id)
REFERENCES base_stats (base_stat_id)
GO

/*Pokemon types table*/
ALTER TABLE pokemon_types
add constraint fk_pokemon_type_type_id FOREIGN KEY (pokemon_type_type_id)
REFERENCES types(type_id)
GO

ALTER TABLE pokemon_types
add constraint fk_pokemon_type_pokemon_pokedex_id FOREIGN KEY (pokemon_type_pokemon_pokedex_id)
REFERENCES pokemon(pokemon_pokedex_id)
GO

/* Check Tables
SELECT table_name
FROM INFORMATION_SCHEMA.TABLES */

/*This section fills in the tables using transactions where we can to validate the integrity of the data*/

/*Insert into users*/
BEGIN TRY
    BEGIN TRANSACTION; 
INSERT INTO users (user_firstname, user_lastname, user_email)
VALUES 
    ('Ash', 'Ketchum', 'ash@pokemon.com'),
    ('Misty', 'Waterflower', 'misty@pokemon.com'),
    ('Brock', 'Rock', 'brock@pokemon.com'),
    ('Gary', 'Oak', 'gary@pokemone.com'),
    ('Jessie', 'Team Rocket', 'jessie@pokemon.com');
            COMMIT;
END TRY
BEGIN CATCH
    IF @@TRANCOUNT > 0 THROW 50001, 'Email already Exists',1
        ROLLBACK; 
    throw;
END CATCH

/* Insert into generations_caught_in table*/
BEGIN TRY
    BEGIN TRANSACTION; 
insert into generations_caught_in (
	generation_caught_in_game_title, 
	generation_caught_in_game_release_date, 
	generation_caught_in_game_release_price)
values 
	('Red/Blue', '1998-09-28', $29.95),
	('Gold/Silver', '2000-10-15', $29.95),
	('Ruby/Sapphire', '2002-11-21', $34.99),
	('Diamond/Pearl', '2006-09-28', $39.99),
	('Black/White', '2010-09-18', $34.99),
	('X/Y', '2013-10-12', $39.99),
	('Sun/Moon', '2016-11-18', $59.99),
	('Sword/Shield', '2019-11-15', $59.99),
	('Scarlet/Violet', '2022-11-18', $59.99);
        COMMIT;
END TRY
BEGIN CATCH
    IF @@TRANCOUNT > 0 THROW 50002, 'Game Title Already Exists',1
        ROLLBACK; 
    throw;
END CATCH
GO

/* Insert into types table*/
BEGIN TRY
    BEGIN TRANSACTION;
insert into types (
	type_name, 
	type_rarity_rank, 
	type_supereffective_against, 
	type_weak_agaianst)
values 
	('Bug', 13, 'Grass/Fight/Ground', 'Fire/Flying/Rock'),
	('Dark', 9, 'Psychic/Ghost', 'Fight/Bug/Fairy'),
	('Dragon', 5, 'Fire/Water/Electric/Grass', 'Ice/Dragon/Fairy'),
	('Electric', 4, 'Flying/Steel', 'Ground'),
	('Fight', 10, 'Bug/Rock/Dark', 'Flying/Psychic/Fairy'),
	('Fire', 12, 'Grass/Ice/Bug/Steel', 'Water/Ground/Rock'),
	('Flying', 15, 'Grass/Ground/Bug/Ghost', 'Electric/Ice/Rock'),
	('Ghost', 3, 'Normal/Fight/Poison/Bug', 'Ghost/Dark'),
	('Grass', 16, 'Water/Electric/Ground', 'Fire/Ice/Poison/Flying/Bug'),
	('Ground', 7, 'Electric/Poison/Rock', 'Water/Grass/Ice/'),
	('Ice', 1, 'Dragon/Flying/Grass/Ground', 'Fighting/Fire/Rock/Steel'),
	('Normal', 17, 'Ghost', 'Fight'),
	('Poison', 11, 'Grass/Fight/Bug/Fairy', 'Ground/Psychic'),
	('Psychic', 14, 'Fight', 'Bug/Ghost/Dark'),
	('Rock', 8, 'Normal/Fire/Poison/Flying', 'Water/Grass/Fight/Ground/Steel'),
	('Steel', 6, 'Fairty/Ice/Rock/Fairy', 'Fighting/Fire/Ground'),
	('Water', 18, 'Fire/Ice/Steel', 'Electic/Grass'),
	('Fairy', 2, 'Dark/Fighting/Dragon', 'Dark/Fighting/Dragon');
    COMMIT;
END TRY
BEGIN CATCH
    IF @@TRANCOUNT > 0 THROW 50003, 'Type Already Exists',1
        ROLLBACK; 
    throw;
END CATCH
GO

/* Insert into Pokemon*/
BEGIN TRY
    BEGIN TRANSACTION;
insert into pokemon (
	pokemon_pokedex_id,
    pokemon_name,
    pokemon_height,
    pokemon_weight,
    pokemon_evolve_level,
    pokemon_rarity,
    pokemon_caught,
    pokemon_watch_list,
    pokemon_generation_caught_in_id,
    pokemon_user_id)
values
    (147, 'Dratini', 1.80, 3.30, 30, null, 'Y', NULL, 1, 1),
    (148, 'Dragonair', 4.00, 16.50, 55, 'Rare', 'Y', NULL, 1, 1),
    (149, 'Dragonite', 2.20, 210.00, NULL, 'Rare', 'Y', 'Y', 1, 2),
    (230, 'Kingdra', 1.80, 152.00, NULL, 'Rare', 'N', NULL, 2, null),
    (329, 'Vibrava', 1.10, 15.30, 45, null, 'Y', NULL, 3, 1),
    (330, 'Flygon', 2.00, 82.00, NULL, 'Rare', 'N', 'Y', 3, 2),
    (334, 'Altaria', 1.10, 20.60, NULL, 'Rare', 'Y', NULL, 3, 1),
    (371, 'Bagon', 0.60, 42.10, 30, 'Rare', 'Y', 'Y', 3, 2),
    (372, 'Shelgon', 1.10, 110.50, 50, 'Rare', 'Y', NULL, 3, 3),
    (373, 'Salamence', 1.50, 102.60, NULL, 'Rare', 'Y', 'Y', 3, 1),
    (380, 'Latias', 1.40, 40.00, NULL, 'Legendary', 'N', 'Y', 3, 2),
    (381, 'Latios', 2.00, 60.00, NULL, 'Legendary', 'Y', NULL, 3, 2),
    (384, 'Rayquaza', 7.00, 206.50, NULL, 'Legendary', 'Y', 'Y', 3, 2),
    (25, 'Pikachu', 0.40, 6.00, 16, 'Common', 'Y', 'N', 1, 1);
       COMMIT;
END TRY
BEGIN CATCH
    IF @@TRANCOUNT > 0 THROW 50004, 'Pokemon Already Exists',1
        ROLLBACK; 
    throw;
END CATCH 
GO

/* Insert into Base Stats*/
INSERT INTO base_stats (
    base_stat_hp,
    base_stat_speed,
    base_stat_phsyical_attack,
    base_stat_phsyical_defense,
    base_stat_special_attack,
    base_stat_special_defense,
    base_stat_capture_rate
) VALUES
    (41, 50, 64, 45, 50, 50, 45),  -- Dratini
    (61, 70, 84, 65, 70, 70, 45),  -- Dragonair
    (91, 80, 134, 95, 100, 100, 45),  -- Dragonite
    (75, 85, 95, 95, 95, 95, 45),  -- Kingdra
    (50, 70, 70, 50, 50, 50, 120),  -- Vibrava
    (80, 100, 100, 80, 80, 80, 120),  -- Flygon
    (75, 80, 70, 90, 70, 90, 45),  -- Altaria
    (45, 50, 75, 60, 40, 30, 45),  -- Bagon
    (65, 50, 95, 100, 60, 50, 45),  -- Shelgon
    (95, 100, 135, 80, 110, 80, 45),  -- Salamence
    (80, 110, 80, 90, 110, 130, 3),  -- Latias
    (80, 110, 90, 80, 130, 110, 3),  -- Latios
    (105, 95, 150, 90, 150, 90, 3),  -- Rayquaza
    (35, 90, 55, 40, 50, 50, 190); --Pikachu

/* Insert into pokemon_types */
INSERT INTO pokemon_types (
    pokemon_type_pokemon_pokedex_id, 
    pokemon_type_type_id)
VALUES
    -- Dratini
    (147, (SELECT type_id FROM types WHERE type_name = 'Dragon')),  
    -- Dragonair
    (148, (SELECT type_id FROM types WHERE type_name = 'Dragon')),
    -- Dragonite
    (149, (SELECT type_id FROM types WHERE type_name = 'Dragon')),
    (149, (SELECT type_id FROM types WHERE type_name = 'Flying')),
    -- Kingdra
    (230, (SELECT type_id FROM types WHERE type_name = 'Water')),
    (230, (SELECT type_id FROM types WHERE type_name = 'Dragon')),
    -- Vibrava
    (329, (SELECT type_id FROM types WHERE type_name = 'Ground')),
    (329, (SELECT type_id FROM types WHERE type_name = 'Dragon')),
    -- Flygon
    (330, (SELECT type_id FROM types WHERE type_name = 'Ground')),
    (330, (SELECT type_id FROM types WHERE type_name = 'Dragon')),
    -- Altaria
    (334, (SELECT type_id FROM types WHERE type_name = 'Dragon')),
    (334, (SELECT type_id FROM types WHERE type_name = 'Flying')),
    -- Bagon
    (371, (SELECT type_id FROM types WHERE type_name = 'Dragon')),
    -- Shelgon
    (372, (SELECT type_id FROM types WHERE type_name = 'Dragon')),
    -- Salamence
    (373, (SELECT type_id FROM types WHERE type_name = 'Dragon')),
    (373, (SELECT type_id FROM types WHERE type_name = 'Flying')),
    -- Latias
    (380, (SELECT type_id FROM types WHERE type_name = 'Dragon')),
    (380, (SELECT type_id FROM types WHERE type_name = 'Psychic')),
    -- Latios
    (381, (SELECT type_id FROM types WHERE type_name = 'Dragon')),
    (381, (SELECT type_id FROM types WHERE type_name = 'Psychic')),
    -- Rayquaza
    (384, (SELECT type_id FROM types WHERE type_name = 'Dragon')),
    (384, (SELECT type_id FROM types WHERE type_name = 'Flying')),
    -- Pikachu
    (25, (SELECT type_id FROM types WHERE type_name = 'Electric'));
GO

/* Insert into pokemon_base_stats */
INSERT INTO pokemon_base_stats (
    pokemon_base_stat_pokemon_pokedex_id,
    pokemon_base_stats_base_stat_id
)
VALUES
    /* Dratini*/
    (147, (SELECT base_stat_id FROM base_stats WHERE base_stat_hp = 41 AND base_stat_speed = 50 AND base_stat_phsyical_attack = 64 AND base_stat_phsyical_defense = 45 AND base_stat_special_attack = 50 AND base_stat_special_defense = 50 AND base_stat_capture_rate = 45)),
    /* Dragonair*/
    (148, (SELECT base_stat_id FROM base_stats WHERE base_stat_hp = 61 AND base_stat_speed = 70 AND base_stat_phsyical_attack = 84 AND base_stat_phsyical_defense = 65 AND base_stat_special_attack = 70 AND base_stat_special_defense = 70 AND base_stat_capture_rate = 45)),
    /* Dragonite*/
    (149, (SELECT base_stat_id FROM base_stats WHERE base_stat_hp = 91 AND base_stat_speed = 80 AND base_stat_phsyical_attack = 134 AND base_stat_phsyical_defense = 95 AND base_stat_special_attack = 100 AND base_stat_special_defense = 100 AND base_stat_capture_rate = 45)),
    /* Kingdra*/
    (230, (SELECT base_stat_id FROM base_stats WHERE base_stat_hp = 75 AND base_stat_speed = 85 AND base_stat_phsyical_attack = 95 AND base_stat_phsyical_defense = 95 AND base_stat_special_attack = 95 AND base_stat_special_defense = 95 AND base_stat_capture_rate = 45)),
    /* Vibrava*/
    (329, (SELECT base_stat_id FROM base_stats WHERE base_stat_hp = 50 AND base_stat_speed = 70 AND base_stat_phsyical_attack = 70 AND base_stat_phsyical_defense = 50 AND base_stat_special_attack = 50 AND base_stat_special_defense = 50 AND base_stat_capture_rate = 120)),
    /* Flygon*/
    (330, (SELECT base_stat_id FROM base_stats WHERE base_stat_hp = 80 AND base_stat_speed = 100 AND base_stat_phsyical_attack = 100 AND base_stat_phsyical_defense = 80 AND base_stat_special_attack = 80 AND base_stat_special_defense = 80 AND base_stat_capture_rate = 120)),
    /* Altaria*/
    (334, (SELECT base_stat_id FROM base_stats WHERE base_stat_hp = 75 AND base_stat_speed = 80 AND base_stat_phsyical_attack = 70 AND base_stat_phsyical_defense = 90 AND base_stat_special_attack = 70 AND base_stat_special_defense = 90 AND base_stat_capture_rate = 45)),
    /* Bagon*/
    (371, (SELECT base_stat_id FROM base_stats WHERE base_stat_hp = 45 AND base_stat_speed = 50 AND base_stat_phsyical_attack = 75 AND base_stat_phsyical_defense = 60 AND base_stat_special_attack = 40 AND base_stat_special_defense = 30 AND base_stat_capture_rate = 45)),
    /* Shelgon*/
    (372, (SELECT base_stat_id FROM base_stats WHERE base_stat_hp = 65 AND base_stat_speed = 50 AND base_stat_phsyical_attack = 95 AND base_stat_phsyical_defense = 100 AND base_stat_special_attack = 60 AND base_stat_special_defense = 50 AND base_stat_capture_rate = 45)),
    /* Salamence*/
    (373, (SELECT base_stat_id FROM base_stats WHERE base_stat_hp = 95 AND base_stat_speed = 100 AND base_stat_phsyical_attack = 135 AND base_stat_phsyical_defense = 80 AND base_stat_special_attack = 110 AND base_stat_special_defense = 80 AND base_stat_capture_rate = 45)),
    /* Latias*/
    (380, (SELECT base_stat_id FROM base_stats WHERE base_stat_hp = 80 AND base_stat_speed = 110 AND base_stat_phsyical_attack = 80 AND base_stat_phsyical_defense = 90 AND base_stat_special_attack = 110 AND base_stat_special_defense = 130 AND base_stat_capture_rate = 3)),
    /* Latios*/
    (381, (SELECT base_stat_id FROM base_stats WHERE base_stat_hp = 80 AND base_stat_speed = 110 AND base_stat_phsyical_attack = 90 AND base_stat_phsyical_defense = 80 AND base_stat_special_attack = 130 AND base_stat_special_defense = 110 AND base_stat_capture_rate = 3)),
    /* Rayquaza*/
    (384, (SELECT base_stat_id FROM base_stats WHERE base_stat_hp = 105 AND base_stat_speed = 95 AND base_stat_phsyical_attack = 150 AND base_stat_phsyical_defense = 90 AND base_stat_special_attack = 150 AND base_stat_special_defense = 90 AND base_stat_capture_rate = 3)),
    /* Pikachu*/
    (25, (SELECT base_stat_id FROM base_stats WHERE base_stat_hp = 35 AND base_stat_speed = 90 AND base_stat_phsyical_attack = 55 AND base_stat_phsyical_defense = 40 AND base_stat_special_attack = 50 AND base_stat_special_defense = 50 AND base_stat_capture_rate = 190));
GO


/* TVF for users who frequently filter Pokémon by a specific type*/
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'dbo.PokemonByType'))
    DROP FUNCTION dbo.PokemonByType;
GO

CREATE FUNCTION dbo.PokemonByType(@type_name varchar(50))
RETURNS TABLE
AS
RETURN (
    SELECT p.pokemon_pokedex_id,
           p.pokemon_name,
           t.*
    FROM pokemon p
    JOIN pokemon_types pt ON p.pokemon_pokedex_id = pt.pokemon_type_pokemon_pokedex_id
    JOIN types t ON pt.pokemon_type_type_id = t.type_id
    WHERE t.type_name = @type_name
);
GO


/*View of all pokemon for generation filtering*/
IF EXISTS (SELECT * FROM sys.views WHERE name = 'v_pokemon_generation')
BEGIN
    DROP VIEW v_pokemon_generation;
END
GO

CREATE VIEW v_pokemon_generation AS
SELECT 
    p.pokemon_pokedex_id, 
    p.pokemon_name, 
    gci.generation_caught_in_game_title,
    gci.generation_caught_in_id
FROM 
    pokemon p
JOIN 
    generations_caught_in gci 
ON 
    gci.generation_caught_in_id = p.pokemon_generation_caught_in_id
GO
  

/*A view that will commonly be used by casual players to see basic pokemon info and stats*/
IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.VIEWS WHERE TABLE_NAME = 'v_casual_player')
BEGIN
    DROP VIEW v_casual_player;
END
GO

CREATE VIEW v_casual_player as
SELECT 
    p.pokemon_pokedex_id, 
    p.pokemon_name, 
    t.type_name, 
    t.type_supereffective_against, 
    t.type_weak_agaianst, 
    bs.base_stat_hp, 
    bs.base_stat_speed
FROM 
    pokemon p
JOIN 
    pokemon_types pt ON p.pokemon_pokedex_id = pt.pokemon_type_pokemon_pokedex_id
JOIN 
    types t ON t.type_id = pt.pokemon_type_type_id
JOIN 
    pokemon_base_stats pbs ON pbs.pokemon_base_stat_pokemon_pokedex_id = p.pokemon_pokedex_id
JOIN 
    base_stats bs ON bs.base_stat_id = pbs.pokemon_base_stats_base_stat_id;
GO

/*A view to see all pokemon in the database that appear on both the caught list and watchlist of every user*/
IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.VIEWS WHERE TABLE_NAME = 'v_all_pokemon_on_watchlist_all_users')
BEGIN
    DROP VIEW v_all_pokemon_on_watchlist_all_users;
END
GO

CREATE VIEW v_all_pokemon_on_watchlist_all_users AS
SELECT 
    s.user_firstname + ' ' + s.user_lastname AS user_name, 
    p.pokemon_pokedex_id, 
    p.pokemon_name
FROM 
    users s
JOIN 
    pokemon p 
ON 
    p.pokemon_user_id = s.user_id
WHERE 
    p.pokemon_caught = 'Y'
    AND p.pokemon_watch_list = 'Y';
GO

/*A view to show all super effective pokemon vs every type*/
IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.VIEWS WHERE TABLE_NAME = 'v_super_effective_pokemons')
BEGIN
    DROP VIEW v_super_effective_pokemons;
END
GO

CREATE VIEW v_super_effective_pokemons AS
SELECT 
    p.pokemon_name,
    CASE 
        WHEN t.type_supereffective_against LIKE '%Ground%' THEN 'Ground'
        WHEN t.type_supereffective_against LIKE '%Electric%' THEN 'Electric'
        WHEN t.type_supereffective_against LIKE '%Bug%' THEN 'Bug'
        WHEN t.type_supereffective_against LIKE '%Dark%' THEN 'Dark'
        WHEN t.type_supereffective_against LIKE '%Dragon%' THEN 'Dragon'
        WHEN t.type_supereffective_against LIKE '%Fight%' THEN 'Fight'
        WHEN t.type_supereffective_against LIKE '%Fire%' THEN 'Fire'
        WHEN t.type_supereffective_against LIKE '%Flying%' THEN 'Flying'
        WHEN t.type_supereffective_against LIKE '%Ghost%' THEN 'Ghost'
        WHEN t.type_supereffective_against LIKE '%Grass%' THEN 'Grass'
        WHEN t.type_supereffective_against LIKE '%Ice%' THEN 'Ice'
        WHEN t.type_supereffective_against LIKE '%Normal%' THEN 'Normal'
        WHEN t.type_supereffective_against LIKE '%Poison%' THEN 'Poison'
        WHEN t.type_supereffective_against LIKE '%Psychic%' THEN 'Psychic'
        WHEN t.type_supereffective_against LIKE '%Rock%' THEN 'Rock'
        WHEN t.type_supereffective_against LIKE '%Steel%' THEN 'Steel'
        WHEN t.type_supereffective_against LIKE '%Water%' THEN 'Water'
        WHEN t.type_supereffective_against LIKE '%Fairy%' THEN 'Fairy'
        ELSE ''
    END AS super_effective_type
FROM 
    pokemon p
JOIN 
    pokemon_types pt ON p.pokemon_pokedex_id = pt.pokemon_type_pokemon_pokedex_id
JOIN 
    types t ON t.type_id = pt.pokemon_type_type_id;
GO


/*************************************************************************
**                                                                       **
**    Queries                                                            **
**                                                                       **
**                                                                       **
**                                                                       **
**************************************************************************/

/*Super effective against a specific type i.e Ground*/
SELECT p.pokemon_pokedex_id, p.pokemon_name, t.type_name, t.type_supereffective_against
FROM pokemon p
JOIN pokemon_types pt ON p.pokemon_pokedex_id = pt.pokemon_type_pokemon_pokedex_id
JOIN types t ON t.type_id = pt.pokemon_type_type_id
JOIN pokemon_base_stats pbs ON pbs.pokemon_base_stat_pokemon_pokedex_id = p.pokemon_pokedex_id
WHERE t.type_supereffective_against LIKE '%Ground%' 
GO

/*A complex query for a specfic pokemon with a specific attribute, fastest pokemon in generation 1*/
SELECT TOP 1 p.pokemon_name, bs.base_stat_speed
FROM pokemon p
JOIN pokemon_base_stats pbs ON p.pokemon_pokedex_id = pbs.pokemon_base_stat_pokemon_pokedex_id
JOIN base_stats bs ON pbs.pokemon_base_stats_base_stat_id = bs.base_stat_id
WHERE p.pokemon_generation_caught_in_id = 1
ORDER BY bs.base_stat_speed DESC
GO

/*Test Function to show Pokemon of a certain type, show all ground pokemon*/
SELECT *
FROM dbo.PokemonByType('Ground'); 
GO

/*Casual Player View. These are the most commonly used basic pokemon info and stats. This shows all pokemon with an hp over 60 from the view*/
select * from v_casual_player
where base_stat_hp > 60
GO

/*View sorted for all pokemon in generation 1*/
Select pokemon_pokedex_id, pokemon_name, generation_caught_in_game_title from v_pokemon_generation
    WHERE generation_caught_in_id = 1
GO

/*View sorted for all pokemon in generation 2*/
Select pokemon_pokedex_id, pokemon_name, generation_caught_in_game_title from v_pokemon_generation
    WHERE generation_caught_in_id = 2
GO

/*View sorted for all pokemon in gernation 3*/
Select pokemon_pokedex_id, pokemon_name, generation_caught_in_game_title from v_pokemon_generation
    WHERE generation_caught_in_id = 3
GO

/*How many pokemon have a speed over 80?*/
SELECT COUNT(p.pokemon_pokedex_id) AS pokemon_count
FROM pokemon p
JOIN pokemon_base_stats pbs ON pbs.pokemon_base_stat_pokemon_pokedex_id = p.pokemon_pokedex_id
JOIN base_stats bs ON bs.base_stat_id = pbs.pokemon_base_stats_base_stat_id
WHERE bs.base_stat_speed > 80;
GO

/*What is the average hp of all Pokemon*/
SELECT AVG(base_stat_hp) AS average_hp
FROM base_stats;
GO

/*CTE to show all pokemon caught by user 1*/
WITH All_Pokemon_caught_for_user AS (
    SELECT 
        s.user_firstname + ' ' + s.user_lastname AS user_name, 
        p.pokemon_pokedex_id, 
        p.pokemon_name
    FROM 
        users s
    JOIN 
        pokemon p 
    ON 
        p.pokemon_user_id = s.user_id
    WHERE 
        s.user_id = 1 and p.pokemon_caught ='Y'
)
SELECT 
    user_name, 
    pokemon_pokedex_id, 
    pokemon_name
FROM 
    All_Pokemon_caught_for_user;
GO

/*CTE to show all pokemon on a user's watchlist, user 2*/
WITH All_Pokemon_watchlist_for_user AS (
    SELECT 
        s.user_firstname + ' ' + s.user_lastname AS user_name, 
        p.pokemon_pokedex_id, 
        p.pokemon_name
    FROM 
        users s
    JOIN 
        pokemon p 
    ON 
        p.pokemon_user_id = s.user_id
    WHERE 
        s.user_id = 2 and p.pokemon_watch_list ='Y'
)
SELECT 
    user_name, 
    pokemon_pokedex_id, 
    pokemon_name
FROM 
    All_Pokemon_watchlist_for_user;
GO

/*A view to see all pokemon in the database that appear on both the caught list and watchlist for each user*/
SELECT 
    user_name, 
    pokemon_pokedex_id, 
    pokemon_name
FROM 
    v_all_pokemon_on_watchlist_all_users;
GO

/*View for every pokemon that is super effective against each type*/
SELECT 
    super_effective_against_ground,
    super_effective_against_electric,
    super_effective_against_bug,
    super_effective_against_dark,
    super_effective_against_dragon,
    super_effective_against_fight,
    super_effective_against_fire,
    super_effective_against_flying,
    super_effective_against_ghost,
    super_effective_against_grass,
    super_effective_against_ice,
    super_effective_against_normal,
    super_effective_against_poison,
    super_effective_against_psychic,
    super_effective_against_rock,
    super_effective_against_steel,
    super_effective_against_water,
    super_effective_against_fairy
FROM (
    SELECT 
        MAX(CASE WHEN super_effective_type = 'Ground' THEN pokemon_name ELSE '' END) AS super_effective_against_ground,
        MAX(CASE WHEN super_effective_type = 'Electric' THEN pokemon_name ELSE '' END) AS super_effective_against_electric,
        MAX(CASE WHEN super_effective_type = 'Bug' THEN pokemon_name ELSE '' END) AS super_effective_against_bug,
        MAX(CASE WHEN super_effective_type = 'Dark' THEN pokemon_name ELSE '' END) AS super_effective_against_dark,
        MAX(CASE WHEN super_effective_type = 'Dragon' THEN pokemon_name ELSE '' END) AS super_effective_against_dragon,
        MAX(CASE WHEN super_effective_type = 'Fight' THEN pokemon_name ELSE '' END) AS super_effective_against_fight,
        MAX(CASE WHEN super_effective_type = 'Fire' THEN pokemon_name ELSE '' END) AS super_effective_against_fire,
        MAX(CASE WHEN super_effective_type = 'Flying' THEN pokemon_name ELSE '' END) AS super_effective_against_flying,
        MAX(CASE WHEN super_effective_type = 'Ghost' THEN pokemon_name ELSE '' END) AS super_effective_against_ghost,
        MAX(CASE WHEN super_effective_type = 'Grass' THEN pokemon_name ELSE '' END) AS super_effective_against_grass,
        MAX(CASE WHEN super_effective_type = 'Ice' THEN pokemon_name ELSE '' END) AS super_effective_against_ice,
        MAX(CASE WHEN super_effective_type = 'Normal' THEN pokemon_name ELSE '' END) AS super_effective_against_normal,
        MAX(CASE WHEN super_effective_type = 'Poison' THEN pokemon_name ELSE '' END) AS super_effective_against_poison,
        MAX(CASE WHEN super_effective_type = 'Psychic' THEN pokemon_name ELSE '' END) AS super_effective_against_psychic,
        MAX(CASE WHEN super_effective_type = 'Rock' THEN pokemon_name ELSE '' END) AS super_effective_against_rock,
        MAX(CASE WHEN super_effective_type = 'Steel' THEN pokemon_name ELSE '' END) AS super_effective_against_steel,
        MAX(CASE WHEN super_effective_type = 'Water' THEN pokemon_name ELSE '' END) AS super_effective_against_water,
        MAX(CASE WHEN super_effective_type = 'Fairy' THEN pokemon_name ELSE '' END) AS super_effective_against_fairy
    FROM v_super_effective_pokemons
    GROUP BY pokemon_name
) AS AllSuperEffective
WHERE 
    super_effective_against_ground <> ''
    OR super_effective_against_electric <> ''
    OR super_effective_against_bug <> ''
    OR super_effective_against_dark <> ''
    OR super_effective_against_dragon <> ''
    OR super_effective_against_fight <> ''
    OR super_effective_against_fire <> ''
    OR super_effective_against_flying <> ''
    OR super_effective_against_ghost <> ''
    OR super_effective_against_grass <> ''
    OR super_effective_against_ice <> ''
    OR super_effective_against_normal <> ''
    OR super_effective_against_poison <> ''
    OR super_effective_against_psychic <> ''
    OR super_effective_against_rock <> ''
    OR super_effective_against_steel <> ''
    OR super_effective_against_water <> ''
    OR super_effective_against_fairy <> '';
GO
