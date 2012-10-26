library(maps)
library(rgdal)
library(gpclib)
library(ggplot2)
require(maptools)

#loading BASE summary stat
my.data <- base.source.df()

#loading shape file from thematicmapping.org 

world <- readOGR(dsn="./data",
                 layer="TM_WORLD_BORDERS-0.3") 

world2 <- fortify(world, region = "ISO2")
gpclibPermit()
world2 <- fortify(world, region = "ISO2")

#prepare merge with fortified shape

co.doc <- aggregate(as.numeric(Records) ~ Country, data=my.data, sum)
co.rep <- as.data.frame(table(unlist(my.data$Country)))

data.tree <- merge(co.doc,co.rep,by.x="Country",by.y="Var1",all=T)
colnames(data.tree) <- c("Country","Records", "Sources")
#massage
data.tree$Country <- toupper(data.tree$Country)
data.tree$Country[data.tree$Country == "UK"] <- "GB" ##UK to GB

#merge shapefile and BASE data

mergedata<-merge(world2,data.tree,by.x="id",by.y="Country", all=T)
mergedata <- mergedata[order(mergedata$order),]

#plot
#theme
theme_set(theme_set(theme_bw()))
my.ocean<- theme_update(panel.background = element_rect(fill = "#A6BDDB"))

#theme_set(my.ocean)

#sources
ggplot(mergedata) + 
  aes(long,lat,group=group,fill=Sources) + 
  geom_polygon() +
  geom_path(color="#556670", size= 0.05) +
  coord_map(ylim=c(75,-65)) +
  scale_fill_gradient(na.value = "white", low="#B6C5CC", high="#771C19", "BASE\nOAI-PMH\nSources")
ggsave("./plot/worldBASE.png")

#records

ggplot(mergedata) + 
  aes(long,lat,group=group,fill=Records) + 
  geom_polygon() +
  geom_path(color="#556670", size= 0.05) +
  coord_map(ylim=c(75,-65)) +
  scale_fill_gradient(na.value = "white", low="#B6C5CC", high="#771C19", "BASE\nOAI-PMH\nRecords")
ggsave("./plot/worldBASErecords.png")