library(knitr)
 calendar <- read.table("00-datasets/20162017/calendar_l1_1617.csv", header = T,  
                       stringsAsFactors = F, sep = ",")
load("results20162017.rda")
load("../elo_ranking/eloranks_ts.rda")
load("../elo_ranking/allresults.rda")

res.summary <- table(all.results$FTR)
p.victory <- (sum(res.summary) - res.summary[2]) / sum(res.summary)
p.draw <- 1 - p.victory
p.home <- res.summary[3] / sum(res.summary)
p.away <- res.summary[1] / sum(res.summary)

o <- tail(as.numeric(table(all.results$FTR)), n = 3)
p.homepoints <- (o[3]*3+o[2]) / (o[2] * 2 + (o[1] + o[3])*3)

#parameters
p.elo <- 400

##solve p.homepoints = 1 / (1 + 10**(-x/400))
bias.factor <- -p.elo*(log10((1-p.homepoints)/p.homepoints))
##Check 1 / (1 + 10**(-bias.factor/400))


cur.week <- nrow(season20162017)/10 + 1
cur.games <- calendar[calendar$Week == cur.week, ]
pred <- NULL
for (icg in 1:nrow(cur.games)){
  score.h <- as.numeric(elo.df$Score[max(which(elo.df$Team == cur.games$HomeTeam[icg]))]) + bias.factor
  score.a <- as.numeric(elo.df$Score[max(which(elo.df$Team == cur.games$AwayTeam[icg]))])
  if (score.h > score.a){
    pred <- c(pred, "1")  
  } else if (score.h < score.a){
    pred <- c(pred, "2") 
  } else{
    pred <- c(pred, "N") 
  }
}


cur.idgames <- paste(cur.games$HomeTeam, "-", cur.games$AwayTeam, sep = "")
df2print <- cbind(cur.games, cur.idgames, rep("adndebanane_elo", 10), pred)
df2print <- df2print[, c(4, 5, 6)]
names(df2print) <- c("IdMatch", "Pseudo", "Prono")
kable(df2print[, ], format = "markdown", row.names = F)

cur.idgames <- paste(cur.games$HomeTeam, "-", cur.games$AwayTeam, sep = "")
df2print <- cbind(cur.games, cur.idgames, rep("adndebanane_hasard", 10), sample(c("1", "N", "2"), size = 10, replace = T))
df2print <- df2print[, c(4, 5, 6)]
names(df2print) <- c("IdMatch", "Pseudo", "Prono")
kable(df2print[, ], format = "markdown", row.names = F)
