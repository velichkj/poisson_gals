First, we are going to look at some descriptive statistic, such as the min, mean and max values for mercury concentration, weight and length for the two fish species at the three sites. We expect there to be greater mercury in the upstream site and in SMB. Furthermore, we expect SMB to be longer and heavier than YP. 

**BMB**: even checking out descriptive statistics across sites is snooping, in a sense.  Before you do this you should decide what models you actually plan to fit.

Next, we will fit general linear models to mercury. We will look at the diagnostic plots to see if we need to make any transformations. Once we’ve made any necessary transformations are made, and the diagnostic plots look good, we will make summary tables to look at the clarity of weight, length, site, species, and sex on mercury concentration.

**JD:** By "general" do you just mean lm() models? I wonder if there's a better word for that?
**BMB:** (1) "general linear models" is a correct (but sometimes confusing) term, but a lot of people just drop the `lm()`.  (2) Why focus on summary tables that give p-values? Looking at the magnitudes of the parameters, especially appropriately scaled parameters (see Schielzeth 2010 *Methods in Ecology and Evolution*), would be more informative. (Also see `dotwhisker::dwplot(<fitted model>, by_2sd=TRUE)`)

Furthermore, we will be using PCAs to reduce the number of variables and identify the parameters contributing most significantly to variation among mercury. We will be reading more about PCAs and how to code them in R. 

**JD:** PCAs don't do the second thing you said ☺
**BMB:** To clarify, PCAs reduce the number of variables (because you decide based on a scree plot or some other criterion how many you want to keep, *without looking at how much of the response they explain*), but you would then identify how strongly the *principal components* contributed, not the original variables

**March 30th**
Dear Journal, 
First, we went right to the PCA because we didn't want to snoop. We wanted to check whether we could reduce the number of variables which explain fish physical features.
We used total length (mm), fork length (mm), total weight (g), liver weight (g), and gonad weight (g). PC1 explained 93.8% of the variability, and total weight was most important in explaining the variability of the dataset. However, all the variables are positively correlated and had strong influence on the variability as well. 
Here, we're planning to learn how to extract the axes (PC1) from the PCA (we used the *factoextra* package). We want to use this as a variable in our linear models.. we're not sure whether we can use this as a random effect in our linear mixed effects model. 

For our next step, we are thinking of using a linear mixed effects model. 
First, we will look at the diagnostic plots for the linear model with untransformed response variable (THg) to check whether it meets the assumptions. If not, we can try transforming the response variable (THg) using log or polynomial distributions, and check whether the diagnostic plots are improved.

At the end of class, Ben took a look at our PCAs and noticed that the orientation of the ellipses for yellow perch and smallmouth bass were different. He suggested that we take a look at the PCA plots separately for each species. Upon doing this, we noticed a very influential datapoint in the yellow perch data (possibly an outlier in the gonad weight) so Jenni will take a look and we can check if this pattern persists once we get the cleaned data. 

**April 1st**
Dear Journal,
We revisited the PCA data. First, we removed the extreme outlier for yellow perch because it had a very high gonad weight, so we suspect it might be a data entry error. We also checked the 2 points in the SMB biplot which were not in the ellipse, to check whether they seemed reasonable, and they seemed biologically reasonable for their size. 

Looking at the biplot of both species, we noticed that the orientation of the ellipses for YP and SMB are different. Here are the patterns we deduced from the PCA:
With SMB, it seems like the total length, fork length, total weight, and gonad weight are all responding in the same positive direction. 
With YP, gonad weight isnt increasing proportionally with size. 

Next, we did a quick linear model to look at the relationship between fish weight and gonad weight, with comparisons between the 2 sexes and 2 species. 
For SMB, there is a greater increase per unit increase of fish weight in females than males
On the contrary, for YP, there is a greater increase per unit increase of fish weight in males than females. Interesting! 
Next week we will look at how this linear model may explain what we see in the PCA. We'll think about it over easter with some mini eggs as fuel.

**April 6th**
After a discombobulated start, we decided that we need to determine linear/mixed/general model.. 
Response: THg 
Predictor: PC1 (size of fish), sex, species
Start with linear model of THg, compare diagnostics with linear model of log(THg)
Site as both predictor and random effect...(according to JD)
Note - Sex is almost never a random effect, we want it to be fixed effect (because we have only 2 sexes)
Need to decide whether we want to use the variables separately or if we want to use PC1. Note that it might be easier to use PC1 than the variables separately because the variables are so much more correlated

Next, we assessed the diagnostic plots of linear models and compared a linear response variable with a log-transformed response variable. The diagnostic plots for log-transformed response variable looked better, especially for the Normal QQ plot and Scale-Location plot.  

After this, we had an existential crisis about whether we want to evaluate both species together in the model, or complete separate models for each species individually. 
So we decided to look at the diagnostic plots for THg vs PC1 for each of the species separately. 

Advice on using *DHARMa* to plot residuals from Ben:
Plot residuals against different variables to see whether there are particular "corners" of the data that are not being fitted well 
- in a model we are hopping that there are no patterns in the residuals (extract all the info in the data and leave only noise)
- however we cannot do that exactly... 
- patterns in the residuals implies that there are patterns in the data that are not captured in the model, which might mess up the model and might also be interesting (for an example, if it is fitted as linear but the pattern is actually quadratic - this would show up in the diagnostic plot)
- prediction vs residuals is a general way of looking at the values, but doesn't really tell us what the clusters of the points are, or if there are patterns, what are they associating?? plotting residuals helps us track down clusters of points (small fish? large fish?)

It is simpler to compare species separately but then we lose the ability to make cross-species comparisons (we can't compare the response between SMB and YP)

So to end this day, we dropped the fish samples without Hg values to use for our linear mixed-effects models. So we are using:
df_YP_pca2, df_SMB_pca2
We used the DHARMa package to plot residuals from the LMEMs. The diagnostic plots for YP looked good. However, for the diagnostic plot for SMB, there is a problem with the residuals vs predicted. We will revisit this next time. To Be Continued...


#April 8
Consider putting date in as a random effect 
Take site out as a random effect. We only have 3 sites so we want it to be fixed.
We can use predict method to figure out what the large prediction values correspond to. They are large predicted values with low residual values. THat means we're underpredicting for our most extreme values (high biomass an they're higher than the model thinks they are). See if those 4 data points are weird that we haven't incorporated (find out which data points they are - look directly at data or some of the plots we made).

Update: We looked for these fish with the greates Dim.1 and they are infact just really big so that might be driving the underpredicting for the large biomass fish as seen in the DHARMa residual vs predicted plot. 

plot(allEffects(lmem_SMB)) - quick visualization of the model. These are mentioned in linear model lecture. We can also use dotwhisker::dwplot to look at coeeficients. 