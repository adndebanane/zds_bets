load("allresults.rda")

res.summary <- table(all.results$FTR)
p.victory <- (sum(res.summary) - res.summary[2]) / sum(res.summary)
p.draw <- 1 - p.victory
p.home <- res.summary[3] / sum(res.summary)
p.away <- res.summary[1] / sum(res.summary)

o <- tail(as.numeric(table(all.results$FTR)), n = 3)
p.homepoints <- (o[3]*3+o[2]) / (o[2] * 2 + (o[1] + o[3])*3)

#parameters
p.elo <- 400
k.elo <- 37.81

##solve p.homepoints = 1 / (1 + 10**(-x/400))
bias.factor <- -p.elo*(log10((1-p.homepoints)/p.homepoints))
##Check 1 / (1 + 10**(-bias.factor/400))

compute.elo <- function(score.h, score.a, h.result, f = bias.factor, k = k.elo, p = p.elo){
  exp.res <- 1 / (1 + 10**((score.a - score.h - f)/p))
  score.h.new <- score.h + k * (h.result - exp.res)   
  score.a.new <- score.a + k * (exp.res - h.result)
  return(c(score.h.new, score.a.new))
}

team.list <- sort(unique(all.results$HomeTeam))
nb.team <- length(team.list)
elo.ranking <- matrix(nrow = nrow(all.results) / 10 + 1, ncol = length(team.list), 
                      dimnames = list(NULL, team.list))
elo.idate <- elo.ranking
elo.ranking[1, ] <- 1500

elo.idate[1, ] <- all.results$Date[1] - 1

elo.df <- data.frame(Date = rep(as.Date(NA), nrow(all.results) *2), 
                     Team = rep(NA, nrow(all.results) *2), 
                      Score = rep(NA, nrow(all.results) *2))

k.y <- c(60, 20)
k.x <- c(1, 38)
k.m <- lm(k.y ~ k.x)

o.h.vec <- NULL
o.a.vec <- NULL
o.d.vec <- NULL
o.pred <- NULL
o.pred.B365 <- NULL
o.pred.random <- NULL
o.pred.w.random <- NULL

bets <- c("H", "D", "A")

elo.diff.h <- NULL
elo.diff.a <- NULL
elo.diff.d <- NULL
elo.diff <- NULL
elo.chance.diff <- NULL
idf <- 1
for (igame in 1:nrow(all.results)){
  home.team <- all.results$HomeTeam[igame]  
  away.team <- all.results$AwayTeam[igame]
  game.res <- all.results$FTR[igame]
  game.week <- all.results$week[igame]

  last.index.h <- min(which(is.na(elo.ranking[, paste(home.team, sep = "")]))) - 1
  last.index.a <- min(which(is.na(elo.ranking[, paste(away.team, sep = "")]))) - 1  
  elo.h <- elo.ranking[last.index.h, paste(home.team, sep = "")]
  elo.a <- elo.ranking[last.index.a, paste(away.team, sep = "")]
  d.ha <- elo.h + bias.factor - elo.a #ifelse(elo.h == elo.a, 1, abs(elo.h - elo.a))
  elo.diff <- c(elo.diff, abs(d.ha))
  ##compute odds for home
  max.elo <- max(elo.h + bias.factor, elo.a)
  
  chance.home <- 1 / (1 + 10**(-d.ha / p.elo))
  chance.away <- 1 / (1 + 10**(d.ha / p.elo))
  
  elo.chance.diff <- c(elo.chance.diff, abs(chance.home - 1/2))

  o.pred <- c(o.pred, bets[c(1, 3)][which.max(c(chance.home, chance.away))])

  if (!is.na(all.results$B365H[igame])){
    o.pred.B365 <- c(o.pred.B365, bets[which.min(c(all.results$B365H[igame], 
                                                 all.results$B365D[igame],
                                                 all.results$B365A[igame]))])
  } else {
    o.pred.B365 <- c(o.pred.B365, NA)  
  }
  
  if (game.res == "H"){
    home.res <- 1  
    elo.diff.h <- c(elo.diff.h, elo.h + bias.factor - elo.a)
  } else if (game.res == "A"){
    home.res <- 0
    elo.diff.a <- c(elo.diff.a, elo.a - (elo.h + bias.factor))
  } else {
    home.res <- 0.5 
    elo.diff.d <- c(elo.diff.d, elo.h + bias.factor - elo.a)
  }
  
  ##compute elo ranking
  elo.res <- compute.elo(elo.h, elo.a, home.res, k = k.elo, p = p.elo)
  elo.ranking[last.index.h + 1, paste(home.team, sep = "")] <- elo.res[1]
  elo.ranking[last.index.a + 1, paste(away.team, sep = "")] <- elo.res[2]
  elo.idate[last.index.h + 1, paste(home.team, sep = "")] <- igame
  elo.idate[last.index.a + 1, paste(away.team, sep = "")] <- igame
  elo.df$Date[idf] <- all.results$Date[igame]
  elo.df$Date[idf + 1] <- all.results$Date[igame]
  elo.df[idf, c("Team", "Score")] <- c(home.team, elo.res[1])
  elo.df[idf + 1, c("Team", "Score")] <- c(away.team, elo.res[2])
  idf <- idf + 2
}

save(elo.df, file = "eloranks_ts.rda")