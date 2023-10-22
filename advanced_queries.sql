-- ADVANCED JOIN QUERIES --
-- Calculates the total goals, assists and shots on target from players in the two leagues
SELECT l.league_name, 
       SUM(s.goals) AS total_goals, 
       SUM(s.assists) AS total_assists,
       SUM(s.shots) AS total_shots,
       SUM(s.shots_on_target) AS total_shots_on_target
FROM teams t
JOIN employees e ON t.team_id = e.team_id AND t.league_id = e.league_id
JOIN players p ON e.employee_id = p.employee_id
JOIN season_statistics s ON p.employee_id = s.player_id
JOIN leagues l ON t.league_id = l.league_id
GROUP BY l.league_name;

-- For each match, display the team names and the city it takes place in (home team city)
SELECT
    m.match_id, c.city_name,
    t_home.team_name AS home_team,
    t_away.team_name AS away_team
FROM matches m
JOIN cities c ON m.home_team_id = c.city_id
JOIN teams t_home ON m.home_team_id = t_home.team_id
JOIN teams t_away ON m.away_team_id = t_away.team_id;

-- Using players' assists, finds the best playmakers in the Premier League
SELECT employees.first_name, employees.last_name, season_statistics.assists, leagues.league_name
FROM season_statistics
JOIN employees ON season_statistics.player_id = employees.employee_id
JOIN leagues on employees.league_id = leagues.league_id
WHERE leagues.league_id=1
ORDER BY season_statistics.assists DESC;

-- Finds matches that are considered high scoring games with a combined minimum score of 5
SELECT
    m.match_id,
    m.match_date,
    t_home.team_name AS home_team,
    t_away.team_name AS away_team,
    m.home_goals,
    m.away_goals
FROM matches m 
JOIN teams t_home ON m.home_team_id = t_home.team_id AND m.league_id = t_home.league_id
JOIN teams t_away ON m.away_team_id = t_away.team_id AND m.league_id = t_away.league_id
AND m.home_goals + m.away_goals > 4;


-- VIEWS --
-- Rank teams by # of wins for each league
CREATE VIEW team_ranking AS
SELECT
    t.league_id, t.team_name, t.wins,
    RANK() OVER(PARTITION BY t.league_id ORDER BY t.wins DESC) AS team_rank
FROM teams t;
--select * from team_ranking;

-- Calculate the average goals scored per match by each team in each league
CREATE VIEW average_goals_per_match AS
SELECT
    l.league_name,
    t.team_name,
    AVG(s.goals) AS avg_goals_per_match
FROM leagues l
JOIN teams t ON l.league_id = t.league_id
JOIN employees e ON t.team_id = e.team_id
JOIN season_statistics s ON e.employee_id = s.player_id
GROUP BY l.league_name, t.team_name;
--select * from average_goals_per_match;

-- Finds the names of all players who have scored over 6 goals
CREATE VIEW top_scorers AS
SELECT employees.first_name, employees.last_name, season_statistics.goals
FROM employees
JOIN season_statistics ON employees.employee_id = season_statistics.player_id
WHERE season_statistics.goals > 6
ORDER by season_statistics.goals DESC;
--select * from top_scorers
