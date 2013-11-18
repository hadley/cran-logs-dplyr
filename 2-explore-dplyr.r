library(dplyr)
library(ggplot2)
library(lubridate)

logs <- readRDS("logs.rds")

# Look at the top 20 packages ---------------

by_package <- group_by(logs, package)
packages20 <- head(arrange(summarise(by_package, n = n()), desc(n)), 20)
top20 <- semi_join(logs, packages20, by = "package")

daily_package <- group_by(top20, date, package)
downloads <- summarise(daily_package, n = n())
downloads$date <- as.Date(downloads$date, origin = "1970-01-01")
qplot(date, n, data = downloads, geom = "line", colour = package)

# Users -------

ip_daily <- group_by(logs, date, ip_id)
pkgs <- summarise(ip_daily, n = n()) %.% ungroup() %.% arrange(desc(n)) %.%
  filter(!is.na(ip_id))
pkgs$date <- as.Date(pkgs$date, origin = "1970-01-01")
qplot(n, data = pkgs %.% filter(n < 100))

# Should really weed out all downloads from very high downloaders
# i.e. anything over ~4000 implies multiple downloads of the same 
# package

summarise(pkgs, sum(n > 100), sum(n[n > 100]), sum(n))


poss2 <- semi_join(by_person, poss)

dplyr:::summarise.grouped_df(by_person, sum(package %in% ))

by_day <- group_by(logs, date)


