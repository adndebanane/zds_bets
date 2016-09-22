library(knitr)
calendar <- read.table("00-datasets/20162017/calendar_l1_1617.csv", header = T,  
                       stringsAsFactors = F, sep = ",")
load("results20162017.rda")
cur.week <- nrow(season20162017)/10 + 1
cur.games <- calendar[calendar$Week == cur.week, ]
cur.idgames <- paste(cur.games$HomeTeam, "-", cur.games$AwayTeam, sep = "")
df2print <- cbind(cur.games, cur.idgames, rep("pseudo", 10), rep("", 10))
df2print <- df2print[, c(4, 5, 6)]
names(df2print) <- c("IdMatch", "Pseudo", "Prono")
kable(df2print[, ], format = "markdown", row.names = F)

load("players.rda")
df2print <- players[with(players, order(wins.ratio, profits, decreasing = TRUE)), 
          c("player", "profits", "weights", "nb.wins", "wins.ratio", "nb.match.played")]
names(df2print) <- c("Joueur", "Gains (€)", "Poids", "Nb de victoires", "Ratio de Victoires", "Nb de matchs")
kable(df2print[, ], format = "markdown", row.names = F)
