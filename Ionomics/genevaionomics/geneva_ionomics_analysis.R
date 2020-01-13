#Load R packages

library(tidyverse)
library(anomalize)
library(ggthemes)
library(ggbeeswarm)
library(reshape)

#Load ionomics data

ionomics_2016 <- read_csv('Ionomics/genevaionomics/160822_Data.Chitwood705.csv')

#sample keyfile

keyfile <- read_tsv("Ionomics/genevaionomics/Geneva_2016_ionomic_labels.txt")

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


pdf('Ionomics/genevaionomics/element_distributions.pdf', onefile=TRUE)

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

#Look at distribution of all species across all elements 

#Convert table so that there's a column for the elements
ionomics_info_plot <- as.data.frame(ionomics_info_clean)
ionomics_info_plot <- melt(ionomics_info_plot,id = c('genus_species', 'IVNO'))

pdf("Ionomics/genevaionomics/geneva_ionomics_species_distribution.pdf", width = 8.5, height = 15.5)
ggplot(ionomics_info_plot,aes(x=genus_species, y=value, fill=genus_species))+
  geom_quasirandom(alpha = 0.7,size = 1,stroke=0)+
  geom_boxplot(alpha=0.5, outlier.colour = NA)+
  facet_wrap(~variable, scales = "free_y",ncol = 3)+
  theme_few()+
  theme(axis.text.x = element_text(size = 10, colour = "black", face = "plain", angle = 60,hjust=1), text = element_text(size = 16, face = "bold"),legend.position = "right", panel.grid.major = element_blank(), panel.grid.minor = element_blank(),axis.text.y = element_text(size = 10, colour = "black", face = "plain"))+
  labs(x ="Species", y="Ion Concentration (ppm)")+
  theme(legend.position = "none")
dev.off()  

#Reduce down to just riparia and rupestris, then plot labels for parents 

ionomics_info_parents <- ionomics_info_plot %>% filter(genus_species %in% c("Vitis_rupestris", "Vitis_riparia"))

#I'll label parents with a vertical line across the distributions

rip_rup_palette <- c(  "#d95f0e","#1E88E5")

pdf("Ionomics/genevaionomics/geneva_ionomics_species_distribution_rip_rup.pdf", width = 10, height = 15.5)
ggplot(ionomics_info_parents,aes(x=value, fill=genus_species))+
  geom_area(data=ionomics_info_parents, alpha=0.4, stat="bin")+
  geom_vline(data = subset(ionomics_info_parents,IVNO=="588160"), mapping=aes(xintercept=value), color="#1E88E5", size=1.2, alpha=0.8) +
  geom_vline(data = subset(ionomics_info_parents,IVNO=="588271"), mapping=aes(xintercept=value), color="#d95f0e", size=1.2, alpha=0.8) +
  facet_wrap(~variable, scales = "free",ncol = 4)+
  scale_fill_manual(values=rip_rup_palette)+
  theme_few()+
  theme(axis.text.x = element_text(size = 10, colour = "black", face = "plain", angle = 60,hjust=1), text = element_text(size = 16, face = "bold"),legend.position = "right", panel.grid.major = element_blank(), panel.grid.minor = element_blank(),axis.text.y = element_text(size = 10, colour = "black", face = "plain"))+
  theme(legend.position = "bottom")
dev.off()  

#Run PCA 

ionomics_pca <- prcomp(ionomics_info_clean[,3:ncol(ionomics_info_clean)], scale=T, center = T)
ionomics_pc_values <- as.data.frame(ionomics_pca$x)
ionomics_pc_values$sample <- ionomics_info_clean$IVNO
ionomics_pc_values$species <- ionomics_info_clean$genus_species
#parents are 588160 (mom) and 588271 (dad)

pdf("Ionomics/genevaionomics/geneva_ionomics_species_pc1_pc2.pdf", width = 8.5, height = 5.5)
ionomics_pc_values %>% ggplot(aes(x=PC1, y=PC2, colour=species))+
  geom_point(size=3.5, stroke=0, alpha=0.6)+
  theme_few()+
  coord_fixed()+
  theme(axis.text = element_text(size = 14, colour = "black", face = "plain"), text = element_text(size = 16, face = "bold"),legend.position = "right", panel.grid.major = element_blank(), panel.grid.minor = element_blank())
dev.off()

pdf("Ionomics/genevaionomics/geneva_ionomics_species_pc1_pc3.pdf", width = 8.5, height = 5.5)
ionomics_pc_values %>% ggplot(aes(x=PC1, y=PC3, colour=species))+
  geom_point(size=3.5, stroke=0, alpha=0.6)+
  theme_few()+
  coord_fixed()+
  theme(axis.text = element_text(size = 14, colour = "black", face = "plain"), text = element_text(size = 16, face = "bold"),legend.position = "right", panel.grid.major = element_blank(), panel.grid.minor = element_blank())
dev.off()

#Looks like there's one rupestris sample that's quite different from everything else (588147) along PC3

#colouring the parents black, can alter this to distinguish them differently, just want to see where they fall in the distribution
pdf("Ionomics/genevaionomics/geneva_ionomics_species_pc1_pc2_parents.pdf", width = 8.5, height = 5.5)
p <- ggplot(ionomics_pc_values, aes(x=PC1, y=PC2,colour=species))
p + 
  geom_point(data=ionomics_pc_values,  size=3.5, stroke=0, alpha=0.6)+
  geom_point(data=subset(ionomics_pc_values,sample=="588160"), color="black",  size=3.5, stroke=0, alpha=0.6)+
  geom_point(data=subset(ionomics_pc_values,sample=="588271"), color="black",  size=3.5, stroke=0, alpha=0.6)+
  theme_few()+
  coord_fixed()
dev.off()

