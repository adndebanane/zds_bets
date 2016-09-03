load("results20162017.rda")
cur.season <- season20162017
teams <- unique(cur.season$HomeTeam)
nb.teams <- length(teams)

team.ranking <- data.frame(Teams          = teams, 
                           GamesPlayed    = rep(0, nb.teams), 
                           Won            = rep(0, nb.teams),
                           Drawn          = rep(0, nb.teams),
                           Lost           = rep(0, nb.teams),
                           GoalsFor       = rep(0, nb.teams),
                           GoalsAgainst   = rep(0, nb.teams),
                           GoalDifference = rep(0, nb.teams),
                           Points         = rep(0, nb.teams),
                           stringsAsFactors = FALSE)

for(iteam in 1:nb.teams){
  cur.team <- team.ranking$Teams[iteam]
  is.hometeam <- cur.season$HomeTeam == cur.team
  is.awayteam <- cur.season$AwayTeam == cur.team
  is.playing <- (is.hometeam) + (is.awayteam)
  
  team.ranking$GamesPlayed[iteam] <- sum(is.playing)
  team.ranking$Won[iteam] <- sum(is.hometeam & (cur.season$FTR == "H")) +
                             sum(is.awayteam & (cur.season$FTR == "A"))
  team.ranking$Drawn[iteam] <- sum(is.playing & (cur.season$FTR == "D"))
  team.ranking$Lost[iteam] <- team.ranking$GamesPlayed[iteam] - 
                              team.ranking$Won[iteam] - 
                              team.ranking$Drawn[iteam]
  team.ranking$GoalsFor[iteam] <- sum(cur.season$FTHG[is.hometeam]) + 
                                  sum(cur.season$FTAG[is.awayteam])
  team.ranking$GoalsAgainst[iteam] <- sum(cur.season$FTAG[is.hometeam]) +
                                      sum(cur.season$FTHG[is.awayteam])
  team.ranking$GoalDifference[iteam] <- team.ranking$GoalsFor[iteam] -
                                        team.ranking$GoalsAgainst[iteam]
  team.ranking$Points[iteam] <- team.ranking$Won[iteam] * 3 + team.ranking$Drawn[iteam]
}

sorted.table <- team.ranking[with(team.ranking, order(Points, GoalDifference, GoalsFor, decreasing = T)), ]
write.table(sorted.table, quote = FALSE, sep = ";", file = "00-datasets/20162017/team_rankings.csv")
save(sorted.table, file = "team_rankings.rda")
