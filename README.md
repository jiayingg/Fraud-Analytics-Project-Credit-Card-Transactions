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

<table style="border-collapse:collapse;border-spacing:0"><tr><th style="font-family:Arial, sans-serif;font-size:14px;font-weight:normal;padding:10px 5px;border-style:solid;border-width:1px;overflow:hidden;word-break:normal;text-align:center;vertical-align:top"></th><th style="font-family:Arial, sans-serif;font-size:14px;font-weight:bold;padding:10px 5px;border-style:solid;border-width:1px;overflow:hidden;word-break:normal;text-align:center;vertical-align:top">Field Name</th><th style="font-family:Arial, sans-serif;font-size:14px;font-weight:bold;padding:10px 5px;border-style:solid;border-width:1px;overflow:hidden;word-break:normal;text-align:center;vertical-align:top">% Populated</th></tr><tr><td style="font-family:Arial, sans-serif;font-size:14px;padding:10px 5px;border-style:solid;border-width:1px;overflow:hidden;word-break:normal;font-weight:bold;text-align:center;vertical-align:top">Dependent variable</td><td style="font-family:Arial, sans-serif;font-size:14px;padding:10px 5px;border-style:solid;border-width:1px;overflow:hidden;word-break:normal;text-align:center;vertical-align:top">Fraud label</td><td style="font-family:Arial, sans-serif;font-size:14px;padding:10px 5px;border-style:solid;border-width:1px;overflow:hidden;word-break:normal;text-align:center;vertical-align:top">100%</td></tr><tr><td style="font-family:Arial, sans-serif;font-size:14px;padding:10px 5px;border-style:solid;border-width:1px;overflow:hidden;word-break:normal;font-weight:bold;text-align:center;vertical-align:top">Numerical Independent variables</td><td style="font-family:Arial, sans-serif;font-size:14px;padding:10px 5px;border-style:solid;border-width:1px;overflow:hidden;word-break:normal;text-align:center;vertical-align:top">AMOUNT</td><td style="font-family:Arial, sans-serif;font-size:14px;padding:10px 5px;border-style:solid;border-width:1px;overflow:hidden;word-break:normal;text-align:center;vertical-align:top">100%</td></tr><tr><td style="font-family:Arial, sans-serif;font-size:14px;padding:10px 5px;border-style:solid;border-width:1px;overflow:hidden;word-break:normal;font-weight:bold;text-align:center;vertical-align:top" rowspan="7">Categorical Independent variables</td><td style="font-family:Arial, sans-serif;font-size:14px;padding:10px 5px;border-style:solid;border-width:1px;overflow:hidden;word-break:normal;text-align:center;vertical-align:top">CARDNUM</td><td style="font-family:Arial, sans-serif;font-size:14px;padding:10px 5px;border-style:solid;border-width:1px;overflow:hidden;word-break:normal;text-align:center;vertical-align:top">100%</td></tr><tr><td style="font-family:Arial, sans-serif;font-size:14px;padding:10px 5px;border-style:solid;border-width:1px;overflow:hidden;word-break:normal;text-align:center;vertical-align:top">MERCHNUM</td><td style="font-family:Arial, sans-serif;font-size:14px;padding:10px 5px;border-style:solid;border-width:1px;overflow:hidden;word-break:normal;text-align:center;vertical-align:top">96%</td></tr><tr><td style="font-family:Arial, sans-serif;font-size:14px;padding:10px 5px;border-style:solid;border-width:1px;overflow:hidden;word-break:normal;text-align:center;vertical-align:top">MERCHDESCRIPTION</td><td style="font-family:Arial, sans-serif;font-size:14px;padding:10px 5px;border-style:solid;border-width:1px;overflow:hidden;word-break:normal;text-align:center;vertical-align:top">100%</td></tr><tr><td style="font-family:Arial, sans-serif;font-size:14px;padding:10px 5px;border-style:solid;border-width:1px;overflow:hidden;word-break:normal;text-align:center;vertical-align:top">MERCHSTATE</td><td style="font-family:Arial, sans-serif;font-size:14px;padding:10px 5px;border-style:solid;border-width:1px;overflow:hidden;word-break:normal;text-align:center;vertical-align:top">99%</td></tr><tr><td style="font-family:Arial, sans-serif;font-size:14px;padding:10px 5px;border-style:solid;border-width:1px;overflow:hidden;word-break:normal;text-align:center;vertical-align:top">TRANSTYPE</td><td style="font-family:Arial, sans-serif;font-size:14px;padding:10px 5px;border-style:solid;border-width:1px;overflow:hidden;word-break:normal;text-align:center;vertical-align:top">100%</td></tr><tr><td style="font-family:Arial, sans-serif;font-size:14px;padding:10px 5px;border-style:solid;border-width:1px;overflow:hidden;word-break:normal;text-align:center;vertical-align:top">MERCHZIP</td><td style="font-family:Arial, sans-serif;font-size:14px;padding:10px 5px;border-style:solid;border-width:1px;overflow:hidden;word-break:normal;text-align:center;vertical-align:top">95%</td></tr><tr><td style="font-family:Arial, sans-serif;font-size:14px;padding:10px 5px;border-style:solid;border-width:1px;overflow:hidden;word-break:normal;text-align:center;vertical-align:top">DATE</td><td style="font-family:Arial, sans-serif;font-size:14px;padding:10px 5px;border-style:solid;border-width:1px;overflow:hidden;word-break:normal;text-align:center;vertical-align:top">100%</td></tr></table>

<table>
  <tr>
    <th></th>
    <th>Field Name</th>
    <th>% Populated</th>
  </tr>
  <tr>
    <td>Dependent variable</td>
    <td>Fraud label</td>
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
