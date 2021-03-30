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
