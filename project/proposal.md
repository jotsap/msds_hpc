## Proposal: Fraud Detection




**Data source**
I have 3 different data sets of credit transactions which I am currently evaluating  

Rows: 284,808
Predictors: 
* Time: Int
* V1 through V28: Int [6 sig digits]
* Amount: Float [2 sig digits]

PREDICTION:
* Class [boolean]


Rpubs: Fraud Detection
https://rpubs.com/casater/621482


* step [int]: Maps a unit of time in the real world. In this case 1 step is 1 hour of time. Total steps 744 (30 days simulation).
* type [factor]: CASH-IN, CASH-OUT, DEBIT, PAYMENT and TRANSFER
* amount [int]: amount of the transaction in local currency
* nameOrig [char]: customer who started the transaction
* oldbalanceOrg [dollar]: initial balance before the transaction
* newbalanceOrig [dollar]: customer's balance after the transaction.
* nameDest [char]: recipient ID of the transaction.
* oldbalanceDest [float]: initial recipient balance before the transaction.
* newbalanceDest [float]: recipient's balance after the transaction.

PREDICTION:
* isFraud [boolean]: identifies a fraudulent transaction (1) and non fraudulent (0)
  
  
Kaggle: Credit Card Fraud - 150MB
https://www.kaggle.com/datasets/kartik2112/fraud-detection
Dimensions: 555,718 Rows & 23 Factors

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

PREDICTION:
* is_fraud  


PREDICTION:
**Analysis workflow**


**Tools for implementing the workflow**


**Possible performance optimization targets**



