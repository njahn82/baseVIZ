#aggregates current summary table and saves it for further data manipulation

require(XML)

base.source.df <- function() {
  
  url <- "http://www.base-search.net/about/en/about_sources_date_dn.php?menu=2"
  
  my.data <- as.data.frame(readHTMLTable(url,header=T))[,c(1:4)]
  
  colnames(my.data) <- c("Host","Records","Country","Date")
  
  my.data$Records <- as.numeric(as.character(gsub(",","", 
                                                  as.character(my.data$Records))))
  
  return(my.data)
}