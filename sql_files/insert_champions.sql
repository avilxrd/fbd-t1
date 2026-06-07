INSERT INTO champion (champion_name)
SELECT DISTINCT c.champion_name
FROM (
    SELECT Team1_ban1 AS champion_name FROM raw_matches
    UNION SELECT Team1_ban2 FROM raw_matches
    UNION SELECT Team1_ban3 FROM raw_matches
    UNION SELECT Team1_ban4 FROM raw_matches
    UNION SELECT Team1_ban5 FROM raw_matches

    UNION SELECT Team2_ban1 FROM raw_matches
    UNION SELECT Team2_ban2 FROM raw_matches
    UNION SELECT Team2_ban3 FROM raw_matches
    UNION SELECT Team2_ban4 FROM raw_matches
    UNION SELECT Team2_ban5 FROM raw_matches

    UNION SELECT Team1_player1_pick FROM raw_matches
    UNION SELECT Team1_player2_pick FROM raw_matches
    UNION SELECT Team1_player3_pick FROM raw_matches
    UNION SELECT Team1_player4_pick FROM raw_matches
    UNION SELECT Team1_player5_pick FROM raw_matches

    UNION SELECT Team2_player1_pick FROM raw_matches
    UNION SELECT Team2_player2_pick FROM raw_matches
    UNION SELECT Team2_player3_pick FROM raw_matches
    UNION SELECT Team2_player4_pick FROM raw_matches
    UNION SELECT Team2_player5_pick FROM raw_matches
) c
LEFT JOIN champion ch
    ON ch.champion_name = c.champion_name
WHERE ch.champion_name IS NULL;