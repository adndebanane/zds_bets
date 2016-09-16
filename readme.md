# zdsbets 

zdsbets is a R program providing tools to analyse and predict the outcome of football games in the French Ligue 1.
It is currently used in a game played on the French https://zestedesavoir.com/forums/ bulletin board. 
If you speak French, you are very welcome to join us! 
The game/workshop [is played here](https://zestedesavoir.com/forums/sujet/999/atelier-paris-sportifs-et-intelligence-collective/).
The goal for players is to make the best bets regarding football games played in France using their instinct or statistical tools.
All bets are then used by an algorithm trying to make sense of the [wisdom of the crowd](https://en.wikipedia.org/wiki/Wisdom_of_the_crowd) involved in the game.

The tools are:

- [elo ranking](http://clubelo.com/), computed in elo.R and use to make predictions in make_elobets.R
- an online machine learning algorithm, using predictions of players (weighted by player performances, computed in ranking_players.R) to make new predictions (make_clembets.R).

Other files:

- make_results.R update results of Ligue 1 from http://football-data.co.uk
- ranking_teams.R computes tables of Ligue 1 results
- index.Rmd combines all previous results in one web page https://adndebanane.github.io/zdsbets/
