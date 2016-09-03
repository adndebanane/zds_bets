library(knitr)
calendar <- read.table("00-datasets/20162017/calendar_l1_1617.csv", header = T,  
                       stringsAsFactors = F, sep = ",")
load("results20162017.rda")
cur.week <- nrow(season20162017)/10 + 1
df2print <- cbind(calendar[calendar$Week == cur.week, ], rep("pseudo", 10), rep("", 10))
names(df2print) <- c("Domicile", "Visiteur", "Week", "Pseudo", "Prono")
kable(df2print[, -3], format = "markdown", row.names = F)
