# Download Fortune Global 500 file
library(RCurl)
url <- "https://raw.githubusercontent.com/ilyavorobiev/fortune-grabber/master/output/fortune1000.csv"
companies <- read.csv(textConnection(getURL(url)), header = TRUE)
companies <- companies[0:500,]

# Set datatypes
companies$Years.on.list <- as.numeric(as.character(companies$Years.on.list))
companies$Employees <- as.numeric(as.character(companies$Employees))
companies$Revenues <- as.numeric(as.character(companies$Revenues))
companies$Profits <- as.numeric(as.character(companies$Profits))
companies$EPS <- as.numeric(as.character(companies$EPS))

# Set NA to 0
companies[is.na(companies)] <- 0

# Sectors
sectors <- c()
i <- 1

for (sector in unique(companies$Sector)) {
  sectors[i] <- sector
  i = i + 1
}

sectors[i] <- "All"
  