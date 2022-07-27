### DATA LOAD
# data was prestaged in $WORK to avoid repeated WGET
# plus size exceeded GitHub limits

# start time
start_load <- Sys.time() #start time

### OPTIMIZATION 1: PRE-STAGE DATA IN $WORK
credit.df <- read.csv(
  #file = "/work/users/jotsap/hpc_project/hpc_credit.csv",
  file = "D:/Temp/data/hpc/data/hpc_credit.csv",
  header = T
)

# end time
end_load <- Sys.time() #end time

# results
print(paste0("Processing time for loading data is ", end_load - start_load))
# "Processing time for loading data is 5.21095006863276"



#### DATA EXPLORATION & CLEANING ####

library(magrittr)
library(dplyr)


print(
  paste0("Number of rows ", dim(credit.df)[1])
)

print(
  paste0("Number of predictors ", dim(credit.df)[2] - 2)
)


str(credit.df)
tail(credit.df, 11)



##### missing values

# the long way

# start time
start_miss <- Sys.time() #start time

paste0("total missing values for step ",
       sum(is.na(credit.df$step))
)

paste0("total missing values for type ",
       sum(is.na(credit.df$type))
)

paste0("total missing values for amount ",
       sum(is.na(credit.df$amount))
)

paste0("total missing values for nameOrig ",
       sum(is.na(credit.df$nameOrig))
)

paste0("total missing values for oldbalanceOrg ",
       sum(is.na(credit.df$oldbalanceOrg))
)

paste0("total missing values for newbalanceOrig ",
       sum(is.na(credit.df$newbalanceOrig))
)

paste0("total missing values for nameDest ",
       sum(is.na(credit.df$nameDest))
)

paste0("total missing values for oldbalanceDest ",
       sum(is.na(credit.df$oldbalanceDest))
)

paste0("total missing values for newbalanceDest ",
       sum(is.na(credit.df$newbalanceDest))
)

paste0("total missing values for isFraud ",
       sum(is.na(credit.df$isFraud))
)

paste0("total missing values for isFlaggedFraud ",
       sum(is.na(credit.df$isFlaggedFraud))
)

# end time
end_miss <- Sys.time() #end time

# results
print(paste0("Processing time for missing values is ", end_miss - start_miss))





### DATA PROCESS
### START TIME
start_proc <- Sys.time() #start time


### isFlaggedFraud not necessary for analysis
credit.df %>% select(-isFlaggedFraud) -> creditclean.df


### convert nameOrig and nameDest from factor to character

as.character( creditclean.df$nameOrig ) -> creditclean.df$nameOrig
as.character( creditclean.df$nameDest ) -> creditclean.df$nameDest

### convert type to factor
as.factor( creditclean.df$type) -> creditclean.df$type

### Convert isFraud Response to factor "Yes" or "No"

# recode 1 as "Yes" and 0 as "No"
dplyr::recode_factor(
  creditclean.df$isFraud, 
  `1` = "Yes", `0` = "No"
) -> creditclean.df$isFraud



### Create transaction amount categories
cut(
  creditclean.df$amount,
  breaks = c(0,1000,10000,50000,100000,250000,500000,99999999),
  labels = c("under_1k","1k_to_10k","10k_to_50k","50k_to_100k","100k_to_250k","250k_to_500k","over_500k"),
  include.lowest = T
) -> creditclean.df$amountCat



# remove amount numerical to keep categorical
creditclean.df %>% select(-amount) -> creditclean.df


# remove nameDest and nameOrig
creditclean.df %>% select(-nameDest) -> creditclean.df
creditclean.df %>% select(-nameOrig) -> creditclean.df


### END TIME
end_proc <- Sys.time() #end time

### RESULTS
print(paste0("Processing time is ", end_proc - start_proc))
# "Processing time is 9.87370491027832 seconds"







### EDA FRAUD

# how imbalanced is Fraud vs Normal transaction
table(creditclean.df$isFraud)


#data frame of only Fraud
creditclean.df[creditclean.df$isFraud == "Yes",] -> credit_fraud.df 



print(
  paste0(
    ( nrow(credit_fraud.df) * 100)/ nrow(creditclean.df),
    " percent of transactions are fraudulent"
  ))




### is the dollar amount a good factor? 
# all transactions
summary(credit.df$amount)
# fraud only
summary(credit_fraud.df$amount)




### lets understand the outliers with respect to dollar amount

# transactions at or under $100,000
paste0(
  "Number of transactions at or under $100,000: ",
  dim(credit.df[credit.df$amount <= 100000,])[1]
)
paste0(
  ((dim(credit.df[credit.df$amount <= 100000,])[1]) / dim(credit.df)[1])*100,
  "% of total transactions"
)


# transactions over $100,000
paste0(
  "Number of transactions over $100,000: ",
  dim(credit.df[credit.df$amount > 100000,])[1]
)
paste0(
  ((dim(credit.df[credit.df$amount > 100000,])[1]) / dim(credit.df)[1])*100,
  "% of total transactions"
)



# FRAUD transactions over $100,000
paste0(
  "Number of FRAUD transactions over $100,000: ",
  dim(credit_fraud.df[credit_fraud.df$amount > 100000,])[1]
)
paste0(
  ((dim(credit_fraud.df[credit_fraud.df$amount > 100000,])[1]) / dim(credit_fraud.df)[1])*100,
  "% of FRAUD transactions"
)





# transactions that were under $1000
paste0(
  "Number of transactions at or under $1000: ",
  dim(credit.df[credit.df$amount <= 1000,])[1]
)

# FRAUD transactions that were under $1000
paste0(
  "Number of Fraud transactions at or under $1000: ",
  dim(credit_fraud.df[credit_fraud.df$amount <= 1000,])[1]
)





### TIME OF DAY

# Convert Step to Hours in 24 hours format
creditclean.df$hour <- mod(credit.df$step, 24)

# make categories
cut(
  creditclean.df$hour,
  breaks = c(0,8,16,24),
  labels = c("night","day","evening"),
  include.lowest = T
) -> creditclean.df$timeOfDay


# remove numerical step and hour
creditclean.df %>% select(-step) -> creditclean.df
creditclean.df %>% select(-hour) -> creditclean.df

### FRAUD TRANSACTIONS disproportionately high at night
table(creditclean.df[creditclean.df$isFraud == "Yes",c('timeOfDay')] )
table(creditclean.df[creditclean.df$isFraud == "No",c('timeOfDay')] )



### CONCLUSION
# data heavily imbalanced :. undersampling to minimize bias
# only FRAUD transaction types: CASH_OUT and TRANSFER
# FRAUD transactions disproportionately high midnight to 9am





### RANDOM FOREST DATA MODEL
library(caret)
library(randomForest)
library(e1071)
#library(ROCR)
#library(MASS)



# creating the 80 data partition 
fraud_split <- createDataPartition(creditclean.df$isFraud, p = 0.9, list = F)
# including 80 for training set
fraud_train.df <- creditclean.df[fraud_split,] 
# excluding 80 for testing set
fraud_test.df <- creditclean.df[-fraud_split,]






### training RF model
start_rf_none <- Sys.time() #start time
#library(profvis) # profiling

### BEGIN PROFILER
#profvis({

trainControl(
  method = "cv", 
  number = 5, 
  # summaryFunction = twoClassSummary,
  search = "grid",
  sampling = "down",
  savePredictions = "final",
  allowParallel = F
) -> fraudControl

fraudTune <- expand.grid(mtry = c(2,3,4,5))


train(
  isFraud ~ .,
  data = fraud_test.df,
  method = "rf",
  metric = "Accuracy",
  trControl = fraudControl,
  tuneGrid = fraudTune,
  importance = T,
  verboseIter = T
) -> fraud_train.rf

#}) ### END PROFILER



# end time
end_rf_none <- Sys.time() #end time

print(paste0("Calculation time is ", end_rf_none - start_rf_none))
# results: Calculation time is 22.9500871817271






#############################
###  SINGLE-THREAD RANGER  ###
#############################

library(ranger)

# training RF model using ranger
start_rf_ranger <- Sys.time() #start time


# training grid
trainControl(
  method = "cv",
  number = 5,
  summaryFunction = twoClassSummary, 
  savePredictions = "final", 
  classProbs = F, 
  verboseIter = F,
  search = "random",
  allowParallel = T
) -> final_caret.grid

# tuning grid
final_tune.grid <- expand.grid( 
  mtry = c(2,3,4,5), 
  min.node.size = 1,
  splitrule = "extratrees" 
)


# training RF model
train(
  isFraud ~ .,
  data = fraud_test.df,
  method = "ranger",
  trControl = final_caret.grid, 
  num.threads = (detectCores() - 1),
  tuneGrid = final_tune.grid,
  #  num.trees = 100,
  importance = 'impurity', #'impurity', 'permutation'
  metric = "Spec" # "Accuracy" or "Sens"
) -> fraud_train.ranger

# end time
end_rf_ranger <- Sys.time() #end time

print(paste0("Calculation time is ", end_rf_ranger - start_rf_ranger))
# results


















#############################
###  MULTI-THREAD RANGER  ###
#############################
# cluster preparation for parallel CPU
library(parallel)
library(doParallel)
cluster <- makeCluster(detectCores() - 1) # leave 1 core for OS
registerDoParallel(cluster)

library(ranger)
# training RF model using ranger
start_rf_parallel <- Sys.time() #start time


# training grid
trainControl(
  method = "cv",
  number = 5,
  summaryFunction = twoClassSummary, 
  savePredictions = "final", 
  classProbs = F, 
  verboseIter = F,
  search = "random",
  allowParallel = T
) -> final_caret.grid

# tuning grid
final_tune.grid <- expand.grid( 
  mtry = c(2,3,4,5), 
  min.node.size = 1,
  splitrule = "extratrees" 
  )


# training RF model
train(
  isFraud ~ .,
  data = fraud_test.df,
  method = "ranger",
  trControl = final_caret.grid, 
  tuneGrid = final_tune.grid,
  #  num.trees = 100,
  importance = 'impurity', #'impurity', 'permutation'
  metric = "Spec" # "Accuracy" or "Sens"
) -> fraud_train.ranger

# end time
end_rf_parallel <- Sys.time() #end time

print(paste0("Calculation time is ", end_rf_parallel - start_rf_parallel))
# results


### SHUTDOWN CLUSTER
stopCluster(cluster)





