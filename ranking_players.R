load("results20162017.rda")
cur.season <- season20162017
bets <- read.table(file = "00-datasets/20162017/bets.csv", header = TRUE, sep = ";", 
                   stringsAsFactors = F)
pot.pergame <- 10 #euros

name.players <- unique(bets$expert);
nb.players <- length(name.experts);
players <- data.frame(id               = 1:nb.players, 
                      player           = name.players, 
                      profits          = rep(0, nb.players),
                      nb.wins          = rep(0, nb.players),
                      wins.ratio       = rep(0, nb.players),
                      nb.match.played  = rep(0, nb.players), 
                      stringsAsFactors = FALSE)
nb.matchs <- nrow(cur.season)

for (iplayer in 1:nb.experts){
  played.games <- bets$idmatch[bets$expert == players$player[iplayer]]
  games.idres <- match(played.games, cur.season$idmatch)
  cur.results <- cur.season$results[games.idres]
  odds <- (cur.results == "1") * cur.season$B365H[games.idres] + 
          (cur.results == "N") * cur.season$B365D[games.idres] + 
          (cur.results == "2") * cur.season$B365A[games.idres] 
  cur.wins <- bets$bet[bets$expert == players$player[iplayer]] == cur.season$results[games.idres]
  cur.profits <- sum(pot.pergame * odds * cur.wins) - sum(pot.pergame * (1/odds) * !cur.wins )
  players$profits[iplayer] <- players$profits[iplayer] + cur.profits
  players$nb.match.played[iplayer] <- length(played.games)
  players$nb.wins[iplayer] <- sum(cur.wins)
  players$wins.ratio[iplayer] <- sum(cur.wins) / length(played.games)
}
players
players$profits / sqrt(players$nb.match.played)
save(players, file = "players.rda")

profits.pergame <- (players$profits/players$nb.match.played)
profits.pergame / max(abs(profits.pergame))
players$wins.ratio
