#plotting treemap
require(treemap)
require(countrycode)

#read data

my.data <- read.csv("./data/baseData.csv",header=T,sep=",")

co.doc <- aggregate(as.numeric(Dokumente) ~ Land, data=my.data, sum)
co.rep <- as.data.frame(table(unlist(my.data$Land)))

data.tree <- merge(co.doc,co.rep,by.x="Land",by.y="Var1")

#massage
data.tree$Land <- toupper(data.tree$Land)
data.tree$Land[data.tree$Land == "UK"] <- "GB" ##UK to GB

#region/continent
region <- countrycode(data.tree$Land, "iso2c", "region")
continent <- countrycode(data.tree$Land, "iso2c", "continent")

#cbind
data.tree <- cbind(data.tree,region,continent)
colnames(data.tree) <- c("Land","Dokumente","Quelle","Region","Kontinent")

data.tree <- na.omit(data.tree)
write.csv(data.tree, "./data/base_continent_regions.csv")

#plot Region

pdf("./plot/treemapBaseRegion.pdf")
tmPlot(data.tree, index=c("Region"), vSize="Quelle", vColor="Dokumente", type="dens")
dev.off()

#plot Kontinent
pdf("./plot/treemapBaseContinent.pdf")
tmPlot(data.tree, index=c("Kontinent"), vSize="Quelle", vColor="Dokumente", type="dens")
dev.off()

# vsize Dokumente

pdf("./plot/treeMapBaseRegionDocs.pdf")
tmPlot(data.tree, index=c("Region"), vSize="Dokumente", vColor="Quelle", type="dens")
dev.off()

pdf("./plot/treeMapBaseKontinentDocs.pdf")
tmPlot(data.tree, index=c("Kontinent"), vSize="Dokumente", vColor="Quelle", type="dens")
dev.off()
