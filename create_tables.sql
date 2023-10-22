create table cities(
    city_id NUMBER primary key,
    city_name varchar(60),
    region varchar(60),
    country varchar(60)
);

create table leagues(
    league_id NUMBER primary key,
    league_name varchar(60),
    division varchar(60)
);

create table referees(
    referee_id NUMBER primary key,
    league_id NUMBER NOT NULL references leagues(league_id),
    first_name varchar(25),
	last_name varchar(25) NOT NULL,
    date_joined DATE NOT NULL
);

create table teams(
    team_id NUMBER primary key,
    league_id NUMBER NOT NULL references leagues(league_id),
    name VARCHAR(60) NOT NULL,
    wins NUMBER DEFAULT 0,
    losses NUMBER DEFAULT 0,
    draws NUMBER DEFAULT 0,
    city_id NUMBER references cities(city_id),
    date_founded DATE NOT NULL
);

create table employees(
    employee_id NUMBER primary key,
    first_name varchar(25),
	last_name varchar(25) NOT NULL,
    age NUMBER NOT NULL,
    city NUMBER NOT NULL references cities(city_id),
    date_born DATE NOT NULL,
    team_id NUMBER NOT NULL references teams(team_id),
    date_joined DATE NOT NULL
);

create table players (
	employee_id NUMBER primary key references employees(employee_id),
    weight_kgs NUMBER NOT NULL,
    height_cms NUMBER NOT NULL,
	kit_number NUMBER NOT NULL check(kit_number between 0 and 99),
	position varchar(15) NOT NULL check(
		position = 'Goalkeeper' OR 
        position = 'Defender' OR 
        position = 'Midfielder' OR 
        position = 'Attackers')
);

create table season_statistics(
    player_id NUMBER references players(employee_id),
    shots NUMBER DEFAULT 0,
    shots_on_target NUMBER DEFAULT 0,
    goals NUMBER DEFAULT 0,
    assists NUMBER DEFAULT 0,
    passses NUMBER DEFAULT 0,
    fouls NUMBER DEFAULT 0
);

create table coaches(
    employee_id NUMBER primary key references employees(employee_id)
);

create table managers(
    employee_id NUMBER primary key references employees(employee_id)
);

create table matches(
    match_id NUMBER NOT NULL,
    league_id NUMBER NOT NULL references leagues(league_id),
    referee_id NUMBER NOT NULL references referees(referee_id),
    match_date DATE NOT NULL,
    home_team_id NUMBER NOT NULL references teams(team_id),
    away_team_id NUMBER NOT NULL references teams(team_id),
    home_goals NUMBER NOT NULL,
    away_goals NUMBER NOT NULL
);