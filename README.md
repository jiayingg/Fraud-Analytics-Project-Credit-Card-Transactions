# Fraud Analytics Project: Credit Card Transactions

>Corporate Card Transaction Data is dataset recorded 95,272 credit card transactions made during the year of 2010. For each transaction record, there’s detailed information of card number, transaction date, merchant number, merchant state and zip, etc. In addition, each record is given a fraud label indicating whether or not the record is categorized as a fraud. There are total of 4000 fraudulent transaction records. Through supervised and unsupervised (where we mask the labels) learning method, we built several different linear and nonlinear models to compute a fraud score for each record, and use the fraud labels to calculate our fraud detection rate. The goal is to catch as many fraudulent transactions as possible.

### Contributors

- Jiaying Gu
- Jessie Yu
- Siyu Zhang
- Ruoyu Sun
- Isabelle Zhao

## Supervised Learning

### Executive Summary

We started the project by conducting a data quality report on the dataset, briefly explored the dataset and found interesting and unusual things about the data. After understanding what the data is about, we began to build variables and prepared for model construction. The entity levels we chose are card number (CARDNUM), merchant number (MERCHNUM) and State (MERCHSTATE). Since we want to study the transaction behavior, we focus on the number of transactions, the amount of transaction and duplicated transaction amounts. For the entity STATE, we calculated the percentage of transactions on a certain card that happened in the same state as the current record. Under these guidelines, we built 25 variables for modeling. 

After building the variables, we first separated the out-of-time data, which contains all the transactions from 9/1 and onward. Then we separated the rest of the data to training (80%) and testing data (20%). For the training data, to get better modeling results and higher fraud detection rates, we also down-sampled the goods: select only a fraction of the nonfraud records with all the fraud records. The ratios between nonfraud-to-fraud are 1/1, 3/1, 5/1, 7/1, and 10/1. The models include **Logistics**, **LDA**, **QDA**, **random forest**, **CART**, **boosted tree**, **SVM**, **neural network** and **KNN**. We compared our models based on their FDR@3%, and finally KNN model came up with the best result. Following sections are detailed discussion of the data, the process of selecting entities and building variables, model algorithm and our model results including the model performance and the score distribution tables.

### Summary of Data

The data contains credit card transaction records, along with the card number, merchant information, and transaction date and type. There is a total of 95,271 records (We excluded the one record related to Mexico with a suspiciously high transaction amount, the detail record is listed below) with 10 fields (1 unique identifier, 1 dependent variable, 8 independent variables). For each record, fraud label of “1” means that the record is fraud and “0” means that the record is nonfraud. In the data set, the percentage of records with “Fraud label” =1 approximately equals to 4.2%. The timeframe was from 1/1/2010 to 12/31/2010 and the original format is .csv file. Below is a summary of the field names and the percent populated in each field.

<table>
  <tr>
    <th></th>
    <th>Field Name</th>
    <th>% Populated</th>
  </tr>
  <tr>
    <td>Dependent variable</td>
    <td>FRAUD LABEL</td>
    <td>100%</td>
  </tr>
  <tr>
    <td>Numerical Independent variables</td>
    <td>AMOUNT</td>
    <td>100%</td>
  </tr>
  <tr>
    <td rowspan="7">Categorical Independent variables</td>
    <td>CARDNUM</td>
    <td>100%</td>
  </tr>
  <tr>
    <td>MERCHNUM</td>
    <td>96%</td>
  </tr>
  <tr>
    <td>MERCHDESCRIPTION</td>
    <td>100%</td>
  </tr>
  <tr>
    <td>MERCHSTATE</td>
    <td>99%</td>
  </tr>
  <tr>
    <td>TRANSTYPE</td>
    <td>100%</td>
  </tr>
  <tr>
    <td>MERCHZIP</td>
    <td>95%</td>
  </tr>
  <tr>
    <td>DATE</td>
    <td>100%</td>
  </tr>
</table>

From our basic exploration of the data, a few findings may help guide further analysis:

- The number of transactions associated with each card number varies greatly, with largest number over 1,000. The number of transactions for each merchant also varies greatly, with largest number over 9,000. It might be interesting to explore the high values within these two entities.

- The zip code with each merchant has the highest number of missing values. The zip codes listed also have different length and formats. Due to the unexplainable irregularity in this field, we might not choose it as an entity for our analysis.

- This is the largest amount of payment in the dataset, and has a significantly higher value than other records. There are many missing information in this row and the information of Merchant description which is “INTERMEXICO” is very suspicious associated with this payment amount. The existence of this record might have an influence on our scoring of other records.
<table>
  <tr>
    <th>Record #</th>
    <th>CARDNUM</th>
    <th>DATE</th>
    <th>MERCHNUM</th>
    <th>MERCHDESCRIPTION</th>
    <th>MERCHSTATE</th>
    <th>MERCHZIP</th>
    <th>TRANSTYPE</th>
    <th>AMOUNT</th>
  </tr>
  <tr>
    <td>52293</td>
    <td>5142189135</td>
    <td>7/13/2010</td>
    <td></td>
    <td>INTERMEXICO</td>
    <td></td>
    <td></td>
    <td>P</td>
    <td>$3,102,045.53</td>
  </tr>
</table>

### Entities and Variables

- Entities

We divided the data mainly based on two entity levels: CARDNUM and MERCHNUM. Observing anomalies on these two entity levels may help account for the user differences among different card holders and different merchants. We also included STATE as an entity level, and observed the frequency of location changes for a given card on a given date.

- Variables

We added a total of 25 variables to model our data. Our intention is to find anomalies based on the number of transactions and the transaction amounts during a time frame. 

For entities CARDNUM and MERCHNUM, we calculated the number of transactions, the total transaction amount, and the number of duplicates in amount value in a given time on each entity level. Due to the usual patterns of credit card fraud, we selected the time frame to be in the past 1, 2, 3, or 7 days. Since we are assuming that we have no knowledge of records that happened after each existing record, we standardized the number of transactions and total transaction amount by setting the activity on each entity level in the past 90 days as normal. For variables that convey information about duplicate transaction amounts, we standardized the variables by setting the total number of transactions in the given time frame on a certain entity level as base, and divided it by the number of transactions that have the same amount as the record at hand in that time frame and entity level. We multiplied this fraction by 100 to get the percentage value of transactions that have duplicate values as the current record. The higher this number is, the more likely duplicate amounts occurred.

For the entity STATE, we calculated the percentage of transactions on a certain card that happened in the same state as the current record. We set the time frame to be in the past 1 day, since the change of location is time-sensitive. A longer time frame would be unnecessary, as it is possible and reasonable that travel occurred during a few days’ time, and a change in state that happened in the past 1 day has a much higher probability of fraud. If this variable is 100, it means that the card has only been used in one state during the past 1 day. If the variable is small, it means that only a few records happened in a different location from most, and these are anomalies that we should put focus on.

Below are our variables:

- card_scale_trans_N=(90/N)∙(Number of transactions in the past N days on this card)/(Number of transactions in the past 90 days on this card),For N = 1, 2, 3, 7
- card_scale_amount_N=(90/N)∙( Total transaction amount in the past N days on this card)/( Total transaction amount in the past 90 days on this card), For N = 1, 2, 3, 7
- merch_scale_trans_N=(90/N)∙(Number of transactions in the past N days from merchant)/(Number of transactions in the past 90 days from merchant), For N = 1, 2, 3, 7
- merch_scale_amount_N=(90/N)∙( Total trans amount in the past N days from merchant)/( Total trans amount in the past 90 days from merchant), For N = 1, 2, 3, 7
- card_scale_dup_N=100∙(Number of trans in the past N days on this card with same amount)/(Number of transactions in the past N days on this card), For N = 1, 2, 3, 7
- card_scale_dup_N=100∙(Number of trans in the past N days from merch with same amount)/(Number of transactions in the past N days from merchant), For N = 1, 2, 3, 7
- card_scale_State_N=100∙(Number of trans in the past 1 day on this card with same state)/(Number of transactions in the past 1 day on this card), For N = 1

### Model Algorithm

- Model choosing

After creating the 25 variables as mentioned above, we ran 2 sets of models to see which performs better: Logistic regression, LDA, QDA – Linear and simpler models. They should give us a baseline that all the nonlinear methods should improve over. Random forest, SVM, neural network, CART, boosted tree, KNN – More sophisticated non-linear model. We expected these models to perform slightly better than logistic regression.

- Data standardization

Experience as shown that neural network training is usually more efficient when numeric independent variables are scaled, or normalized, so that their magnitudes are relatively similar. Normalization also help SVM performs better in that all features have roughly the same magnitude (since we don’t assume that some features are much more important than others). For this reason, we scaled the data we fed into the models. Noticed that we didn’t apply data normalization to data to other models such as random forest because random forest is invariant to monotonic transformations of individual features so translations or per feature scaling will not change anything to the performance.

- How to calculate FDA @3%

We calculate fraud detective rate for each model in order to know which one performs better. After we ran each model, we got a probability, which we used as a score, for each record. We sorted the records by probability from high to low and chose top 3%.

FDR@3%=(label=1 @3%)/(label=1 in Training/Testing/OOD)
We applied the same method to all the models and came up with the table below: 

	d1 ~ d10: down sample the goods from 1/1 goods-to-bads to 10/1 goods-to-bads.
	
	Base: original training dataset, without down sample the goods, 25 independent variables
	
	v2: dataset from project 2, 16 independent variables
