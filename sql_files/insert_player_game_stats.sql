INSERT INTO player_game_stats (
    match_id,
    gameset,
    player_id,
    team_id,
    champion_id,
    role,
    kills,
    deaths,
    assists,
    farm,
    gold,
    damage,
    tanking
)

SELECT
    r.MatchID,
    r.gameset,
    p.player_id,
    t.team_id,
    c.champion_id,
    x.role,
    x.kills,
    x.deaths,
    x.assists,
    x.farm,
    x.gold,
    x.damage,
    x.tanking
FROM raw_matches r

JOIN (
    SELECT MatchID, gameset,
           Team1 AS team, Team1_region AS region,
           Team1_player1_name AS player_name,
           'TOP' AS role,
           Team1_player1_pick AS champion,
           Team1_player1_K AS kills,
           Team1_player1_D AS deaths,
           Team1_player1_A AS assists,
           Team1_player1_CS AS farm,
           Team1_player1_gold AS gold,
           Team1_player1_damage AS damage,
           Team1_player1_tanking AS tanking
    FROM raw_matches

    UNION ALL

    SELECT MatchID, gameset,
           Team1, Team1_region,
           Team1_player2_name, 'JUG',
           Team1_player2_pick,
           Team1_player2_K, Team1_player2_D, Team1_player2_A,
           Team1_player2_CS, Team1_player2_gold,
           Team1_player2_damage, Team1_player2_tanking
    FROM raw_matches

    UNION ALL

    SELECT MatchID, gameset,
           Team1, Team1_region,
           Team1_player3_name, 'MID',
           Team1_player3_pick,
           Team1_player3_K, Team1_player3_D, Team1_player3_A,
           Team1_player3_CS, Team1_player3_gold,
           Team1_player3_damage, Team1_player3_tanking
    FROM raw_matches

    UNION ALL

    SELECT MatchID, gameset,
           Team1, Team1_region,
           Team1_player4_name, 'ADC',
           Team1_player4_pick,
           Team1_player4_K, Team1_player4_D, Team1_player4_A,
           Team1_player4_CS, Team1_player4_gold,
           Team1_player4_damage, Team1_player4_tanking
    FROM raw_matches

    UNION ALL

    SELECT MatchID, gameset,
           Team1, Team1_region,
           Team1_player5_name, 'SUP',
           Team1_player5_pick,
           Team1_player5_K, Team1_player5_D, Team1_player5_A,
           Team1_player5_CS, Team1_player5_gold,
           Team1_player5_damage, Team1_player5_tanking
    FROM raw_matches

    UNION ALL

    SELECT MatchID, gameset,
           Team2, Team2_region,
           Team2_player1_name, 'TOP',
           Team2_player1_pick,
           Team2_player1_K, Team2_player1_D, Team2_player1_A,
           Team2_player1_CS, Team2_player1_gold,
           Team2_player1_damage, Team2_player1_tanking
    FROM raw_matches

    UNION ALL

    SELECT MatchID, gameset,
           Team2, Team2_region,
           Team2_player2_name, 'JUG',
           Team2_player2_pick,
           Team2_player2_K, Team2_player2_D, Team2_player2_A,
           Team2_player2_CS, Team2_player2_gold,
           Team2_player2_damage, Team2_player2_tanking
    FROM raw_matches

    UNION ALL

    SELECT MatchID, gameset,
           Team2, Team2_region,
           Team2_player3_name, 'MID',
           Team2_player3_pick,
           Team2_player3_K, Team2_player3_D, Team2_player3_A,
           Team2_player3_CS, Team2_player3_gold,
           Team2_player3_damage, Team2_player3_tanking
    FROM raw_matches

    UNION ALL

    SELECT MatchID, gameset,
           Team2, Team2_region,
           Team2_player4_name, 'ADC',
           Team2_player4_pick,
           Team2_player4_K, Team2_player4_D, Team2_player4_A,
           Team2_player4_CS, Team2_player4_gold,
           Team2_player4_damage, Team2_player4_tanking
    FROM raw_matches

    UNION ALL

    SELECT MatchID, gameset,
           Team2, Team2_region,
           Team2_player5_name, 'SUP',
           Team2_player5_pick,
           Team2_player5_K, Team2_player5_D, Team2_player5_A,
           Team2_player5_CS, Team2_player5_gold,
           Team2_player5_damage, Team2_player5_tanking
    FROM raw_matches
) x ON x.MatchID = r.MatchID AND x.gameset = r.gameset

JOIN player p
    ON p.player_name = x.player_name

JOIN team t
    ON t.team_name = x.team
   AND t.team_region = x.region

JOIN champion c
    ON c.champion_name = x.champion

WHERE NOT EXISTS (
    SELECT 1
    FROM player_game_stats pg
    WHERE pg.match_id = r.MatchID
      AND pg.gameset = r.gameset
      AND pg.player_id = p.player_id
      AND pg.role = x.role
);
