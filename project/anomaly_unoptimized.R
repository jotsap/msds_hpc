
credit.df <- read.csv("https://raw.githubusercontent.com/jotsap/msds_hpc/main/project/Kaggle_Credit_Small.csv", header = T)


credit.df <- read.csv(
  file = "D:/Temp/data/hpc/data/Kaggle_Credit_Small.csv",
  header = T
)

# https://rpubs.com/casater/621482 
# Dimensions: 1,048,576 Rows & 9 Predictors

# step [int]: Maps a unit of time in the real world. In this case 1 step is 1 hour of time. Total steps 744 (30 days simulation).
# type [factor]: CASH-IN, CASH-OUT, DEBIT, PAYMENT and TRANSFER
# amount [int]: amount of the transaction in local currency
# nameOrig [char]: customer who started the transaction
# oldbalanceOrg [dollar]: initial balance before the transaction
# newbalanceOrig [dollar]: customer's balance after the transaction.
# nameDest [char]: recipient ID of the transaction.
# oldbalanceDest [float]: initial recipient balance before the transaction.
# newbalanceDest [float]: recipient's balance after the transaction.
#
# RESPONSE:
#  
# isFraud [boolean]: identifies a fraudulent transaction (1) and non fraudulent (0)
# isFlaggedFraud [boolean]: value predicted by model for training







#### DATA EXPLORATION & CLEANING ####

#library(tidyverse)
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




### DATA MUNGE

# isFlaggedFraud not necessary for analysis
credit.df %>% select(-isFlaggedFraud) -> credit.df
#credit.df$isFlaggedFraud <- NULL
#credit.df[,-11]

# convert nameOrig and nameDest from factor to character
as.character( credit.df$nameOrig ) -> credit.df$nameOrig
as.character( credit.df$nameDest ) -> credit.df$nameDest

# convert isFraud to factor
# recode 1 as "Yes" and 0 as "No"
dplyr::recode_factor(
  credit.df$isFraud, 
  `1` = "Yes", `0` = "No"
) -> credit.df$isFraud



# recipient ID represented by "nameDest" is not terribly useful
# however we CAN validate a specific ID has multiple transactions

# length(unique(as.character(credit.df$nameDest)))
length(unique(credit.df$nameDest)) #number of unique values


# sender ID represented by "nameOrig" is not terribly useful
# however we CAN validate a specific ID has multiple transactions

length(unique(credit.df$nameOrig)) #number of unique values



### ALL TRANSACTIONS CATEGORIES
# create transaction amount categories
cut(
  credit.df$amount,
  breaks = c(0,1000,10000,50000,100000,250000,500000,99999999),
  labels = c("under_1k","1k_to_10k","10k_to_50k","50k_to_100k","100k_to_250k","250k_to_500k","over_500k"),
  include.lowest = T
) -> credit.df$amountCat













### SEPARATE FRAUD

# how imbalanced is our transaction
table(credit.df$isFraud)

#data frame of only Fraud
credit.df[credit.df$isFraud == "Yes",] -> credit_fraud.df 
# credit.df %>% group_by(type) %>% summarise(fraud_transactions = sum(isFraud))
# table(credit.df[credit.df$isFraud == T,c('type')] )
# ggplot(data = credit_fraud.df, aes(x = type , fill = isFraud  )) + geom_bar() + labs(title = "Frequency of Transaction Type", subtitle = "Fraud Only", x = 'Transaction Type' , y = 'No of transactions' ) +theme_classic()








summary(credit.df)
# using mlr library
# summarizeColumns(credit.df) %>% select(name,type,na,mean,median,min,max,nlevs)







# Visualize Fraud Data
# EXTREMELY imbalanced data set
g <- ggplot(credit.df, aes(isFraud))
g + geom_bar()+geom_label(stat='count',aes(   label=  paste0(  round(   ((..count..)/sum(..count..)) ,4)*100 ,  "%" ) ) )+ #add the percentage of each type as label
  labs(x = "Fraud vs Not Fraud", y = "Frequency", title = "Frequency of Fraud", subtitle = "Labels as Percent of Total Observations")

# of the 5 types of transactions what is the breakdown of Fraud vs Normal
# data is so imbalanced cannot even see Fraud data
ggplot(data = credit.df, aes(x = type , fill = as.factor(isFraud))) + geom_bar() + labs(title = "Frequency of Transaction Type", subtitle = "Fraud vs Not Fraud", x = 'Transaction Type' , y = 'No of transactions' ) +theme_classic()


### graph fraud separately
ggplot(data = credit_fraud.df, aes(x = type )) + geom_bar() + labs(title = "Frequency of Transaction Type", subtitle = "Fraud Only", x = 'Transaction Type' , y = 'No of transactions' ) +theme_classic()









### destination accounts
# is there a particular destination account that is suspicious?
table(credit_fraud.df$nameDest)
# we find most of them are only used 1 - 2 times
# thus not a good factor


### is the dollar amount a good factor? 
# create bins for dollar amount
summary(credit.df$amount)
hist(credit.df$amount) # heavily right-skewed
summary(credit_fraud.df$amount)
hist(credit_fraud.df$amount) # also heavily right-skewed



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





# transactions that were under $300
paste0(
  "Number of transactions at or under $300: ",
  dim(credit.df[credit.df$amount <= 300,])[1]
)

# FRAUD transactions that were under $300
paste0(
  "Number of Fraud transactions at or under $300: ",
  dim(credit_fraud.df[credit_fraud.df$amount <= 300,])[1]
)




# ALL: tyes by Amount Category
ggplot(data = credit.df, aes(x = type , fill = as.factor(amountCat))) + geom_bar() + labs(title = "Frequency of Transaction Type", subtitle = "All Transactions", x = 'Transaction Type' , y = 'No of transactions' ) +theme_classic()



# FRAUD: types by Amount Category
ggplot(data = credit_fraud.df, aes(x = type , fill = as.factor(amountCat))) + geom_bar() + labs(title = "Frequency of Transaction Type", subtitle = "Fraud Only", x = 'Transaction Type' , y = 'No of transactions' ) +theme_classic()





# boxplot amount
boxplot(
  amount ~ isFraud,
  data = credit.df,
  horizontal = T,
  names=c("Fraud","Normal"),
  col=c("red","gray"),
  main="Fraud vs Normal: Transaction Amount"
  )

boxplot(
  amount ~ type,
  data = credit.df,
  horizontal = T,
  col=rainbow(5),
  main="Transaction Amount by Type"
)







barplot(
  table(credit.df$amountCat),
  col = rainbow(7), 
  main = "Transactions by Category",
  names.arg = F,
  horiz = T,
  legend.text = levels(credit.df$amountCat),
  xlab = "Num of Transactions",
  ylab = "Transaction Amount"
)



hist(credit.df$deltaBalanceDest)

hist(credit_fraud.df$deltaBalanceDest)



# visualize InternetService and PaymentMethod
barplot(
  table(tenure.df$InternetService, tenure.df$PaymentMethod),
  main = "InternetService vs PaymentMethod",
  legend.text = levels(tenure.df$InternetService),
  col = rainbow(3),
  horiz = T
)

barplot(
  table(credit.df$type, credit.df$amountCat),
  main = "Transactions Type vs Amount",
#  names.arg = F,
  horiz = T,
  legend.text = levels(credit.df$type),
  col = rainbow(5)
)






### TIME OF DAY

# Convert Step to Hours in 24 hours format
credit.df$hour <- mod(credit.df$step, 24)

#All Transactions by hour
ggplot(data = credit.df, aes(x = step)) + geom_bar(aes(fill = 'isFraud'), show.legend = FALSE) +labs(title= 'Total transactions at different Hours', y = 'No. of transactions') + theme_classic()
#Fraud Transactions by hour
ggplot(data = credit_fraud.df, aes(x = step)) + geom_bar(aes(fill = 'isFraud'), show.legend = FALSE) +labs(title= 'Fraud transactions at different Hours', y = 'No. of fraud transactions') + theme_classic()

### FRAUD TRANSACTIONS disproportionately high from midnight to 8am-9am



### CONCLUSION
# data heavily imbalanced :. undersampling to minimize bias
# only FRAUD transaction types: CASH_OUT and TRANSFER
# FRAUD transactions disproportionately high midnight to 9am





# Filtering transactions and drop irrelevant features
transactions1<- transactions %>% 
  select( -one_of('step','nameOrig', 'nameDest', 'isFlaggedFraud')) %>%
  filter(type %in% c('CASH_OUT','TRANSFER'))









### RANDOM FOREST 
library(caret)
library(randomForest)
#library(ROCR)
#library(MASS)


### Remove unnecessary predictors
#credit.df <- credit.old

# remove step
credit.df %>% select(-step) -> credit.df
#numerical amount: only use categorical
credit.df %>% select(-amount) -> credit.df
# remove names or orginator and destination
credit.df %>% select(-nameOrig) -> credit.df
credit.df %>% select(-nameDest) -> credit.df


# creating the 80 data partition 
fraud_split <- createDataPartition(credit.df$isFraud, p = 0.8, list = F)
# including 80 for training set
fraud_train.df <- credit.df[fraud_split,] 
# excluding 80 for testing set
fraud_test.df <- credit.df[-fraud_split,]






recipe(isFraud ~ ., data = fraud_train.df, ...)

getModelInfo("rf")




# training RF model
start_rf_none <- Sys.time() #start time

trainControl(
  method = "cv", 
  number = 5, 
 # summaryFunction = twoClassSummary,
  search = "grid",
  sampling = "down",
 # classProbs = T,
  savePredictions = "final",
 # returnResamp = "final",
  allowParallel = F
) -> fraudControl

fraudTune <- expand.grid(mtry = 2:5)


train(
  isFraud ~ .,
  data = fraud_train.df,
  method = "rf",
 # ntree = 100,
  metric = "Accuracy",
  trControl = fraudControl,
  tuneGrid = fraudTune,
  importance = T,
  verboseIter = T
) -> fraud_train.rf

# end time
end_rf_none <- Sys.time() #end time

print(paste0("Calculation time is ", end_rf_none - start_rf_none))
# results

