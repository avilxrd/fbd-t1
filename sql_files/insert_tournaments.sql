-- tournaments
INSERT INTO tournament (tournament_name)
SELECT DISTINCT r.matchType
FROM raw_matches r
--
LEFT JOIN tournament t
    ON t.tournament_name = r.matchType
WHERE t.tournament_id IS NULL;