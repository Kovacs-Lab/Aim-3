# Summary of Normalized Al 27 Ionomics Analysis
This data is showing the concentration of Al 27, which was then normalized to the Z value and then shifted to be positive as a phenotype. It is then mapped as any other phenotype would be. Female analysis is listed first, then male analysis.

## Female analysis

![Normal Histogram](https://github.com/Kovacs-Lab/Aim-3/blob/master/QTL_mapping/docs/images/NAl27/Female/Normal_Histogram.png "Normal Histogram")
### Normal Histrogram of Al 27 data
The data does appear to follow a bell curve.


![Genetic Position vs LOD](https://github.com/Kovacs-Lab/Aim-3/blob/master/QTL_mapping/docs/images/NAl27/Female/Genetic_Position_vs_LOD_Score.png "Genetic Postion vs LOD")
### Genetic Position vs LOD
The data does show a significant peak on chr 17. The LOD5 value for this data set is and `6.443473` when using raw data. This peak does occur at a generated marker however. 

mkr | chr | pos | lod
--- |--- | --- | ---
1_4279304 | 1 | 21.08 | 1.010
2_5186881 | 2 | 46.03 | 0.503
3_5596857 | 3  | 1.78 | 1.252
4_21405666 | 4 | 62.52 | 2.082
c5.loc8 | 5 | 8.00 | 1.022
6_15528810 | 6 | 45.30 | 1.316
7_22862695 | 7 | 73.20 | 0.623
8_11720093 | 8 | 31.77 | 1.292
9_13407438 | 9 | 50.03 | 1.082
c10.loc40 | 10 | 40.00 | 0.556
c11.loc49 | 11 | 49.00 | 2.139
12_22693791 | 12 | 85.49 | 0.591
c13.loc8 | 13 | 8.00 | 2.537
14_788160 | 14 | 0.00 | 1.004
c15.loc2 | 15 | 2.00 | 2.895
16_1261805 | 16 | 3.02 | 0.540
c17.loc4 | 17  | 4.00 | 6.925
c18.loc64 | 18 | 64.00 | 2.501
19_24491792 | 19 | 60.37 | 0.550

mkr | chr | pos | lod
--- | --- | --- | ---
17_1417093 | 17 | 0.00000 | 0.002572613
c17.loc37 | 17 | 37.00000 | 1.010229910
17_10144636 | 17 | 63.31204 | 0.001883870

mkr | chr | pos | lod
--- | --- | --- | ---
17_1417093 | 17 | 0.00000 | 0.002572613
c17.loc37 | 17 | 37.00000 | 1.010229910
17_10144636 | 17 | 63.31204 | 0.001883870

Chromosomal analysis with `mqmauqment` did not yeild different results, however the peak disappeared when run with `fill.geno`.

`fitqtl summary`

>Method: Haley-Knott regression 
>Model:  normal phenotype
>Number of observations : 167 

Full model result
Model formula: y ~ Q1 

Name | df | SS | MS | LOD | %var | Pvalue(Chi2) | Pvalue(F)
--- | --- | --- | --- | --- | --- | --- | ----
Model | 1 | 30.32324 | 30.3232373 | 7.379301 | 18.41222 | 5.559747e-09 | 7.214544e-09
Error | 165 134.36762 | 0.8143492                  
Total | 166 | 164.69086                             

Estimated effects:

Name | est | SE | t
--- | --- | --- | ---
Intercept | 0.52947 | 0.07002 | 7.562
17@4.0 | -5.98717 | 0.98116 | -6.102

even though the LOD is not much higher than the cutoff, and occurs at a generated marker the statistics look very good. 

## Male Analysis

![Normal Histogram](https://github.com/Kovacs-Lab/Aim-3/blob/master/QTL_mapping/docs/images/NAl27/Male/Normal_Histogram.png "Normal Histogram")
### Normal Histrogram of Al 27 data
The data does appear to follow a bell curve.


![Genetic Position vs LOD](https://github.com/Kovacs-Lab/Aim-3/blob/master/QTL_mapping/docs/images/NAl27/Male/Genetic_Position_vs_LOD_Score.png "Genetic Postion vs LOD")
### Genetic Position vs LOD
The data does not show any significant peaks. The LOD5 value for this data set is `6.118946` when using `fill.geno` and `6.328996` when using raw data. The highest LOD score is 2.8 on chr 8. 
