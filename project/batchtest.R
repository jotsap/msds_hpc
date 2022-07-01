
### INSTALL LIBRARY
library(magrittr)
library(dplyr)

### DATA LOAD
credit.df <- read.csv("https://raw.githubusercontent.com/jotsap/msds_hpc/main/project/Kaggle_Credit_Small.csv", header = T)

### DATA MUNGE

# create transaction amount categories
cut(
  credit.df$amount,
  breaks = c(0,1000,10000,50000,100000,250000,500000,99999999),
  labels = c("under_1k","1k_to_10k","10k_to_50k","50k_to_100k","100k_to_250k","250k_to_500k","over_500k"),
  include.lowest = T
) -> credit.df$amountCat

# create change in balance for destination account
(credit.df$newbalanceDest - credit.df$oldbalanceDest) -> credit.df$deltaBalanceDest


### DATA OUTPUT
# setwd("$WORK/batch_r")
# write.csv(credit.df, file = "rbatchout.csv", row.names = T)
write.csv(credit.df, file = file.path("/work/users/jotsap/rbatch/rbatchout.csv"), row.names = T)

# DPLYR OUTPUT
#setwd("/work/users/jotsap")
#write_csv(credit.df, path = file.path( "~/batchtest/batchout.csv"), col_names = T)




