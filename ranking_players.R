load("results20162017.rda")
cur.season <- season20162017
bets <- read.table(file = "00-datasets/20162017/players_bets.csv", header = TRUE, sep = ",", 
                   stringsAsFactors = F)
pot.pergame <- 10 #euros
eta <- 1/8
load("players.rda")
av.win.ratio <- mean(players$wins.ratio)
rm(players)

name.players <- unique(bets$player)
nb.players <- length(name.players)
players <- data.frame(id               = 1:nb.players, 
                      player           = name.players, 
                      profits          = rep(0, nb.players),
                      weights          = rep(1, nb.players),
                      nb.wins          = rep(0, nb.players),
                      wins.ratio       = rep(0, nb.players),
                      nb.match.played  = rep(0, nb.players), 
                      stringsAsFactors = FALSE)
nb.matchs <- nrow(cur.season)
max.played <- sum(unique(bets$idmatch) %in% season20162017$idmatch)


bets <- bets[bets$idmatch %in% cur.season$idmatch,]#only select games with a result

for (iplayer in 1:nb.players){
  played.games <- bets$idmatch[bets$player == players$player[iplayer]]
  games.idres <- match(played.games, cur.season$idmatch)
  cur.results <- cur.season$FTRfrench[games.idres]
  odds <- (cur.results == "1") * cur.season$B365H[games.idres] + 
          (cur.results == "N") * cur.season$B365D[games.idres] + 
          (cur.results == "2") * cur.season$B365A[games.idres] 
  cur.wins <- bets$bet[bets$player == players$player[iplayer]] == cur.season$FTRfrench[games.idres]
  nb.played <- length(games.idres)
  nb.won <- sum(cur.wins)
  cur.profits <- sum(pot.pergame * odds * cur.wins) - pot.pergame * nb.played
  players$profits[iplayer] <- cur.profits
  players$nb.match.played[iplayer] <- nb.played
  players$nb.wins[iplayer] <- nb.won
  players$wins.ratio[iplayer] <- nb.won / nb.played
  players$weights[iplayer] <- players$weights[iplayer] * (1 - eta)**(nb.played - 
                              nb.won + (1 - av.win.ratio)*(max.played - nb.played))
}
players
players$profits / sqrt(players$nb.match.played)
save(players, file = "players.rda")
write.table(players, quote = FALSE, sep = ",", row.names = FALSE,
            file = "00-datasets/20162017/players_rankings.csv")

profits.pergame <- (players$profits/players$nb.match.played)
profits.pergame / max(abs(profits.pergame))
players$wins.ratio
