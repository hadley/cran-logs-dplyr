library(plyr)
library(ggplot2)
library(lubridate)

paths <- dir("logs", pattern = "-r", full.names = TRUE)
all <- ldply(paths, read.csv, stringsAsFactors = FALSE)
all$date <- ymd(all$date)
all$vers <- gsub("\\.(pkg|tar\\.gz)", "", all$vers)

nrow(all)
head(arrange(count(all, "country"), desc(freq)), 10)

os <- count(all, c("date", "os"))
qplot(date, freq, data = os, geom = "line", colour = os)
ggsave("r-os.pdf", width = 10, height = 4)

vers <- count(all, c("date", "vers"))
all_vers <- count(all, "vers")
pop_vers <- match_df(vers, subset(all_vers, freq > 500), on = "vers")

qplot(date, freq, data = pop_vers, geom = "line", colour = vers)
ggsave("r-vers.pdf", width = 10, height = 4)
