library(dplyr)
library(ggplot2)
library(lubridate)

logs <- readRDS("logs.rds")
summarise(logs, n())

by_date_version <- group_by(logs, date, r_version)
daily_ver <- summarise(by_date_version, n = n())
daily <- summarise(daily_ver, n = sum(n))

# Daily downloads
qplot(date, n / 1e3, data = daily, geom = "line") + ylab("Downloads (000s)")
ggsave("images/daily.pdf", width = 8, height = 6)

# Daily downloads by version (for top 5 versions)
top5 <- daily_ver %.% group_by(r_version, add = FALSE) %.% 
  summarise(n = sum(n)) %.% arrange(desc(n)) %.% head(5)

daily_common <- semi_join(daily_ver, top5, by = "r_version")

qplot(date, n / 1e3, data = daily_common, geom = "line", colour = r_version) +
  ylab("Downloads (000s)")
ggsave("images/versions.pdf", width = 8, height = 6)
# Something has gone wrong in early October when parsing r versions

packages <- logs %.% group_by(package) %.% summarise(n = n())
qplot(n, data = packages, binwidth = 0.1) +
  scale_x_log10("Number of downloads",
    breaks = 10 ^ (0:5), minor_breaks = log10(c(1:10 %o% 10 ^ (0:5))),
    labels = c("1", "10", "100", "1,000", "10,000", "100,000"))
ggsave("images/packages-dist.pdf", width = 8, height = 4)

packages %.% arrange(desc(n)) %.% head(50)
