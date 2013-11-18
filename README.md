# Explore Rstudio CRAN downloads with dplyr

This repo is a case study for using dplyr with a large in memory dataset: all package downloads from the [Rstudio CRAN mirror](http://cran-logs.rstudio.com/) since 1 Jan 2013. You'll need a decent amount of free disk space (~500 meg), and at least 8 gig of ram. As of 18 Nov 2013, there are about 20 million rows and 10 variables.

To get started, run `1-download.r` to download all CRAN logs (as csv), and combine them into a single dataframe which is stored as `logs.rds`. You can run this function as often as you like and it will only download new logs. Currently, it takes about 15 minutes to read all the files and combine into a single data frame, but that will get faster as we attack different bottlenecks.