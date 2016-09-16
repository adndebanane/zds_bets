# zdsbets 

zdsbets is a R programme providing tools to analyse and predict the outcome of football game in the French Ligue 1.

The tools are:

- [elo ranking](http://clubelo.com/), computed in elo.R and use to make predictions in make_elobets.R
- an online machine learning algorithm, using predictions of players (weighted by player performances, computed in ranking_players.R) to make new predictions (make_clembets.R).
- make_results.R update results of Ligue 1 from http://football-data.co.uk
- ranking_teams.R computes tables of Ligue 1 results
- index.Rmd combines all previous results in one web page https://adndebanane.github.io/zdsbets/

To play the game, you are very welcome to join us! You need to speak French and to sign up to https://zestedesavoir.com/forums/ bulletin board. The game/workshop [is played here](https://zestedesavoir.com/forums/sujet/999/atelier-paris-sportifs-et-intelligence-collective/)
