library(plyr)

# Make sure we have all the logs -----------------------------------------------
message("Downloading logs")

start <- as.Date('2013-01-01')
yesterday <- Sys.Date() - 1
days <- seq(start, yesterday, by = 'day')

years <- as.POSIXlt(days)$year + 1900
urls  <- paste0('http://cran-logs.rstudio.com/', years, '/', days, '.csv.gz')
paths <- paste0("logs/", days, ".csv.gz")

if (!file.exists("logs")) dir.create("logs")
missing <- !(paths %in% dir("logs", full.name = TRUE))
ok <- Map(download.file, urls[missing], paths[missing])

# Read all csv files and merge -------------------------------------------------

message("Parsing logs")
logs <- dir("logs", full.name = TRUE)
all_pkgs <- llply(logs, function(file){
  data <- read.csv(file, stringsAsFactors = FALSE)
  data$r_version <- as.character(data$r_version)
  data$r_arch    <- as.character(data$r_arch)
  data$r_os      <- as.character(data$r_os)
  data$date      <- as.Date(data$date)
  data
}, .progress = "text")

all <- dplyr::rbind_all(all_pkgs)
class(all) <- c("tbl_cpp", "tbl", class(all))

saveRDS(all, file = "logs.rds")
