# Summary of Sex Locus Trait Analysis
This should serve as an example of what documentation is needed for QTL Analyses. The location of the sex locus is already known. 

![Genetic Map](https://github.com/Kovacs-Lab/Aim-3/blob/master/QTL_mapping/docs/images/Sex_Locus/Genetic_Map.png "Genetic Map")
### Genetic Map
The genetic map serves two functions; to verify input (both user input and the mapping files), and to visualize the marker density of any given region.


![Genotype Completeness](https://github.com/Kovacs-Lab/Aim-3/blob/master/QTL_mapping/docs/images/Sex_Locus/Genotype_completeness.png "Genotype Compleness")
### Genotype completeness
This image is a good way to visualize the genotypic data for our population. Red represents one genotype, blue represents the other, and white represents missing data. A few good trends can be obseved in this data. +100 plants have a higher genetic completeness, and there seems to be a higher incidence of missing genotypic data aronnd individual 160. 


![Genotype Completeness After Fill](https://github.com/Kovacs-Lab/Aim-3/blob/master/QTL_mapping/docs/images/Sex_Locus/Genotype_completeness_after_fill.geno.png "Genotype Completeness After Fill")
### Genotype completeness after fill
description of file 


![Normal Histogram of Trait](https://github.com/Kovacs-Lab/Aim-3/blob/master/QTL_mapping/docs/images/Sex_Locus/Normal_Histogram_of_Trait.png "Normal Histogram of Trait")
### Normal histogram of trait
description of file 


![Frequency of LOD Scores 1000 Permutations](https://github.com/Kovacs-Lab/Aim-3/blob/master/QTL_mapping/docs/images/Sex_Locus/Frequency_of_LOD_Scores_1000_Permutations.png "Frequency of LOD Scores 1000 Permutations")
### Frequency of LOD scores 1000 permutations
description of file 

![Genetic Position vs LOD Score (QTL Peaks)](https://github.com/Kovacs-Lab/Aim-3/blob/master/QTL_mapping/docs/images/Sex_Locus/Genetic_Position_vs_LOD_Score_(QTL_Peaks).png "Genetic Position vs LOD Score (QTL Peaks)")
### Genetic Position vs LOD Score (QTL Peaks)


`summary(TraitCIM)`

mkr |chr | pos | lod
--- | --- |--- |---
1_4021184 | 1 | 17.999 | 0.867
2_4272907 | 2 | 20.323 | 46.831
16_9895496 | 3 | 70.697 | 0.196
4_20708423 | 4 | 70.015 | 0.761
5_22057342 | 5 | 70.468 | 0.688
6_16115245 | 6 | 58.679 | 1.192
7_12552225 | 7 | 53.543 | 0.614
8_10222817 | 8 | 30.628 | 0.480
9_5640646 | 9 | 24.768 | 0.840
10_3959571 | 10 | 20.132 | 0.975
11_3968001 | 11 | 15.048 | 0.800
12_769723 | 12 | 0.109 | 1.128
13_22230221 | 13 | 74.436 | 0.381
14_27233180 | 14 | 81.057 | 0.738
15_19559986 | 15 | 94.290 | 1.444
16_20280959 | 16 | 75.099 | 1.077
17_679913 | 17 | 2.954 | 1.195
18_14787621 | 18 | 67.438 | 0.469
19_3090390 | 19 | 12.459 | 0.832


![Genetic Map of chromosome of interest](https://github.com/Kovacs-Lab/Aim-3/blob/master/QTL_mapping/docs/images/Sex_Locus/Genetic_Map_of_chromosome_of_interest.png "Genetic Map of chromosome of interest")
### Genetic Map of chromosome of interest
description of file 


![Genotype completeness of chromosome of interest](https://github.com/Kovacs-Lab/Aim-3/blob/master/QTL_mapping/docs/images/Sex_Locus/Genotype_completeness_of_chromosome_of_interest.png "Genotype completeness of chromosome of interest")
### Genotype completeness of chromosome of interest
description of file 



![Genotype completeness of chromosome of interest after mqmaugment](https://github.com/Kovacs-Lab/Aim-3/blob/master/QTL_mapping/docs/images/Sex_Locus/Genotype_completeness_of_chromosome_of_interest_after_mqmaugment.png "Genotype completeness of chromosome of interest after mqmaugment")
### Genotype completeness of chromosome of interest after mqmaugment
description of file 


`bayesint(bay, chr = chr, prob=0.95, expandtomarkers=TRUE) #calculate bayesian interval`

mkr | chr | pos | lod
--- | --- | --- | ---
2_681715 | 2 | 0.00000 | 0.7217240916
2_4599939 | 2 | 22.23201 | 1.7599686189
2_17017117 | 2 | 67.24903 | 0.0008649556

`lodint(bay, chr = chr,expandtomarkers = TRUE ) #calculate LOD Support interval`

mkr | chr | pos | lod
--- | --- | --- | ---
2_681715 | 2 | 0.00000 | 0.7217241
2_4599939 | 2 | 22.23201 | 1.7599686
2_15380310 | 2 | 61.42303 | 0.1305442

`fitqtl summary()`

>Method: Haley-Knott regression 

>Model:  normal phenotype

>Number of observations : 294 

### Full model result
#### Model formula: y ~ Q1 

df | SS | MS | LOD | %var | Pvalue(Chi2) | Pvalue(F)
--- | --- | --- | --- | --- | --- | ---
Model 1 | 24276.49 | 24276.49 | 0.295589 | 0.4619358 | 0.2433231 | 0.2453366
Error | 292 | 5231105.00 | 17914.74                   
Total | 293 | 5255381.49                            

