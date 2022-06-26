

# load libraries
 # data wrangling
library(modelr) # factor manipulation
library(skimr) # data exploration - N/A for v3.3.2
library(ggplot2) #visualization
library(corrplot) # visualisation
#library(VIM) # missing values
#library(rsample)
#library(vip)
library(car) # modeling
#library(glmnet) # logistic regression
#library(caret) # CV
#library(ROCR) # model validation
#library(MASS) # model validation
#library(randomForest) # modeling Random Forest
#library(e1071) # modeling Random Forest tuning





# dataframe
churn.df <- read.csv('https://raw.githubusercontent.com/jotsap/DS7331/master/data/churn.csv')


# CustomerID not necessary for analysis
library(tidyverse)
churn.df %>% dplyr::select(-customerID)  -> churn.df
# alternate code: churn.df$customerID <- NULL


# make FACTOR flavor of SeniorCitizen column
# recode 1 as "Yes" and 0 as "No"
dplyr::recode_factor(
  churn.df$SeniorCitizen, 
  `1` = "Yes", `0` = "No"
) -> churn.df$SeniorCitizen
# alternate code: churn.df <- churn.df %>% mutate(SeniorCitizen = factor(SeniorCitizen))



### VALIDATE COUNT OF NA VALUES FOR ABOVE ROWS
# print("Total number of missing values for TotalCharges: ")
# sum(is.na(churn.df$TotalCharges))


# list rows with missing values
# churn.df[is.na(churn.df$TotalCharges), c('TotalCharges','tenure','MonthlyCharges')]

# list rows with tenure of 0
# churn.df[churn.df$tenure == 0, c('TotalCharges','tenure','MonthlyCharges')]

# use the value from MonthlyCharges as a placeholder for TotalCharges
churn.df$TotalCharges[churn.df$tenure == 0] <- churn.df$MonthlyCharges[churn.df$tenure == 0]













######## DATA EXPLORATION ######## 

### EDA: look at boxplot of the different numerical variables for each sample of customers: those that terminated services vs those that stayed

# split dataframes: numeric
churnNum.df <- churn.df %>% dplyr::select(tenure, MonthlyCharges, TotalCharges, Churn)

# create a vector of numNames
churnNumNames <- names(churnNum.df)
#remove Churn response
churnNumNames[-4] -> churnNumNames

### BOXPLOT OF NUMERICAL VALUES VS CHURN
boxplot_vs_response <- function(x) {
  ggplot(data = churnNum.df, aes_string(y=x, x="Churn", fill="Churn")) + geom_boxplot() + coord_flip() 
}

lapply(churnNumNames, boxplot_vs_response)





### EDA:  barplots for the categoric variales to get a sense of the different ratio of customers who terminated service for each categorical column's level

# split dataframes: categorical
churnCat.df <- churn.df %>% dplyr::select(-tenure, -MonthlyCharges, -TotalCharges)

# create a vector of numNames and catNames
churnCatNames <- names(churnCat.df)
#remove Churn response
churnCatNames[-17] -> churnCatNames


### BARPLOT OF CATEGORICAL VALUES VS CHURN
ggplot(data = churnCat.df, aes_string(x="OnlineSecurity", y="Churn", fill="Churn")) + geom_col() 




barplot_vs_response <- function(x) {
  ggplot(data = churnCat.df, aes_string(x = x, y="Churn", fill = "Churn")) + geom_col() 
}

lapply(churnCatNames, barplot_vs_response)












### CREATE DATA CATEGORIES
# 0 to 11 months
# 12 to 23 months
# 24 to 47 months
# 48+ months



# creating bins for tenure
# under 1 year
# 1 - 2 years
# 2 - 4 years
# Over 4 years

cut(churn.df$tenure, 
    breaks = c(0,11,23,47,999), 
    labels = c("Under_1_Year","1_to_2_Years","2_to_4_Years","Over_4_Years"),
    include.lowest = T
) -> churn.df$tenureCat

# validate accuracy new Annual Income categorical parameter
# churn.df[c(1,5,10,15,20,25,30,35,40,45),c("tenure","tenureCat")]




### EDA: MonthlyCharges By Category

# creating bins for MonthlyCharges
# create EVEN breaks

cut(churn.df$MonthlyCharges, 
    breaks = 3, 
    labels = c("Low","Med","High"),
    include.lowest = T
) -> churn.df$monthlyCat

# validate accuracy new Annual Income categorical parameter
# churn.df[c(1,5,10,15,20,25,30,35,40,45),c("MonthlyCharges","monthlyCat")]



# plot of tenureCategory

# plot(churn.df$tenureCat, main = "Churn by Tenure Category")







### UNSUPERVISED CLUSTER
library(cluster)
# library(FactoMineR) # PCA modeling
# library(factoextra) # PCA analysis



### REMOVE DATA LEAKAGE
# exclude Contract, PaperlessBilling, PaymentMethod, TotalCharges, Churn
churn.df %>% dplyr::select(-c('Contract', 'PaperlessBilling', 'PaymentMethod', 'TotalCharges', 'Churn','tenure','MonthlyCharges'))  -> churncluster.df



###Gower Calculation

# available metric options are: c("euclidean", "manhattan", "gower")
churngower.dist <- daisy(churncluster.df, metric = c("gower"))

# class(churngower.dist) 

# store as matrix
as.matrix(churngower.dist) -> churngower.mtx


#most SIMILAR pair
# churncluster.df[which(churngower.mtx == min(churngower.mtx[churngower.mtx != min(churngower.mtx)] ), arr.ind = T )[1,],  ]

#most DISsimilar pair
# churncluster.df[which(churngower.mtx == max(churngower.mtx[churngower.mtx != max(churngower.mtx)] ), arr.ind = T )[1,],  ]



# Agglomerative clustering
churn.hclust.agg <- hclust(churngower.dist, method = "complete")
# hclust method = c('complete','average','single') 
plot(churn.hclust.agg, main = "Agglomerative Hierarchical Cluster With Complete Linkages")


# Divisive clustering
start_cluster <- Sys.time()
churn.hclust.div <- diana(as.matrix(churngower.dist), diss = TRUE, keep.diss = TRUE)
end_cluster <- Sys.time()

plot(churn.hclust.div, main = "Divisive Hierarchical Cluster")







#### CPU INTENSE ####
install.packages("fpc")
library(fpc)

cstats.table <- function(dist, tree, k) {
  clust.assess <- c("cluster.number","n","within.cluster.ss","average.within","average.between",
                    "wb.ratio","dunn2","avg.silwidth")
  clust.size <- c("cluster.size")
  stats.names <- c()
  row.clust <- c()
  output.stats <- matrix(ncol = k, nrow = length(clust.assess))
  cluster.sizes <- matrix(ncol = k, nrow = k)
  for(i in c(1:k)){
    row.clust[i] <- paste("Cluster-", i, " size")
  }
  for(i in c(2:k)){
    stats.names[i] <- paste("Test", i-1)
    
    for(j in seq_along(clust.assess)){
      output.stats[j, i] <- unlist(cluster.stats(d = dist, clustering = cutree(tree, k = i))[clust.assess])[j]
      
    }
    
    for(d in 1:k) {
      cluster.sizes[d, i] <- unlist(cluster.stats(d = dist, clustering = cutree(tree, k = i))[clust.size])[d]
      dim(cluster.sizes[d, i]) <- c(length(cluster.sizes[i]), 1)
      cluster.sizes[d, i]
      
    }
  }
  output.stats.df <- data.frame(output.stats)
  cluster.sizes <- data.frame(cluster.sizes)
  cluster.sizes[is.na(cluster.sizes)] <- 0
  rows.all <- c(clust.assess, row.clust)
  
  # rownames(output.stats.df) <- clust.assess
  output <- rbind(output.stats.df, cluster.sizes)[ ,-1]
  colnames(output) <- stats.names[2:k]
  rownames(output) <- rows.all
  is.num <- sapply(output, is.numeric)
  output[is.num] <- lapply(output[is.num], round, 2)
  output
}


## DIVISIVE STATS
# capping the maximum amout of clusters at 6

stats.df.div <- cstats.table(churngower.dist, churn.hclust.div, 6)
stats.df.div

## AGGLOMERATIVE STATS
# capping the maximum amout of clusters at 6
stats.df.aggl <-cstats.table(churngower.dist, churn.hclust.agg, 6) 
stats.df.aggl




# Elbow for Divisive clustering
ggplot(data = data.frame(t(cstats.table(churngower.dist, churn.hclust.div, 9))), 
       aes(x=cluster.number, y=within.cluster.ss)) + 
  geom_point()+
  geom_line()+
  ggtitle("Divisive clustering") +
  labs(x = "Num.of clusters", y = "Within clusters sum of squares (SS)") +
  theme(plot.title = element_text(hjust = 0.5))



# Elbow for Agglomerative clustering
ggplot(data = data.frame(t(cstats.table(churngower.dist, churn.hclust.agg, 9))), 
       aes(x=cluster.number, y=within.cluster.ss)) + 
  geom_point()+
  geom_line()+
  ggtitle("Agglomerative clustering") +
  labs(x = "Num.of clusters", y = "Within clusters sum of squares (SS)") +
  theme(plot.title = element_text(hjust = 0.5))





### VISUAL: plot cluster with each k colored separately
# dendrogram starting point
library("dendextend")





### AGGLOMERATIVE CLUSTERING
dendro <- as.dendrogram(churn.hclust.agg)

#using 4 clusters as per Elbow and Silhouette
dendro.col <- dendro %>%
  set("branches_k_color", k = 4, value =   c("blue", "red", "green", "black")) %>%
  set("branches_lwd", 0.6) %>%
  set("labels_colors", 
      value = c("darkslategray")) %>% 
  set("labels_cex", 0.5)
ggd1 <- as.ggdend(dendro.col)
ggplot(ggd1, theme = theme_minimal()) +
  labs(x = "Num. observations", y = "Height", title = "Dendrogram, k = 4")



### DIVISIVE CLUSTERING
dendro <- as.dendrogram(churn.hclust.div)

#using 4 clusters as per Elbow and Silhouette
dendro.col <- dendro %>%
  set("branches_k_color", k = 4, value =   c("blue", "red", "green", "black")) %>%
  set("branches_lwd", 0.6) %>%
  set("labels_colors", 
      value = c("darkslategray")) %>% 
  set("labels_cex", 0.5)
ggd1 <- as.ggdend(dendro.col)
ggplot(ggd1, theme = theme_minimal()) +
  labs(x = "Num. observations", y = "Height", title = "Dendrogram, k = 4")

















































