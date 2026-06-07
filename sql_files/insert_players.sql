INSERT INTO player (player_name)
SELECT p.player_name
FROM (
    SELECT DISTINCT TRIM(LOWER(player_name)) AS player_name
    FROM (
        SELECT Team1_player1_name AS player_name FROM raw_matches
        UNION ALL SELECT Team1_player2_name FROM raw_matches
        UNION ALL SELECT Team1_player3_name FROM raw_matches
        UNION ALL SELECT Team1_player4_name FROM raw_matches
        UNION ALL SELECT Team1_player5_name FROM raw_matches
        UNION ALL SELECT Team2_player1_name FROM raw_matches
        UNION ALL SELECT Team2_player2_name FROM raw_matches
        UNION ALL SELECT Team2_player3_name FROM raw_matches
        UNION ALL SELECT Team2_player4_name FROM raw_matches
        UNION ALL SELECT Team2_player5_name FROM raw_matches
    ) x
    WHERE player_name IS NOT NULL
      AND player_name <> ''
) p
LEFT JOIN player pl
    ON TRIM(LOWER(pl.player_name)) = p.player_name
WHERE pl.player_id IS NULL;