library(dplyr)
library(ggplot2)
library(lubridate)

logs <- readRDS("logs.rds")
logs <- tbl_cpp(logs)
summarise(logs, n())

by_day <- group_by(logs, date)
out <- summarise(by_day, n = n(), users = max(ip_id))
out

out$wday <- wday(out$date, label = TRUE)

qplot(date, n, data = out, geom = "line") + geom_smooth(se = F, size = 2) + 
  labs(x = NULL, y = "Package downloads")
ggsave("cran-downloads.pdf", width = 8, height = 6)

qplot(date, users, data = out, geom = "line") + geom_smooth(se = F)

out$n2 <- 10 ^ resid(lm(log10(n) ~ wday, data = out))
out$users2 <- 10 ^ resid(lm(log10(users) ~ wday, data = out))
qplot(date, n2, data = out, geom = "line")

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


# st511: can you find Charlotte's students? 
# They downloaded ggplot2, openintro and Sleuth2
recent <- filter(logs, date > as.Date("2013-09-25"))
by_person <- group_by(recent, date, ip_id)

used_by <- filter(by_person, package %in% c("ggplot2", "openintro", "Sleuth2", "evaluate", "knitr"))
poss <- filter(summarise(used_by, n = n()), n >= 3)

qplot(as.Date(date, origin = "1970-01-01"), n, data = summarise(poss, n = sum(n)), geom = "line")



poss2 <- semi_join(by_person, poss)

dplyr:::summarise.grouped_df(by_person, sum(package %in% ))

by_day <- group_by(logs, date)


