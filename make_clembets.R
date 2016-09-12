load("results20162017.rda")
cur.season <- season20162017
bets <- read.table(file = "00-datasets/20162017/players_bets.csv", header = TRUE, sep = ",", 
                   stringsAsFactors = F)
load("players.rda")


##List of games to play with
list.betted.games <- unique(bets$idmatch)
nb.betted.games <- length(list.betted.games)
nb.played.games <- length(cur.season$idmatch)
tobeplayed.games <- list.betted.games[!(list.betted.games %in% cur.season$idmatch)]
nb.tobeplayed.games <- length(tobeplayed.games)

mybets <- data.frame(idmatch            = tobeplayed.games,
                     random.bets        = rep(NA, nb.tobeplayed.games),
                     deterministic.bets = rep(NA, nb.tobeplayed.games),
                     votes              = rep(NA, nb.tobeplayed.games))

##Let's play!
for(igame in 1:nb.tobeplayed.games){
    bets.games <- subset(bets, idmatch == tobeplayed.games[igame])
    vote.1 <- 0
    vote.N <- 0
    vote.2 <- 0
    for(ibet in 1:length(bets.games$bet)){
      cur.player <- bets.games$player[ibet]
      cur.weight <- players$weights[players$player == cur.player]
        if(bets.games$bet[ibet] == 1){
            vote.1 <- vote.1 + cur.weight
       } else if(bets.games$bet[ibet] == 2){
            vote.2 <- vote.2 + cur.weight
       } else{
            vote.N <- vote.N + cur.weight
       }
    }
    weight.distribution <- c(vote.1, vote.N, vote.2) / sum(c(vote.1, vote.N, vote.2))
    mybets$random.bets[igame] <- sample(c(1, "N", 2), 1, prob = weight.distribution)
    mybets$deterministic.bets[igame] <- c(1, "N", 2)[which.max(c(vote.1, vote.N, vote.2))]
    mybets$votes[igame] <- max(c(vote.1, vote.N, vote.2))
}
print(mybets)
oldbets <- mybets
write.table(oldbets, file = "00-datasets/20162017/clembets.csv", sep = ",", row.names = FALSE, 
            col.names = FALSE, append = TRUE)
library(knitr)
df2print <- mybets[, c("idmatch", "deterministic.bets", "votes")]
names(df2print) <- c("IdMatch", "Prono", "Votes")
kable(df2print[, ], format = "markdown", row.names = F)
