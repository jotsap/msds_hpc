## Proposal: Fraud Detection

Looking at doing a fraud detection binomial prediction model. Currently evaluating Random Forest, LASSO, and standard Logistic Regression


### Data source  

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
  
### Analysis workflow  
Currently in development. Not sure if AutoML should be part of this?

### Tools for implementing the workflow  
I am initially developing this model in R. I'm using Caret on training data for hyperparameter tuning and AutoML  
Additionally R has packages that can parallelize such as RevoScaleR and doParallel()  


### Possible performance optimization targets  
NOTE: this will be detailed in my Project Write-up / Presentation

**Data Loading**
Initially I placed the data file on Azure Blob storage, however it literally took OVER AN HOUR, so instead I staged the data on M2 $WORK
  
**Data Cleaning**
I got a *small* processing improvement using Dplyr as it has vectorized operations for several of the steps

**Data Modeling**
Using **Ranger** was leverates C++ libraries which offers performance improvement over the default RandomForest. Additionally using **Caret** and **Parallel** library, you can actually parallelize the model training processes








