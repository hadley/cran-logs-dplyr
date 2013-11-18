library(dplyr)
library(ggplot2)
library(lubridate)

logs <- readRDS("logs.rds")
logs <- tbl_cpp(logs)
summarise(logs, n())

rcpp <- filter(logs, package == "Rcpp")
by_day_os <- group_by(rcpp, date, r_os)
counts <- summarise(by_day_os, n = n())

oses <- arrange(summarise(group_by(rcpp, r_os), n = n()), desc(n))
counts_pop <- semi_join(counts, subset(oses, n > 4000), by = "r_os")

qplot(date, n, data = counts_pop, geom = "line", colour = r_os)
