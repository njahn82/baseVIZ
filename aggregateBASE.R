#aggregates current summary table and saves it for further data manipulation

require(XML)

url <- "http://www.base-search.net/about/de/about_sources_date_dn.php?menu=2"

my.data <- as.data.frame(readHTMLTable(url,header=T))

colnames(my.data) <- c("Host","Dokumente","Land","Date")

write.csv(my.data, file="./data/baseData.csv")
