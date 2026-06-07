INSERT INTO `match` (match_id, tournament_id, match_date)
SELECT DISTINCT
    r.MatchID,
    t.tournament_id,
    STR_TO_DATE(r.MatchDate,'%m/%d/%Y')
FROM raw_matches r
JOIN tournament t
    ON t.tournament_name = r.matchType
LEFT JOIN `match` m
    ON m.match_id = r.MatchID
WHERE m.match_id IS NULL;