#Load R packages

library(tidyverse)
library(anomalize)
library(ggthemes)
library(ggbeeswarm)

#Load ionomics data

ionomics_data <- read_csv('QTL_mapping/docs/PCA/genevaionomics/160822_Data.Chitwood705.csv')
