INSERT INTO game (match_id, gameset, duration, winner_id)
SELECT
    r.matchID,
    r.gameset,
    r.Duration,
    CASE
        WHEN r.win = r.Team1 THEN t1.team_id
        WHEN r.win = r.Team2 THEN t2.team_id
    END AS winner_id
FROM raw_matches r

JOIN team t1
    ON t1.team_name = r.Team1
   AND t1.team_region = r.Team1_region

JOIN team t2
    ON t2.team_name = r.Team2
   AND t2.team_region = r.Team2_region

LEFT JOIN game g
    ON g.match_id = r.matchID
   AND g.gameset = r.gameset
WHERE g.match_id IS NULL;