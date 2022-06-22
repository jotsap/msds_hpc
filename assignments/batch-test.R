# data load script
# install library
install.packages("tidyverse")
library(tidyverse)
# load file
credit.df <- read.csv("https://raw.githubusercontent.com/jotsap/msds_hpc/main/project/creditcardsmall.csv", header = T)

### data munge

# create transaction amount categories
cut(
  credit.df$amount,
  breaks = c(0,1000,10000,50000,100000,250000,500000,99999999),
  labels = c("under_1k","1k_to_10k","10k_to_50k","50k_to_100k","100k_to_250k","250k_to_500k","over_500k"),
  include.lowest = T
) -> credit.df$amountCat

# create change in balance for destination account
(credit.df$newbalanceDest - credit.df$oldbalanceDest) -> credit.df$deltaBalanceDest


# data output
setwd("$WORK")
write.csv(credit.df, file = "batchout.csv", row.names = T)






