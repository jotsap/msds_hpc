## Proposal: Fraud Detection

Looking at doing a fraud detection binomial prediction model. Currently evaluating Random Forest, LASSO, and standard Logistic Regression


### Data source  
I have 3 different data sets of credit transactions which I am currently evaluating  
  
**Data Flair: Credit Card Fraud - 143 MB**  
https://data-flair.training/blogs/data-science-machine-learning-project-credit-card-fraud-detection/  
Dimensions: 284,808 Rows & 30 Predictors  
 
Predictors: 
* Time: Int
* V1 through V28: Int [6 sig digits]
* Amount: Float [2 sig digits]

RESPONSE:
* Class [boolean]


**Rpubs: Fraud Detection - 470 MB**  
https://rpubs.com/casater/621482
Dimensions: 1,048,576 Rows & 9 Predictors

* step [int]: Maps a unit of time in the real world. In this case 1 step is 1 hour of time. Total steps 744 (30 days simulation).
* type [factor]: CASH-IN, CASH-OUT, DEBIT, PAYMENT and TRANSFER
* amount [int]: amount of the transaction in local currency
* nameOrig [char]: customer who started the transaction
* oldbalanceOrg [dollar]: initial balance before the transaction
* newbalanceOrig [dollar]: customer's balance after the transaction.
* nameDest [char]: recipient ID of the transaction.
* oldbalanceDest [float]: initial recipient balance before the transaction.
* newbalanceDest [float]: recipient's balance after the transaction.

RESPONSE:
* isFraud [boolean]: identifies a fraudulent transaction (1) and non fraudulent (0)
  
  
**Kaggle: Credit Card Fraud - 344 MB**  
https://www.kaggle.com/datasets/kartik2112/fraud-detection
Dimensions: 555,718 Rows & 22 Predictors

* trans_date_trans_time
* cc_num
* merchant
* category
* amt
* first
* last
* gender
* street
* city
* state
* zip
* lat
* long
* city_pop
* job	dob  
* trans_num  
* unix_time  
* merch_lat  
* merch_long  

RESPONSE:
* is_fraud  
  

### Analysis workflow  
Currently in development. Not sure if AutoML should be part of this?

### Tools for implementing the workflow  
I am initially developing this model in R. I'm using Caret on training data for hyperparameter tuning and AutoML

## Possible performance optimization targets  
TBD


