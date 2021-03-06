#download results of ligue 1 from football-data.co.uk
system("curl -o all_results20162017.csv http://www.football-data.co.uk/mmz4281/1617/F1.csv")

season20132014 <- read.table(file = "00-datasets/20162017/all_results20132014.csv", sep = ",", 
                          header = T, stringsAsFactors = F)
season20142015 <- read.table(file = "00-datasets/20162017/all_results20142015.csv", sep = ",", 
                          header = T, stringsAsFactors = F)
season20152016 <- read.table(file = "00-datasets/20162017/all_results20152016.csv", sep = ",", 
                          header = T, stringsAsFactors = F)
season20162017 <- read.table(file = "all_results20162017.csv", sep = ",", 
                             header = T, stringsAsFactors = F)
all.results <- rbind(season20132014[, c("Date", "HomeTeam", "AwayTeam", "FTR", "FTHG", "FTAG", "B365H", "B365D", "B365A")],
                     season20142015[, c("Date", "HomeTeam", "AwayTeam", "FTR", "FTHG", "FTAG", "B365H", "B365D", "B365A")],
                     season20152016[, c("Date", "HomeTeam", "AwayTeam", "FTR", "FTHG", "FTAG", "B365H", "B365D", "B365A")],
                     season20162017[, c("Date", "HomeTeam", "AwayTeam", "FTR", "FTHG", "FTAG", "B365H", "B365D", "B365A")])
all.results$week <- rep(1:(nrow(all.results) / 10), each = 10)
all.results$Date <- as.Date(all.results$Date, format = "%d/%m/%y")
save(all.results, file = "allresults.rda")


season20162017 <- season20162017[, c("Date", "HomeTeam", "AwayTeam", "FTR", "FTHG", "FTAG", "B365H", "B365D", "B365A")]
season20162017$Date <- as.Date(season20162017$Date, format = "%d/%m/%y")
season20162017$idmatch <- paste(season20162017$HomeTeam, "-", season20162017$AwayTeam, sep = "")
season20162017$FTRfrench <- season20162017$FTR
season20162017$FTRfrench[season20162017$FTR == "H"] <- 1
season20162017$FTRfrench[season20162017$FTR == "D"] <- "N"
season20162017$FTRfrench[season20162017$FTR == "A"] <- 2
save(season20162017, file = "results20162017.rda")
write.table(season20162017, file = "00-datasets/20162017/results_l1_1617.csv", 
            sep = ",", quote = FALSE, row.names = FALSE)
system("rm all_results20162017.csv")

