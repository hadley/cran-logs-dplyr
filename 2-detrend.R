# Explore basic detrending of daily download numbers
library(dplyr)
library(ggplot2)
library(lubridate)

logs <- readRDS("logs.rds")

by_day <- group_by(logs, date)
out <- summarise(by_day, n = n())
out$wday <- wday(out$date, label = TRUE)

mod <- lm(log10(n) ~ wday, data = out)
out$n2 <- 10 ^ (resid(mod) + mean(log10(out$n)))

qplot(date, n2 / 1e3, data = out, geom = "line") + 
  geom_smooth(se = F, size = 1) +
  ylab("Downloads (000s)")
ggsave("images/daily-detrend.pdf", width = 8, height = 6)

