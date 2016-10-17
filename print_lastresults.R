library(knitr)
load("results20162017.rda")
cur.season <- tail(season20162017, n = 10)
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
nb.matchs <- 10
max.played <- sum(unique(bets$idmatch) %in% season20162017$idmatch)

last.games <- tail(cur.season$idmatch, n = 10)
bets <- bets[bets$idmatch %in% last.games, ]#only select games with a result

for (iplayer in 1:nb.players){
  played.games <- bets$idmatch[bets$player == players$player[iplayer]]
  games.idres <- match(played.games, last.games)
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

df2print <- players[with(players, order(wins.ratio, profits, decreasing = TRUE)), 
          c("player", "profits", "nb.wins", "wins.ratio")]
names(df2print) <- c("Joueur", "Gains (€)", "Nb de victoires", "Ratio de Victoires")
kable(df2print[, ], format = "markdown", row.names = F)
