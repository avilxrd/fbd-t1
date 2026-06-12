insert into team (team_name, team_region)
select distinct t.team_name, t.team_region
from (
    select Team1 as team_name, Team1_region as team_region
    from raw_matches

    union

    select Team2 as team_name, Team2_region as team_region
    from raw_matches
) t

left join team existing
    on existing.team_name = t.team_name
    and existing.team_region = t.team_region
    where existing.team_name is null;