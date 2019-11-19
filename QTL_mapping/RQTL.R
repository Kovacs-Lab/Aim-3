install.packages('qtl') #Main package, for analysis
install.packages('qtlcharts') #accessory, for displaying graphs
install.packages('LinkageMapView') #accessory, for displaying linkage maps
install.packages('rcompanion')# for plotNormalHistogram
library(qtl) #load packages
library(qtlcharts)
library(LinkageMapView)
library(rcompanion)

colNum <- readline("Column Number: ") #Column for pheno of interest
colNum <- as.numeric(colNum) #convert to number
colNam <- readline("Column Name: ") #name of pheno of interest
getwd()
setwd("C:/Users/Courtney/Desktop/GitHub/Aim-3/QTL_mapping")
runs <- 0
for(x in 1:2){
  naNames <- c("NA","--")
  if(runs == 0){
    fileName <- "FemaleMap.csv" #Mapping table file
    genotypeName <- c("ll","lm")
    alleleName <- c("l","m")
    sex <- "Female"
  }
  if(runs == 1){
    fileName <- 'MaleMap.csv' #Mapping table file
    genotypeName <- c("nn","np")
    alleleName <- c("n","p")
    sex <- "Male"
  }
  
  #Map generation
  Map <- read.cross(format = 'csv',file = fileName ,genotypes = genotypeName,alleles = alleleName,na.strings = naNames) #generate linkage map
  Map <- jittermap(Map) #make sure no markers are in the same location
  Map <- calc.genoprob(Map,step = 1,map.function = "kosambi") #associate markers with full genotypes
  setwd("docs/images/")
  dir.create(paste(colNam,"/",sex,sep = ""),recursive = TRUE)
  setwd(paste(colNam,"/",sex,sep =""))
  getwd()
  png(filename ="Linkage_Map.png")
  plot.map(Map) #draw linkage map
  dev.off()
  png(filename = "Normal_Histogram.png")
  plotNormalHistogram(Map$pheno[,colNam]) #normal histogram of pheno of interest
  dev.off()

  #Compute statistically significant values
  #TraitCIM1000 <- cim(Map,pheno.col = colNum,method = "hk",map.function = "kosambi",n.perm = 1000) # Function will take a moment to run, determines LOD value
  #png(filename = "LOD_Frequency.png")
  #plot(TraitCIM1000,col = 'green') #show distribution of lod scores
  #dev.off()
  #LOD5 <- summary(TraitCIM1000)[1]
  #capture.output(LOD5,file="lod_cutoff.txt")
  #write.csv(TraitCIM1000,file = "TraitCIM1000.csv")

  #Deterime LOD Values

  TraitCIM<-cim(Map,pheno.col = colNum,method = "hk",map.function = "kosambi") #Generate LOD Values
  png(filename = "LOD_vs_Genetic_Position.png")
  plot(TraitCIM) #show LOD graph
  #abline(h = LOD5,col = "blue") #overlay statistically significant line
  dev.off()
  print("If nothing shows up, the values are below the LOD5 score") #warning for no peaks
  write.csv(TraitCIM,file = "TraitCIM.csv")
  capture.output(summary(TraitCIM),file = "TraitCIM_Summary.txt")

  #Chromosomal Analysis
  cont = 'y' #Run loop on first run through
  while(cont == 'y'){
    chr <- as.numeric(readline("Chromosome? ")) #collect chromosome to look at
    png(filename = "LOD_vs_Genetic_Position_Chr_of_interest.png")
    plot(TraitCIM, chr = chr, main=paste("chr",chr)) #Plot chr LOD scores
    #abline(h = LOD5, col = "blue") #Statistically Significant
    dev.off()
    bay <- scanone(Map, method = 'hk') #scan genome with sQTL model
    capture.output(bayesint(bay, chr = chr, prob=0.95, expandtomarkers=TRUE),file = paste("bayesin_",chr,".txt", sep = "")) #calculate bayesian interval
    capture.output(lodint(bay, chr = chr,expandtomarkers = TRUE ),file = paste("lodint_",chr,".txt", sep = "")) #calculate LOD Support interva
    #TODO, automate pos value
    #fitqtl analysis
    pos <- readline("Position? ")
    pos <- as.numeric(pos)
    qtl <- makeqtl(Map, chr = chr, pos = pos, what="prob") #pulls genotype probabilities
    fitqtl <- fitqtl(Map, pheno.col=colNum, qtl = qtl, covar=NULL,method= "hk",model="normal",dropone=TRUE, get.ests=TRUE,run.checks=TRUE,tol=1e-4, maxit=1000, forceXcovar=FALSE) #sees how well our data fits a given formula If you see "error: object of type 'closure' is not subsettable", remove "formula," from the fitqtl argument list.
    capture.output(summary(fitqtl),file = paste("fitqtl_",chr,".txt", sep = "")) #Print results of the analysis
    cont = readline("Would you like to investigate another chromosome? (Y/N): ") #Y if multiple chromosomes are to be investigated, saves last chromosome investigated  
    }
  setwd("C:/Users/Courtney/Desktop/GitHub/Aim-3/QTL_mapping")
  runs <- runs + 1
}
