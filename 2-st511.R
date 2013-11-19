# Can we find Charlotte's ST511 students? They downloaded ggplot2, openintro,
# Sleuth2, evaluate and knitr: http://stat511.cwick.co.nz/labs/lab-2.html.
library(dplyr)
library(ggplot2)

logs <- readRDS("logs.rds")

recent <- filter(logs, date > as.Date("2013-09-25"))
by_person <- group_by(recent, date, ip_id)

# For each person, figure out how many of the matching packages they downloaded
st511 <- c("Sleuth3", "openintro", "evaluate", "ggplot2", "knitr")
matches <- summarise(by_person, match = sum(unique(package) %in% st511))

# Three approaches
# system.time(matches <- summarise(by_person, match = length(intersect(package, st511))))
# system.time(matches <- summarise(by_person, match = length(base::intersect(package, st511))))
# system.time(matches <- summarise(by_person, match = sum(unique(package) %in% st511)))

daily_match <- matches %.% group_by(match) %.% summarise(n = n())

# Downloads with 2+ matches swamped by 0 matches, and also strong weekly pattern
qplot(date, n, data = daily_match, colour = factor(match), geom = "line")

# So convert to props, and look at at least 3 matches
props <- daily_match %.% mutate(prop = n / sum(n)) %.% filter(match > 2, prop < 0.1)
qplot(date, n, data = props, colour = factor(match), geom = "line")
qplot(date, prop, data = props, colour = factor(match), geom = "line")

# Looks like a peak around October 10
