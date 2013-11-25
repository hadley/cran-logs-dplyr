library(plyr)

# Make sure we have all the logs -----------------------------------------------

start <- as.Date('2013-01-01')
yesterday <- Sys.Date() - 1
days <- seq(start, yesterday, by = 'day')

years <- as.POSIXlt(days)$year + 1900
urls  <- paste0('http://cran-logs.rstudio.com/', years, '/', days, '.csv.gz')
paths <- paste0("logs/", days, ".csv.gz")

if(!file.exists("logs")) dir.create("logs")
missing <- !(paths %in% dir("logs", full.name = TRUE))
ok <- Map(download.file, urls[missing], paths[missing])

# Read all csv files and merge -------------------------------------------------

logs <- dir("logs", full.name = TRUE)
all_pkgs <- lapply(logs, read.csv, stringsAsFactors = FALSE)

all <- rbind.fill(all_pkgs)
all$date <- as.Date(all$date)
class(all) <- c("tbl_cpp", "tbl", class(all))

saveRDS(all, file = "logs.rds")
