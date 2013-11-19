library(dplyr)
library(ggplot2)
library(lubridate)

logs <- readRDS("logs.rds")

my_packages <- c('ggplot2', 'plyr', 'lubridate', 'devtools', 'testthat', 
  'roxygen2')
hadley <- logs %.% filter(package %in% my_packages)

pkgs <- hadley %.% group_by(package, date)
counts <- summarise(pkgs, n = n())

# Weekly cycle obscures patterns
qplot(date, n, data = counts, geom = "line", colour = package)

# So aggregate by week
counts$week <- floor_date(counts$date, "week")
by_week <- counts %.% group_by(week) %.% summarise(n = sum(n))

qplot(week, n, data = by_week, geom = "line", colour = package)
