INSERT INTO ban (
    match_id,
    gameset,
    team_id,
    ban_order,
    champion_id
)

SELECT
    b.matchID,
    b.gameset,
    t.team_id,
    b.ban_order,
    c.champion_id
FROM (
    SELECT matchID, gameset, Team1 AS team, Team1_region AS region, 1 AS ban_order, Team1_ban1 AS champion FROM raw_matches
    UNION ALL SELECT matchID, gameset, Team1, Team1_region, 2, Team1_ban2 FROM raw_matches
    UNION ALL SELECT matchID, gameset, Team1, Team1_region, 3, Team1_ban3 FROM raw_matches
    UNION ALL SELECT matchID, gameset, Team1, Team1_region, 4, Team1_ban4 FROM raw_matches
    UNION ALL SELECT matchID, gameset, Team1, Team1_region, 5, Team1_ban5 FROM raw_matches

    UNION ALL

    SELECT matchID, gameset, Team2, Team2_region, 1, Team2_ban1 FROM raw_matches
    UNION ALL SELECT matchID, gameset, Team2, Team2_region, 2, Team2_ban2 FROM raw_matches
    UNION ALL SELECT matchID, gameset, Team2, Team2_region, 3, Team2_ban3 FROM raw_matches
    UNION ALL SELECT matchID, gameset, Team2, Team2_region, 4, Team2_ban4 FROM raw_matches
    UNION ALL SELECT matchID, gameset, Team2, Team2_region, 5, Team2_ban5 FROM raw_matches
) b

JOIN team t
    ON TRIM(t.team_name) = TRIM(b.team)
   AND TRIM(t.team_region) = TRIM(b.region)

JOIN champion c
    ON TRIM(c.champion_name) = TRIM(b.champion)

LEFT JOIN ban existing
    ON existing.match_id = b.matchID
   AND existing.gameset = b.gameset
   AND existing.team_id = t.team_id
   AND existing.ban_order = b.ban_order

WHERE existing.match_id IS NULL;