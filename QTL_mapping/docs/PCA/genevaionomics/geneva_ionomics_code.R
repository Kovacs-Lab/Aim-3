#Load R packages

library(tidyverse)
library(anomalize)
library(ggthemes)
library(ggbeeswarm)

#Load ionomics data

ionomics_data <- read_csv('QTL_mapping/docs/PCA/genevaionomics/160822_Data.Chitwood705.csv')

#sample keyfile

keyfile <- read_tsv("QTL_mapping/docs/PCA/genevaionomics/Geneva_2016_ionomic_labels.txt")

#Check that all samples are in the keyfile prior to merging
table(ionomics_2016$sample %in% keyfile$row_plant_xyz)

#Keyfile matches up perfectly with labels so I can merge
ionomics_info <- left_join(ionomics_2016, keyfile, by=c("sample"="row_plant_xyz"))

#Reduce down to only leaf Y
ionomics_info <- ionomics_info %>% filter(rep=="Y")

#North American species to include:
#Vitis_palmata
#Vitis_aestivalis
#Vitis_vulpina
#Vitis_acerifolia
#Vitis_rupestris
#Vitis_cinerea
#Vitis_labrusca
#Vitis_riparia

ionomics_info <- ionomics_info %>% filter(genus_species %in% c("Vitis_palmata", "Vitis_aestivalis", "Vitis_vulpina", "Vitis_acerifolia", "Vitis_rupestris", "Vitis_cinerea", "Vitis_labrusca", "Vitis_riparia"))

#Now down to 201 samples 

#Distribution across species
table(ionomics_info$genus_species)

#Vitis_acerifolia Vitis_aestivalis    Vitis_cinerea   Vitis_labrusca    Vitis_palmata    Vitis_riparia  Vitis_rupestris 
#12                6                   29               40                5               71               27 
#Vitis_vulpina 
#11 

#Remove outliers 
#The IQR Method uses an innerquartile range of 25 the median. With the default alpha = 0.05, the limits are established by expanding the 25/75 baseline by an IQR Factor of 3 (3X). The IQR Factor = 0.15 / alpha (hense 3X with alpha = 0.05). To increase the IQR Factor controling the limits, decrease the alpha, which makes it more difficult to be an outlier. Increase alpha to make it easier to be an outlier.

#Originally I ran with alpha=0.05 but that removes two samples only and one of them is one of the parents! If I don't run outlier removal, there's definitely one sample that's got something wrong going on and is very far apart from all the others and has a lot of wonky values (588395). So I've tried it here with alpha=0.02 which pretty leninent and only removes one sample. I think either option is okay as long as we report what we have done. However, feel free to alter what I've done here. 

# Create a variable/vector/collection of the column names you want to remove outliers on.
vars <- c("B11" , "Na23" ,  "Mg26",  "Al27" ,  "P31", "S34", "K39" ,"Ca44",  "Fe54" , "Mn55" ,"Co59", "Ni60" , "Cu63",      "Zn66" , "As75" , "Rb85",  "Sr88","Mo98","Cd111" )


pdf('QTL_mapping/docs/PCA/genevaionomics/element_distributions.pdf', onefile=TRUE)

for (i in 1:length(vars)){
  # get element name at index
  element <- vars[i]
  
  # remove outliers and plot clean data
  d <- anomalize(as_tibble(ionomics_info), target=element, method='iqr', alpha=0.02)
  d <- d[d$anomaly != 'Yes',]
  p <- ggplot(d, aes_string(element)) + geom_density() + geom_rug() + ggtitle(paste(element, 'clean', sep='_')) + theme_bw()
  print(p)
  
}
dev.off()

#How many outliers were removed?
nrow(ionomics_info)-nrow(d)
#1 only 

#Clean up dataset so it only has info we actually need
ionomics_info_clean <- d

ionomics_info_clean <- ionomics_info_clean %>% select(genus_species, IVNO, B11:Cd111)

#Run PCA 

ionomics_pca <- prcomp(ionomics_info_clean[,3:ncol(ionomics_info_clean)], scale=T, center = T)
ionomics_pc_values <- as.data.frame(ionomics_pca$x)
ionomics_pc_values$sample <- ionomics_info_clean$IVNO
ionomics_pc_values$species <- ionomics_info_clean$genus_species
#parents are 588160 (mom) and 588271 (dad)

pdf("QTL_mapping/docs/PCA/genevaionomics/geneva_ionomics_species_pc1_pc2.pdf", width = 8.5, height = 5.5)
ionomics_pc_values %>% ggplot(aes(x=PC1, y=PC2, colour=species))+
  geom_point(size=3.5, stroke=0, alpha=0.6)+
  theme_few()+
  coord_fixed()+
  theme(axis.text = element_text(size = 14, colour = "black", face = "plain"), text = element_text(size = 16, face = "bold"),legend.position = "right", panel.grid.major = element_blank(), panel.grid.minor = element_blank())
dev.off()

pdf("QTL_mapping/docs/PCA/genevaionomics/geneva_ionomics_species_pc1_pc3.pdf", width = 8.5, height = 5.5)
ionomics_pc_values %>% ggplot(aes(x=PC1, y=PC3, colour=species))+
  geom_point(size=3.5, stroke=0, alpha=0.6)+
  theme_few()+
  coord_fixed()+
  theme(axis.text = element_text(size = 14, colour = "black", face = "plain"), text = element_text(size = 16, face = "bold"),legend.position = "right", panel.grid.major = element_blank(), panel.grid.minor = element_blank())
dev.off()

#Looks like there's one rupestris sample that's quite different from everything else (588147) along PC3
