install.packages('qtl') #Main package, for analysis
install.packages('qtlcharts') #accessory, for displaying graphs
install.packages('LinkageMapView') #accessory, for displaying linkage maps
install.packages('rcompanion')# for plotNormalHistogram
library(qtl) #load packages
library(qtlcharts)
library(LinkageMapView)
library(rcompanion)

#Collecting enviroment variables
print("Make sure to input names 
      AS THEY APPEAR on the csv!!") #Just a user warning
fileName <- readline("Enter file name: ") #Mapping table file
genotypeName <- c(readline("First Genotype: "),
                  readline("Second Genotype: ")) #For example "nn", "np"
alleleName <- c(readline("First Allele: "),
                readline("Second Allele: ")) #For example "n","p" TODO, Autopull from genotype
naNames <- c(readline("First NA String: "),
             readline("Second NA String: ")) #For example "NA", "--"
colNum <- readline("Column Number: ") #Column for pheno of interest
colNum <- as.numeric(colNum) #convert to number
colNam <- readline("Column Name: ") #name of pheno of interest

#Map generation
Map <- read.cross(format = 'csv',file = fileName 
                  ,genotypes = genotypeName,
                  alleles = alleleName,na.strings = naNames) #generate linkage map
Map <- jittermap(Map) #make sure no markers are in the same location
Map <- calc.genoprob(Map,step = 1,map.function = "kosambi") #associate markers with full genotypes
plot.map(Map) #draw linkage map
plotNormalHistogram(Map$pheno[,colNam]) #normal histogram of pheno of interest

#Compute statistically significant values
TraitCIM1000 <- cim(Map,pheno.col = colNum,method = "hk",
                    map.function = "kosambi",n.perm = 1000) # Function will take a moment to run, determines LOD value
plot(TraitCIM1000,col = 'green') #show distribution of lod scores
LOD5 <- summary(TraitCIM1000)[1]

#Deterime LOD Values
TraitCIM<-cim(Map,pheno.col = colNum,method = "hk",
              map.function = "kosambi") #Generate LOD Values
plot(TraitCIM) #show LOD graph
abline(h = LOD5,col = "blue") #overlay statistically significant line
print("If nothing shows up, the values 
      are below the LOD5 score") #warning for no peaks
summary(TraitCIM)

#Chromosomal Analysis
cont = 'Y' #Run loop on first run through
while(cont == 'Y'){
  chr <- as.numeric(readline("Chromosome? ")) #collect chromosome to look at
  plot(TraitCIM, chr = chr) #Plot chr LOD scores
  abline(h = LOD5, col = "blue") #Statistically Significant
  cont = readline("Would you like to investigate 
                  another chromosome? (Y/N): ") #Y if multiple
                  #chromosomes are to be investigated
}

bay <- scanone(Map, method = 'hk') #scan genome with sQTL model
bayesint(bay, chr = chr, prob=0.95, 
         expandtomarkers=TRUE) #calculate bayesian interval
lodint(bay, chr = chr,expandtomarkers = TRUE ) #calculate LOD Support interval

#TODO, automate pos value
#fitqtl analysis
qtl <- makeqtl(Map, chr = chr, pos = 20.05, what="prob") #pulls genotype probabilities
fitqtl <- fitqtl(Map,formula, pheno.col=colNum, qtl = qtl, covar=NULL,
       method= "hk",model="normal",
       dropone=TRUE, get.ests=TRUE,run.checks=TRUE,
       tol=1e-4, maxit=1000, forceXcovar=FALSE) #sees how well 
          #our data fits a given formula 
          #If you see "error: object of type 'closure' is not subsettable", 
          # remove "formula," from the fitqtl argument list.
summary(fitqtl) #Print results of the analysis
