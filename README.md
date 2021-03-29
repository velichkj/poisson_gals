# poisson_gals
We are using Jenni's data from her Master's thesis on fish from the Saint John River. The data file is called New_Brunswick_Fall_2020_fish_data.csv and attached to this repo. For this study, two fish species (Smallmouth Bass and Yellow Perch) were caught at each of three location relative to the Mactaquac Dam: one upstream (REF) and two downstream (NF, FF). Fish were sexed, weighed and measured and their muscle tissue was collected for future analysis. Once in the lab, the fish were analyzed for mercury concentration. 

For this project, Sally and Jenni plan to use statistics to explore any patterns of mercury concentration based on different variables including species, sex, length, weight and site. From here, we have the following questions:

1. Does mercury concentration increase with fish length?
2. Is mercury concentration higher in fish upstream from the dam than downstream, since mercury methylation increases in flooded soils?
3. Is mercury concentration higher in Smallmouth Bass than Yellow Perch, since Smallmouth Bass are positioned higher on the food web?
4. Which parameter explains the most variation in merucry concentration?

## Next steps and questions
From here, we will look at the descriptive statistic for the parameters listed above. Since the response variable (mercury concentration) is a positive continuous variable, we will be using general linear models. Therefore, we can look at the diagnostic plots and see whether any transformations need to be made. 

Jonathan mentioned using principal component analysis for looking at the different parameters correlated with mercury. We will look into what a PCA is. 
 
Also, we are planning on adding another hypothesis regarding the effect of mercury on fish health. We are going to use the fish condition index, which is a ratio of the length to weight, and see whether it decreases with increasing mercury concentration. 
