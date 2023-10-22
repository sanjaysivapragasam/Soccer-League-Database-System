-- Count all the cities in each region
SELECT COUNT(city_name), region
FROM cities
GROUP BY region;

-- Select the league that the 'Rising Tigers' team belongs to, and display the league name and division
SELECT league_name, division
FROM leagues, teams
WHERE team_name = 'Rising Tigers'
AND leagues.league_id = teams.league_id;

-- Select all teams in 'Division A' who have more wins than losses
-- Display their team name, city name, wins, losses, and draws
SELECT team_name, city_name, wins, losses, draws
FROM teams, cities
WHERE EXISTS(
    SELECT league_id
    FROM leagues
    WHERE teams.league_id = leagues.league_id
    AND leagues.division = 'Division A'
)
AND teams.city_id = cities.city_id
AND teams.wins > teams.losses;

-- Finds the id of all managers who joined their club between 2022 and 2023
SELECT
    m.employee_id,
    e.first_name,
    e.last_name
FROM managers m, employees e 
WHERE m.employee_id = e.employee_id
AND e.date_joined > TO_DATE('2022-01-01', 'YYYY-MM-DD')
AND e.date_joined < TO_DATE('2023-01-01', 'YYYY-MM-DD')
ORDER BY first_name ASC;


-- Finds the names of all referees in the premier league who have potentially favoured the home team
SELECT DISTINCT first_name, last_name
FROM referees, matches 
WHERE referees.referee_id = matches.referee_id
AND matches.home_team_id = 1
AND matches.league_id = 1
AND matches.home_goals >= matches.away_goals;

-- Lists players who have scored at least 5 goals and assisted at least 3
SELECT
    employees.first_name,
    employees.last_name,
    season_statistics.goals,
    season_statistics.assists
FROM employees, season_statistics
WHERE employees.employee_id = season_statistics.player_id
AND season_statistics.goals >= 5
AND season_statistics.assists >= 3
ORDER BY goals DESC;


-- Finds matches that are considered high scoring games with a combined minimum score of 5
SELECT
    m.match_id,
    m.match_date,
    t_home.team_name AS home_team,
    t_away.team_name AS away_team,
    m.home_goals,
    m.away_goals
FROM matches m, teams t_home, teams t_away
WHERE m.home_team_id = t_home.team_id
AND m.league_id = t_home.league_id
AND m.away_team_id = t_away.team_id
AND m.league_id = t_away.league_id
AND m.home_goals + m.away_goals > 4
GROUP BY m.match_date, t_home.team_name,t_away.team_name, m.home_goals, m.away_goals, m.match_id
ORDER BY m.match_id;


-- Displays the players with best passing accuracy in descending order
SELECT
    p.employee_id,
    e.team_id,
    e.first_name,
    e.last_name,
    s.passes,
    CASE
        WHEN s.passes + s.fouls = 0 THEN 0
        ELSE s.passes / (s.passes + s.fouls)
    END AS passing_accuracy
FROM players p, employees e, season_statistics s
WHERE p.employee_id = e.employee_id
AND p.employee_id = s.player_id
ORDER BY passing_accuracy DESC;

-- Lists coaches in descending order based on who has the most wins
SELECT
    leagues.league_name,
    e.first_name,
    e.last_name,
    t.team_name AS coached_team,
    t.wins AS team_wins
FROM coaches c, employees e, teams t, leagues
WHERE c.employee_id = e.employee_id
AND e.team_id = t.team_id
AND e.league_id = t.league_id
AND e.league_id = leagues.league_id
GROUP BY leagues.league_name, e.first_name, e.last_name, t.team_name, t.wins
ORDER BY t.team_name;