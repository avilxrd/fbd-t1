INSERT INTO game_team (match_id, gameset, team_id, barons, dragons, turrets)

SELECT
    gt.match_id,
    gt.gameset,
    gt.team_id,
    gt.barons,
    gt.dragons,
    gt.turrets
FROM (
    SELECT
        r.matchID AS match_id,
        r.gameset,
        t.team_id,
        r.Team1_Baron AS barons,
        r.Team1_Dra AS dragons,
        r.Team1_Turts AS turrets
    FROM raw_matches r
    JOIN team t
        ON t.team_name = r.Team1
       AND t.team_region = r.Team1_region

    UNION ALL

    SELECT
        r.matchID AS match_id,
        r.gameset,
        t.team_id,
        r.Team2_Baron,
        r.Team2_Dra,
        r.Team2_Turts
    FROM raw_matches r
    JOIN team t
        ON t.team_name = r.Team2
       AND t.team_region = r.Team2_region
) gt
LEFT JOIN game_team existing
    ON existing.match_id = gt.match_id
   AND existing.gameset = gt.gameset
   AND existing.team_id = gt.team_id
WHERE existing.match_id IS NULL;