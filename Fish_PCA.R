# Final project - PCA of Fish physical attributes #
library(FactoMineR)
library(factoextra)
library(tidyverse)
library(car)
library(effects)
library(emmeans)
theme_set(theme_bw())
#install.packages(c("tidyr","readr","factoextra", "tidyverse"), type="binary")


df<-read.csv("./New_Brunswick_Fall_2020_fish_data.csv") # choose clean data
View(df)

badfish <- c("REF-SMB-A-12","REF-YP-A-38","NF-SMB-A-15", "FF-SMB-A-2") # possible outliers from gonad/liver


AllFish <- df %>% # Extract rows with complete data
 select(-c(SubgonadWeight_g)) %>%       
 drop_na(LiverWeight_g, GonadWeight_g) %>% # need to have data for liver, gonad weights       
 filter(!Fish %in% badfish) 

df_SMB <- filter(AllFish, Species == "Smallmouth Bass")

df_YP <- filter(AllFish, Species == "Yellow Perch")

fish.pca <- PCA(AllFish[,c(9:13)], graph = FALSE)
# PCA using total weight, total length, fork length, gonad weight, liver weight #

fviz_pca_ind(fish.pca,
             geom.ind = c("point","text"),
             col.ind = AllFish$Species, 
             palette = c("#00AFBB", "#E7B800"),
             addEllipses = TRUE, 
             legend.title = "Species", 
             label="var")

fviz_pca_biplot(fish.pca, label ="var", # plot with Add arrows 
                geom.ind = c("point","text"),
                col.ind = AllFish$Species, 
                legend.title = "Species", 
                palette = c("#00AFBB", "#E7B800"),
                addEllipses = TRUE, 
                col.var = "black") 

outliers.id <- fviz_pca_ind(fish.pca) #get sample id of outliers

allfish.contributions <- fviz_cos2(fish.pca, choice = "var", axes = 1)# contribution of each variable to Dim1

ind.allfish <- get_pca_ind(fish.pca) # Coordinates of individuals

scores <- as.data.frame(ind.allfish$coord) # These are principal components 1-5
AllFish_pca <- data.frame(AllFish,scores[,1:2]) #Complete fish dataframe with PCA values

fish.pca$var$contrib # percentages - Dim 1 has almost positive equal contributions
fish.pca$var$coord # "not sure what the hell units they're in" - BB
# we care moreso about the sign of these values
# dim 1 is positive contributions, almost equal from all of the variables
# dim 2 has negative contributions from length and positive from liver and gonad weight
# meaning of Dim2: individuals with a higher DIM2 score have relatively higher liver and gonad for their size (pointing up) and a relatively smaller length for their size (pointing down)

# Ben finds it odd that there are 2 different relationships between the different species
# (the ellipses are not oriented the same way.. but is this an issue?)
# pca is trying to find the direction with the greatest variability 
# if relationships between the variables are different within each species... this might be confusing

# Check the species separately #

SMB.pca <- PCA(df_SMB[,c(9:13)], graph = FALSE)

SMB.pca.biplot <- fviz_pca_biplot(SMB.pca, label ="var", # plot with Add arrows 
                geom.ind = c("point","text"),
                title = "PCA of Smallmouth Bass") 


YP.pca <- PCA(df_YP[,c(9:13)], graph = FALSE)
YP.pca.biplot <- fviz_pca_biplot(YP.pca, label ="var", # plot with Add arrows 
                geom.ind = c("point","text"),
                title = "PCA of Yellow Perch") 
YP.outliers.id <- fviz_pca_ind(YP.pca)
pairs(df_YP[,c(9:13)])

YP.pca$var$contrib # percentages - Dim 1 has almost positive equal contributions (except gonad weight) 
# Dim 2 is 80% gonad weight, 8% total length 
# fish with big gonads that are a bit shorter are at the top 
# ( consider putting 2 species level biplots side by side for comparison)

# separate PCA scores for each species
ind_YP <- get_pca_ind(YP.pca) # Coordinates of individuals
scores_YP <- as.data.frame(ind_YP$coord) # These are principal components 1-5
df_YP_pca <- data.frame(df_YP,scores_YP[,1:2]) #Complete fish dataframe with PCA values

# for plotting# 
library(gridExtra)
library(grid)
library(lattice)
pres_theme <- NULL
#
a<-fviz_contrib(YP.pca, choice = "var", axes = 1, top = 10,
             title = "Contribution of variables to Dimension 1 (Yellow Perch)") +
        pres_theme
b<-fviz_contrib(YP.pca, choice = "var", axes = 2, top = 10,
             title = "Contribution of variables to Dimension 2 (Yellow Perch)")  +
        pres_theme
grid.arrange(a, b, nrow = 2)

ind_SMB <- get_pca_ind(SMB.pca) # Coordinates of individuals
scores_SMB <- as.data.frame(ind_SMB$coord) # These are principal components 1-5
df_SMB_pca <- data.frame(df_SMB,scores_SMB[,1:2]) #Complete fish dataframe with PCA values

c<-fviz_contrib(SMB.pca, choice = "var", axes = 1, top = 10,
                title = "Contribution of variables to Dimension 1 (Smallmouth Bass)") + pres_theme
d<-fviz_contrib(SMB.pca, choice = "var", axes = 2, top = 10,
                title = "Contribution of variables to Dimension 2 (Smallmouth Bass)") + pres_theme
grid.arrange(c, d, nrow = 2)

## linear model ## 
library(lme4)
library(DHARMa)

ggplot(AllFish, aes(x= TotalWeight_g, y = GonadWeight_g, shape=Species, colour=Sex, na.rm=TRUE)) +
        geom_point(size = 2.2) +
        geom_smooth(aes(x = TotalWeight_g, y = GonadWeight_g), method = "lm") +
        labs(x="Total fish weight(g)", y="Gonad weight (g)", shape="Species", colour="Sex") +
        facet_wrap("Species", scale="free_x")+
        ggtitle("Total weight vs Gonad weight of males vs females in SMB and YP") +pres_theme

# Remove fish where Hg wasn't measured
df_SMB_pca2 <- drop_na(df_SMB_pca, Hg_ug_per_kgww)
df_YP_pca2 <- drop_na(df_YP_pca, Hg_ug_per_kgww)
AllFish_pca2 <- drop_na(AllFish_pca, Hg_ug_per_kgww)
unique(df$Date)

df_SMB_pca2$Site <- factor(df_SMB_pca2$Site,levels=c("REF","NF","FF"))
df_YP_pca2$Site <- factor(df_YP_pca2$Site,levels=c("REF","NF","FF"))

lmem <- lmer(log(Hg_ug_per_kgww)~Dim.1+Sex+Site+Species+(1|Date), 
             data=AllFish_pca2)


## diagnostic plots for lmem
ss <- simulateResiduals(lmem)
plot(ss)
plotResiduals(ss, form=AllFish_pca2$Dim.1)

# YP Separately
lmem_YP <- lmer(log(Hg_ug_per_kgww)~Dim.1+Sex+Site+(1|Date), 
             data=df_YP_pca2)
plot(simulateResiduals(lmem_YP))

library(broom.mixed)
aa <- augment(lmem_YP)

#plotResiduals(ss_YP, form=df_YP_pca2$Dim.1)

# SMB Separately
lmem_SMB <- lmer(log(Hg_ug_per_kgww)~Dim.1+Sex+Site+(1|Date), 
                data=df_SMB_pca2)
plot(simulateResiduals(lmem_SMB))
# plotResiduals(ss_SMB, form=df_SMB_pca2$Dim.1)

## LMEM results and post-hoc tests

plot(allEffects(lmem_SMB)) # Yellow perch
summary(lmem_SMB)
Anova(lmem_SMB) 
e2 <- emmeans(lmem_SMB,~Site) 
contrast(e2,"pairwise")

plot(allEffects(lmem_YP))
summary(lmem_YP)
Anova(lmem_YP)
e1 <- emmeans(lmem_YP,~Site)
contrast(e1,"pairwise") #this doesn't work once we have 3 levels for site

