# Can we find Charlotte's ST511 students? They downloaded ggplot2, openintro,
# Sleuth2, and knitr.
library(dplyr)
library(ggplot2)

logs <- readRDS("logs.rds")

recent <- filter(logs, date > as.Date("2013-09-25"))
by_person <- group_by(recent, date, ip_id)

# For each person, figure out how many of the matching packages they downloaded
st511 <- c("ggplot2", "openintro", "Sleuth2", "knitr")
matches <- summarise(by_person, match = sum(unique(package) %in% st511))

# Three approaches
# system.time(matches <- summarise(by_person, match = length(intersect(package, st511))))
# system.time(matches <- summarise(by_person, match = length(base::intersect(package, st511))))
# system.time(matches <- summarise(by_person, match = sum(unique(package) %in% st511)))

daily_match <- matches %.% group_by(match) %.% summarise(n = n())

# Downloads with 2+ matches swamped by 0 matches
qplot(date, n, data = daily_match, colour = factor(match), geom = "line")

# So convert to props, and remove 0 and 1 matches
props <- daily_match %.% mutate(prop = n / sum(n)) %.% filter(match > 1, prop < 0.05)
qplot(date, n, data = props, colour = factor(match), geom = "line")
qplot(date, prop, data = props, colour = factor(match), geom = "line")

# Looks like a peak around October 10
