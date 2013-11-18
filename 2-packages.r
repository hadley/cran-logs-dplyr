library(plyr)
library(ggplot2)
library(lubridate)
source("db.r")

load_all("~/documents/plyr/dplyr")

src <- sqlite_source("cran-logs.sqlite3", "logs")
head(src)

counts <- exec_sql("
  SELECT package, date, count(*) as count
  FROM logs
  WHERE package in ('ggplot2', 'lubridate', 'devtools', 'testthat', 'roxygen2')
  GROUP BY package, date;")

count(counts, "package", "count")

qplot(date, count, data = counts, geom = "line", colour = package)

# Aggregate by week
counts$week <- floor_date(counts$date, "week")
by_week <- count(counts, c("package", "week"), "count")

qplot(week, freq, data = by_week, geom = "line", colour = package)

# Explore operating systems ---------------------------

os <- exec_sql("
  SELECT r_os, count(*) as count
  FROM logs
  GROUP BY r_os;")
os$prop <- os$count / sum(os$count)

os <- subset(os, prop > 0.01)
sum(os$prop)

os_date <- exec_sql("
  SELECT r_os, date, count(*) as count
  FROM logs
  GROUP BY r_os, date;")

oses <- count(os, "r_os", "count")
common_os <- subset(oses, prop > 0.01)
os <- match_df(os, common_os)

qplot(date, count, data = os, geom = "line", colour = r_os)
