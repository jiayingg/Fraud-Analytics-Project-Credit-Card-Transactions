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

After building the variables, we first separated the validation data, which contains all the transactions from 9/1 and onward. Then we separated the rest of the data to training (80%) and testing data (20%). For the training data, to get better modeling results and higher fraud detection rates, we also down-sampled the goods: select only a fraction of the nonfraud records with all the fraud records. The ratios between nonfraud-to-fraud are 1/1, 3/1, 5/1, 7/1, and 10/1. The models include **Logistics**, **LDA**, **QDA**, **random forest**, **CART**, **boosted tree**, **SVM**, **neural network** and **KNN**. We compared our models based on their FDR@3%, and finally KNN model came up with the best result. Following sections are detailed discussion of the data, the process of selecting entities and building variables, model algorithm and our model results including the model performance and the score distribution tables.

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

	card_scale_trans_N=(90/N)∙(Number of transactions in the past N days on this card)/(Number of transactions in the past 90 days on this card),For N = 1, 2, 3, 7
	card_scale_amount_N=(90/N)∙( Total transaction amount in the past N days on this card)/( Total transaction amount in the past 90 days on this card), For N = 1, 2, 3, 7
	merch_scale_trans_N=(90/N)∙(Number of transactions in the past N days from merchant)/(Number of transactions in the past 90 days from merchant), For N = 1, 2, 3, 7
	merch_scale_amount_N=(90/N)∙( Total trans amount in the past N days from merchant)/( Total trans amount in the past 90 days from merchant), For N = 1, 2, 3, 7
	card_scale_dup_N=100∙(Number of trans in the past N days on this card with same amount)/(Number of transactions in the past N days on this card), For N = 1, 2, 3, 7
	card_scale_dup_N=100∙(Number of trans in the past N days from merch with same amount)/(Number of transactions in the past N days from merchant), For N = 1, 2, 3, 7
	card_scale_State_N=100∙(Number of trans in the past 1 day on this card with same state)/(Number of transactions in the past 1 day on this card), For N = 1

### Model Algorithm

- Model choosing

After creating the 25 variables as mentioned above, we ran 2 sets of models to see which performs better: Logistic regression, LDA, QDA – Linear and simpler models. They should give us a baseline that all the nonlinear methods should improve over. Random forest, SVM, neural network, CART, boosted tree, KNN – More sophisticated non-linear model. We expected these models to perform slightly better than logistic regression.

- Data standardization

Experience as shown that neural network training is usually more efficient when numeric independent variables are scaled, or normalized, so that their magnitudes are relatively similar. Normalization also help SVM performs better in that all features have roughly the same magnitude (since we don’t assume that some features are much more important than others). For this reason, we scaled the data we fed into the models. Noticed that we didn’t apply data normalization to data to other models such as random forest because random forest is invariant to monotonic transformations of individual features so translations or per feature scaling will not change anything to the performance.

- How to calculate FDA @3%

We calculate fraud detective rate for each model in order to know which one performs better. After we ran each model, we got a probability, which we used as a score, for each record. We sorted the records by probability from high to low and chose top 3%.

**FDR@3%=(label=1 @3%)/(label=1 in Training/Testing/OOD)**

We applied the same method to all the models and came up with the table below: 

d1 ~ d10: down sample the goods from 1/1 goods-to-bads to 10/1 goods-to-bads.
	
Base: original training dataset, without down sample the goods, 25 independent variables
	
v2: dataset from project 2, 16 independent variables

We compared our models based on their FDR@3%, and did separate comparisons for our linear models and non-linear models. We compared them separately because our linear models have relatively low rates on training and testing, but scored very high in validation, but our non-linear models followed the expected pattern, with training and testing roughly the same and validation slightly lower. Due to time limits, we haven’t resolved the issue with our unexpectedly well-performed linear models, and we decided to go with our best performing non-linear model. Based on the comparison we made, KNN won the game.

### KNN Model Result

We used different values for K in our K Nearest Neighbor model and found that K=120 lead to best result. Under KNN model, we have a FDR at 3% for training data of 29.41%, for testing data of 27.79%, and for validation data of 29.01%.

- Model performance statistics

<table>
  <tr>
    <th>KNN</th>
    <th>FDR @3%</th>
  </tr>
  <tr>
    <td>Train</td>
    <td>29.41%</td>
  </tr>
  <tr>
    <td>Test</td>
    <td>29.79%</td>
  </tr>
  <tr>
    <td>Validate</td>
    <td>29.01%</td>
  </tr>
</table>

- Score Distribution on training data (only include top 10%)

<table>
  <tr>
    <th>Percentile</th>
    <th># of Records</th>
    <th># Goods</th>
    <th># bads</th>
    <th>Cumulative Goods</th>
    <th>Cumulative Bads</th>
    <th>% Bad</th>
    <th>% Good</th>
    <th>Cumulative fraud detection rate</th>
    <th>Bin KS</th>
  </tr>
  <tr>
    <td>1.00%</td>
    <td>547</td>
    <td>281</td>
    <td>266</td>
    <td>281</td>
    <td>266</td>
    <td>48.63%</td>
    <td>51.37%</td>
    <td>13.66%</td>
    <td>0.13</td>
  </tr>
  <tr>
    <td>2.00%</td>
    <td>546</td>
    <td>351</td>
    <td>195</td>
    <td>632</td>
    <td>461</td>
    <td>35.71%</td>
    <td>64.29%</td>
    <td>23.67%</td>
    <td>0.22</td>
  </tr>
  <tr>
    <td>3.00%</td>
    <td>546</td>
    <td>434</td>
    <td>112</td>
    <td>1066</td>
    <td>573</td>
    <td>20.51%</td>
    <td>79.49%</td>
    <td>29.41%</td>
    <td>0.27</td>
  </tr>
  <tr>
    <td>4.00%</td>
    <td>546</td>
    <td>456</td>
    <td>90</td>
    <td>1522</td>
    <td>663</td>
    <td>16.48%</td>
    <td>83.52%</td>
    <td>34.03%</td>
    <td>0.31</td>
  </tr>
  <tr>
    <td>5.00%</td>
    <td>546</td>
    <td>442</td>
    <td>104</td>
    <td>1964</td>
    <td>767</td>
    <td>19.05%</td>
    <td>80.95%</td>
    <td>39.37%</td>
    <td>0.36</td>
  </tr>
  <tr>
    <td>6.00%</td>
    <td>546</td>
    <td>469</td>
    <td>77</td>
    <td>2433</td>
    <td>844</td>
    <td>14.10%</td>
    <td>85.90%</td>
    <td>43.33%</td>
    <td>0.39</td>
  </tr>
  <tr>
    <td>7.00%</td>
    <td>546</td>
    <td>466</td>
    <td>80</td>
    <td>2899</td>
    <td>924</td>
    <td>14.65%</td>
    <td>85.35%</td>
    <td>47.43%</td>
    <td>0.42</td>
  </tr>
  <tr>
    <td>8.00%</td>
    <td>547</td>
    <td>479</td>
    <td>68</td>
    <td>3378</td>
    <td>992</td>
    <td>12.43%</td>
    <td>87.57%</td>
    <td>50.92%</td>
    <td>0.45</td>
  </tr>
  <tr>
    <td>9.00%</td>
    <td>546</td>
    <td>495</td>
    <td>51</td>
    <td>3873</td>
    <td>1043</td>
    <td>9.34%</td>
    <td>90.66%</td>
    <td>53.54%</td>
    <td>0.46</td>
  </tr>
  <tr>
    <td>10.00%</td>
    <td>546</td>
    <td>508</td>
    <td>38</td>
    <td>4381</td>
    <td>1081</td>
    <td>6.96%</td>
    <td>93.04%</td>
    <td>55.49%</td>
    <td>0.47</td>
  </tr>
</table>

- Score Distribution on testing data (only include top 10%)

<table>
  <tr>
    <th>Percentile</th>
    <th># of Records</th>
    <th># Goods</th>
    <th># Bads</th>
    <th>Cumulative Goods</th>
    <th>Cumulative Bads</th>
    <th>% Bad</th>
    <th>% Good</th>
    <th>Cumulative Fraud Detection Rate</th>
    <th>Bin KS</th>
  </tr>
  <tr>
    <td>1.00%</td>
    <td>137</td>
    <td>69</td>
    <td>68</td>
    <td>69</td>
    <td>68</td>
    <td>49.64%</td>
    <td>50.36%</td>
    <td>14.47%</td>
    <td>0.14</td>
  </tr>
  <tr>
    <td>2.00%</td>
    <td>136</td>
    <td>100</td>
    <td>36</td>
    <td>169</td>
    <td>104</td>
    <td>26.47%</td>
    <td>73.53%</td>
    <td>22.13%</td>
    <td>0.21</td>
  </tr>
  <tr>
    <td>3.00%</td>
    <td>137</td>
    <td>101</td>
    <td>36</td>
    <td>270</td>
    <td>140</td>
    <td>26.28%</td>
    <td>73.72%</td>
    <td>29.79%</td>
    <td>0.28</td>
  </tr>
  <tr>
    <td>4.00%</td>
    <td>136</td>
    <td>116</td>
    <td>20</td>
    <td>386</td>
    <td>160</td>
    <td>14.71%</td>
    <td>85.29%</td>
    <td>34.04%</td>
    <td>0.31</td>
  </tr>
  <tr>
    <td>5.00%</td>
    <td>137</td>
    <td>116</td>
    <td>21</td>
    <td>502</td>
    <td>181</td>
    <td>15.33%</td>
    <td>84.67%</td>
    <td>38.51%</td>
    <td>0.35</td>
  </tr>
  <tr>
    <td>6.00%</td>
    <td>136</td>
    <td>123</td>
    <td>13</td>
    <td>625</td>
    <td>194</td>
    <td>9.56%</td>
    <td>90.44%</td>
    <td>41.28%</td>
    <td>0.37</td>
  </tr>
  <tr>
    <td>7.00%</td>
    <td>137</td>
    <td>115</td>
    <td>22</td>
    <td>740</td>
    <td>216</td>
    <td>16.06%</td>
    <td>83.94%</td>
    <td>45.96%</td>
    <td>0.40</td>
  </tr>
  <tr>
    <td>8.00%</td>
    <td>136</td>
    <td>121</td>
    <td>15</td>
    <td>861</td>
    <td>231</td>
    <td>11.03%</td>
    <td>88.97%</td>
    <td>49.15%</td>
    <td>0.43</td>
  </tr>
  <tr>
    <td>9.00%</td>
    <td>137</td>
    <td>126</td>
    <td>11</td>
    <td>987</td>
    <td>242</td>
    <td>8.03%</td>
    <td>91.97%</td>
    <td>51.49%</td>
    <td>0.44</td>
  </tr>
  <tr>
    <td>10.00%</td>
    <td>137</td>
    <td>131</td>
    <td>6</td>
    <td>1118</td>
    <td>248</td>
    <td>4.38%</td>
    <td>95.62%</td>
    <td>52.77%</td>
    <td>0.44</td>
  </tr>
</table>

- Score Distribution on validation data (only include top 10%)

<table>
  <tr>
    <th>Percentile</th>
    <th># of Records</th>
    <th># Goods</th>
    <th># Bads</th>
    <th>Cumulative Goods</th>
    <th>Cumulative Bads</th>
    <th>% Bad</th>
    <th>% Good</th>
    <th>Cumulative Fraud Detection Rate</th>
    <th>Bin KS</th>
  </tr>
  <tr>
    <td>1.00%</td>
    <td>270</td>
    <td>64</td>
    <td>206</td>
    <td>64</td>
    <td>206</td>
    <td>76.30%</td>
    <td>23.70%</td>
    <td>13.02%</td>
    <td>0.13</td>
  </tr>
  <tr>
    <td>2.00%</td>
    <td>270</td>
    <td>120</td>
    <td>150</td>
    <td>184</td>
    <td>356</td>
    <td>55.56%</td>
    <td>44.44%</td>
    <td>22.50%</td>
    <td>0.22</td>
  </tr>
  <tr>
    <td>3.00%</td>
    <td>270</td>
    <td>167</td>
    <td>103</td>
    <td>351</td>
    <td>459</td>
    <td>38.15%</td>
    <td>61.85%</td>
    <td>29.01%</td>
    <td>0.28</td>
  </tr>
  <tr>
    <td>4.00%</td>
    <td>270</td>
    <td>221</td>
    <td>49</td>
    <td>572</td>
    <td>508</td>
    <td>18.15%</td>
    <td>81.85%</td>
    <td>32.11%</td>
    <td>0.30</td>
  </tr>
  <tr>
    <td>5.00%</td>
    <td>270</td>
    <td>208</td>
    <td>62</td>
    <td>780</td>
    <td>570</td>
    <td>22.96%</td>
    <td>77.04%</td>
    <td>36.03%</td>
    <td>0.33</td>
  </tr>
  <tr>
    <td>6.00%</td>
    <td>270</td>
    <td>223</td>
    <td>47</td>
    <td>1003</td>
    <td>617</td>
    <td>17.41%</td>
    <td>82.59%</td>
    <td>39.00%</td>
    <td>0.35</td>
  </tr>
  <tr>
    <td>7.00%</td>
    <td>269</td>
    <td>235</td>
    <td>34</td>
    <td>1238</td>
    <td>651</td>
    <td>12.64%</td>
    <td>87.36%</td>
    <td>41.15%</td>
    <td>0.36</td>
  </tr>
  <tr>
    <td>8.00%</td>
    <td>270</td>
    <td>236</td>
    <td>34</td>
    <td>1474</td>
    <td>685</td>
    <td>12.59%</td>
    <td>87.41%</td>
    <td>43.30%</td>
    <td>0.37</td>
  </tr>
  <tr>
    <td>9.00%</td>
    <td>270</td>
    <td>242</td>
    <td>28</td>
    <td>1716</td>
    <td>713</td>
    <td>10.37%</td>
    <td>89.63%</td>
    <td>45.07%</td>
    <td>0.38</td>
  </tr>
  <tr>
    <td>10.00%</td>
    <td>270</td>
    <td>247</td>
    <td>23</td>
    <td>1963</td>
    <td>736</td>
    <td>8.52%</td>
    <td>91.48%</td>
    <td>46.52%</td>
    <td>0.39</td>
  </tr>
</table>

### Results and Summary

Through the process of exploring data, building variables and running models, the supervised learning method gave us a good practice of fraud detection. To better train the model, we used different training data sets with different nonfraud-to-fraud ratios. We also tried different linear and nonlinear models including logistics, LDA, QDA, SVM, random forest, etc. Although the FDR @3% for training, testing and validating datasets vary a lot under different models, our best result comes from KNN method. FDR @3% is just one aspect of testing the effectiveness of the models. To make further improvements, we probably can study further on the records that are labeled fraud, trying to find the hidden pattern behind them and to come up with better variables for model testing.  
