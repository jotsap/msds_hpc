### Possible performance optimization targets  
NOTE: this will be detailed in my Project Write-up / Presentation

**Data Loading**
Initially I placed the data file on Azure Blob storage, however it literally took OVER AN HOUR, so instead I staged the data on M2 $WORK
  
**Data Cleaning**
I got a *small* processing improvement using Dplyr as it has vectorized operations for several of the steps

**Data Modeling**
Using **Ranger** was leverates C++ libraries which offers performance improvement over the default RandomForest. Additionally using **Caret** and **Parallel** library, you can actually parallelize the model training processes
