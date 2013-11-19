# Explore number of downloads per ip.
library(dplyr)
library(ggplot2)

logs <- readRDS("logs.rds")

ip_daily <- group_by(logs, date, ip_id)
pkgs <- ip_daily %.% summarise(n = n()) %.% ungroup() %.% arrange(desc(n)) %.%
  filter(!is.na(ip_id))

qplot(n, data = pkgs %.% filter(n < 100), binwidth = 1)
qplot(n, data = pkgs %.% filter(n >= 100), binwidth = 0.02) + 
  scale_x_log10("Number of downloads",
    breaks = 10 ^ (2:5), minor_breaks = log10(c(1:10 %o% 10 ^ (2:5))),
    labels = c("100", "1,000", "10,000", "100,000")) +
  geom_vline(xintercept = 4800, colour = "red")

# Peak at around the number of packages on CRAN indicating a decent number of
# people (~200) who are downloading all packages.

# Should really weed out all downloads from very high downloaders
# i.e. anything over ~5000 implies multiple downloads of the same 
# package
