-- Seleciona todos os nomes dos campeões e diz quantas vezes foram selecionados, ordenando pela quantidade, do maior para o menor.
SELECT
    c.champion_name,
    COUNT(jp.match_id) AS picks
FROM champion c
LEFT JOIN player_game_stats jp
    ON jp.champion_id = c.champion_id
GROUP BY c.champion_id, c.champion_name
ORDER BY picks DESC, c.champion_id;


-- Seleciona as equipes com pelo menos 20 jogos e as médias de ouro das mesmas, retornando a região e o número total de partidas.
SELECT
    t.team_name,
    t.team_region,
    ROUND(AVG(pgs.gold), 2) AS media_gold,
    COUNT(DISTINCT CONCAT(pgs.match_id, '-', pgs.gameset)) AS jogos
FROM player_game_stats pgs
JOIN team t
    ON t.team_id = pgs.team_id
GROUP BY t.team_id, t.team_name, t.team_region
HAVING COUNT(DISTINCT CONCAT(pgs.match_id, '-', pgs.gameset)) >= 20
ORDER BY media_gold DESC;


-- Mostra os jogadores com mais campeões diferentes e o seu número de partidas em ordem, com pelo menos 50 jogos.
SELECT
    p.player_name,
    COUNT(DISTINCT c.champion_id) AS campeoes_diferentes,
    COUNT(*) AS partidas
FROM player_game_stats pgs
JOIN player p
    ON p.player_id = pgs.player_id
JOIN champion c
    ON c.champion_id = pgs.champion_id
JOIN game g
    ON g.match_id = pgs.match_id
   AND g.gameset = pgs.gameset
JOIN team t
    ON t.team_id = pgs.team_id
GROUP BY
    p.player_id,
    p.player_name
HAVING COUNT(*) >= 50
ORDER BY campeoes_diferentes DESC;


-- Seleciona os jogadores com mais de 50 partidas e o seu número de partidas.
SELECT p.player_name, COUNT(*) AS qtd_partidas
FROM player p
JOIN player_game_stats pgs ON p.player_id = pgs.player_id WHERE p.player_id IN
   (SELECT player_id
    FROM player_game_stats
    GROUP BY player_id
    HAVING COUNT(*) > 50)
GROUP BY p.player_id;


-- Seleciona todos os campeões com maior KDA médio por rota, tendo no mínimo 20 partidas.
(
    SELECT
        'TOP' AS lane,
        c.champion_name AS champion,
        ROUND(
            (SUM(pgs.kills) + SUM(pgs.assists))
            / NULLIF(SUM(pgs.deaths), 0),
            2
        ) AS kda
    FROM player_game_stats pgs
    JOIN champion c
        ON c.champion_id = pgs.champion_id
    WHERE pgs.role = 'TOP'
    GROUP BY c.champion_id, c.champion_name
    HAVING COUNT(*) >= 20
    ORDER BY kda DESC
    LIMIT 1
)

UNION

(
    SELECT
        'JUG' AS lane,
        c.champion_name,
        ROUND(
            (SUM(pgs.kills) + SUM(pgs.assists))
            / NULLIF(SUM(pgs.deaths), 0),
            2
        ) AS kda
    FROM player_game_stats pgs
    JOIN champion c
        ON c.champion_id = pgs.champion_id
    WHERE pgs.role = 'JUG'
    GROUP BY c.champion_id, c.champion_name
    HAVING COUNT(*) >= 20
    ORDER BY kda DESC
    LIMIT 1
)

UNION

(
    SELECT
        'MID' AS lane,
        c.champion_name,
        ROUND(
            (SUM(pgs.kills) + SUM(pgs.assists))
            / NULLIF(SUM(pgs.deaths), 0),
            2
        ) AS kda
    FROM player_game_stats pgs
    JOIN champion c
        ON c.champion_id = pgs.champion_id
    WHERE pgs.role = 'MID'
    GROUP BY c.champion_id, c.champion_name
    HAVING COUNT(*) >= 20
    ORDER BY kda DESC
    LIMIT 1
)

UNION

(
    SELECT
        'ADC' AS lane,
        c.champion_name,
        ROUND(
            (SUM(pgs.kills) + SUM(pgs.assists))
            / NULLIF(SUM(pgs.deaths), 0),
            2
        ) AS kda
    FROM player_game_stats pgs
    JOIN champion c
        ON c.champion_id = pgs.champion_id
    WHERE pgs.role = 'ADC'
    GROUP BY c.champion_id, c.champion_name
    HAVING COUNT(*) >= 20
    ORDER BY kda DESC
    LIMIT 1
)

UNION

(
    SELECT
        'SUP' AS lane,
        c.champion_name,
        ROUND(
            (SUM(pgs.kills) + SUM(pgs.assists))
            / NULLIF(SUM(pgs.deaths), 0),
            2
        ) AS kda
    FROM player_game_stats pgs
    JOIN champion c
        ON c.champion_id = pgs.champion_id
    WHERE pgs.role = 'SUP'
    GROUP BY c.champion_id, c.champion_name
    HAVING COUNT(*) >= 20
    ORDER BY kda DESC
    LIMIT 1
); 