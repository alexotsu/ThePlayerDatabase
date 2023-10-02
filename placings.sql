-- SQLite

-- Query to get `game_data` for each tournament, which is a list of dicts containing, most importantly, `winner_char`. Rest of the work is done in pythong
SELECT tournament_key, winner_id, location_names, game_data
FROM (
    SELECT
        tournament_key,
        ROW_NUMBER() OVER (
            PARTITION BY tournament_key
            ORDER BY LENGTH(location_names) DESC
        ) AS rnk,
        winner_id,
        location_names,
        game_data
    FROM sets
    JOIN tournament_info
        ON tournament_info.key = sets.tournament_key
    WHERE DATETIME(tournament_info.end, 'unixepoch') > DATE('2021-01-01') 
        AND location_names LIKE '%Grand Final%'
  ) sub
WHERE sub.rnk = 1
    -- accounts for any empty ('[]' or '[{}]') game_data rows
    AND LENGTH(game_data) > 4;