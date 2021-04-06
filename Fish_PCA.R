# Final project - PCA of Fish physical attributes #
# install.packages("FactoMineR")
# install.packages(("factoextra"))
library("FactoMineR")
library("factoextra")
library("tidyverse")
theme_set(theme_bw())

df<-read.csv("./New_Brunswick_Fall_2020_fish_data.csv") # choose clean data
View(df)

badfish <- c("REF-SMB-A-12","REF-YP-A-38","NF-SMB-A-15") # possible outliers from gonad/liver


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
                col.ind = AllFish$Sex, 
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

ind_SMB <- get_pca_ind(SMB.pca) # Coordinates of individuals
scores_SMB <- as.data.frame(ind_SMB$coord) # These are principal components 1-5
df_SMB_pca <- data.frame(df_SMB,scores_SMB[,1:2]) #Complete fish dataframe with PCA values


## linear model ## 
library(lme4)
library(DHARMa)

ggplot(AllFish, aes(x= TotalWeight_g, y = GonadWeight_g, shape=Species, colour=Sex, na.rm=TRUE)) +
        geom_point(size = 2.2) +
        geom_smooth(aes(x = TotalWeight_g, y = GonadWeight_g), method = "lm") +
        labs(x="Total fish weight(g)", y="Gonad weight (g))", shape="Species", colour="Sex") +
        facet_wrap("Species", scale="free_x")

# Remove fish where Hg wasn't measured
df_SMB_pca2 <- drop_na(df_SMB_pca, Hg_ug_per_kgww)
df_YP_pca2 <- drop_na(df_YP_pca, Hg_ug_per_kgww)
AllFish_pca2 <- drop_na(AllFish_pca, Hg_ug_per_kgww)

lmem <- lmer(log(Hg_ug_per_kgww)~Dim.1+Sex+Site+Species+(1|Site), 
             data=AllFish_pca2)


## diagnostic plots for lmem
ss <- simulateResiduals(lmem)
plot(ss)
plotResiduals(ss, form=AllFish_pca2$Dim.1)

# YP Separately
lmem_YP <- lmer(log(Hg_ug_per_kgww)~Dim.1+Sex+Site+(1|Site), 
             data=df_YP_pca2)
ss_YP <- simulateResiduals(lmem_YP)
plot(ss_YP)
plotResiduals(ss_YP, form=df_YP_pca2$Dim.1)

# SMB Separately

lmem_SMB <- lmer(log(Hg_ug_per_kgww)~Dim.1+Sex+Site+(1|Site), 
                data=df_SMB_pca2)
ss_SMB <- simulateResiduals(lmem_SMB)
plot(ss_SMB) 
plotResiduals(ss_SMB, form=df_SMB_pca2$Dim.1)
