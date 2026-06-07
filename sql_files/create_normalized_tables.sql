drop table if exists player_game_stats;
drop table if exists player;
drop table if exists ban;
drop table if exists game_team;
drop table if exists game;
drop table if exists `match`;
drop table if exists champion;
drop table if exists team;
drop table if exists tournament;

-- champion
create table if not exists champion (
    champion_id int auto_increment primary key,
    champion_name varchar(50) not null unique
);

-- team
create table if not exists team (
    team_id int auto_increment primary key,
    team_name varchar(100) not null,
    team_region varchar(10) not null,
    unique (team_name , team_region)
);

-- player
create table if not exists player (
    player_id int auto_increment primary key,
    player_name varchar(100) not null
);

-- tournament
create table if not exists tournament (
    tournament_id int auto_increment primary key,
    tournament_name varchar(200) not null unique
);

-- match
create table if not exists `match` (
    match_id int primary key,
    tournament_id int not null,
    match_date date not null,
    foreign key (tournament_id)
        references tournament (tournament_id)
);

-- game
create table if not exists game (
    match_id int not null,
    gameset int not null,
    duration time not null,
    winner_id int not null,
    primary key (match_id , gameset),
    foreign key (match_id)
        references `match` (match_id),
    foreign key (winner_id)
        references team (team_id)
);

-- game_team
create table if not exists game_team (
    match_id int not null,
    gameset int not null,
    team_id int not null,
    barons int not null,
    dragons int not null,
    turrets int not null,
    primary key (match_id , gameset , team_id),
    foreign key (match_id , gameset)
        references game (match_id , gameset),
    foreign key (team_id)
        references team (team_id)
);

-- ban
create table if not exists ban (
    match_id int not null,
    gameset int not null,
    team_id int not null,
    ban_order int not null,
    champion_id int not null,
    primary key (match_id , gameset , team_id , ban_order),
    foreign key (match_id , gameset)
        references game (match_id , gameset),
    foreign key (team_id)
        references team (team_id),
    foreign key (champion_id)
        references champion (champion_id),
    check (ban_order between 1 and 5)
);

-- player_game_stats
create table if not exists player_game_stats (
    match_id int not null,
    gameset int not null,
    player_id int not null,
    team_id int not null,
    champion_id int not null,

    role varchar(10) not null,

    kills int not null,
    deaths int not null,
    assists int not null,

    farm int not null,
    gold int not null,
    damage int not null,
    tanking int not null,

    primary key (match_id , gameset , player_id),
    foreign key (match_id , gameset)
        references game (match_id , gameset),
    foreign key (player_id)
        references player (player_id),
    foreign key (team_id)
        references team (team_id),
    foreign key (champion_id)
        references champion (champion_id),
    check (role in ('TOP' , 'JUG', 'MID', 'ADC', 'SUP'))
);