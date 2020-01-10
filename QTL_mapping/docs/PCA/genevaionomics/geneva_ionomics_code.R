#Load R packages

library(tidyverse)
library(anomalize)
library(ggthemes)
library(ggbeeswarm)

#Load ionomics data

ionomics_data <- read_csv('QTL_mapping/docs/PCA/genevaionomics/160822_Data.Chitwood705.csv')

#North American species to include:
#Vitis_palmata
#Vitis_aestivalis
#Vitis_vulpina
#Vitis_acerifolia
#Vitis_rupestris
#Vitis_cinerea
#Vitis_labrusca
#Vitis_riparia
