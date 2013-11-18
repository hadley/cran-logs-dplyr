library(plyr)
library(ggplot2)
library(lubridate)
source("db.r")

n <- exec_sql("SELECT count(*) as count FROM logs")


time <- exec_sql("SELECT date, count(*) as count FROM logs GROUP BY date")
qplot(date, count / 1e3, data = time, geom = "line") + ylab("Downloads (000s)")
ggsave("daily.pdf", width = 8, height = 6)

vers <- exec_sql("
  SELECT date, r_version, count(*) as count
  FROM logs
  WHERE r_version IN ('3.0.0', '2.15.3', '2.15.2')
  GROUP BY date, r_version;")
qplot(date, count / 1e3, data = vers, geom = "line", colour = r_version) +
  ylab("Downloads (000s)")
ggsave("versions.pdf", width = 8, height = 6)

packages <- exec_sql("SELECT package, count(*) as count FROM logs GROUP BY package")
qplot(count, data = packages, binwidth = 100)
qplot(count, data = packages, binwidth = 0.01) +
  scale_x_log10("Number of downloads",
    breaks = 10 ^ (0:5), minor_breaks = log10(c(1:10 %o% 10 ^ (0:5))),
    labels = c("1", "10", "100", "1,000", "10,000", "100,000"))
ggsave("packages-dist.pdf", width = 8, height = 4)

head(arrange(packages, desc(count)), 50)
subset(arrange(packages, desc(count)), count > 10000)
