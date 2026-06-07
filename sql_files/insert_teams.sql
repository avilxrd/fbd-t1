INSERT INTO team (team_name, team_region)
SELECT DISTINCT t.team_name, t.team_region
FROM (
    SELECT Team1 AS team_name, Team1_region AS team_region
    FROM raw_matches

    UNION

    SELECT Team2 AS team_name, Team2_region AS team_region
    FROM raw_matches
) t
LEFT JOIN team existing
    ON existing.team_name = t.team_name
   AND existing.team_region = t.team_region
WHERE existing.team_name IS NULL;