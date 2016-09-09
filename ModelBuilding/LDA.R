library(dplyr)
library(lubridate)
library(ROCR)
library(MASS)

write.csv(NewData, file = "New_Data.csv")

data = read.csv("New_Data.csv", header = T)

write.csv(data, file = "0428.csv")

str(data)

names(data)[1] = "Record"
names(data)[10] = "label"

data$DATE = mdy(data$DATE)

data.validate = data %>%
  filter(data$DATE>"2010-07-31")

data.all = data %>%
  filter(data$DATE<="2010-07-31")

bound=floor(nrow(data.all)*0.8)             #define % of training and test set


# data=data[sample(nrow(data)), ]         #sample rows 
# data.train=data[1:bound, ]              #get training set
# data.test=data[(bound+1):nrow(data), ]


set.seed(100)

train = sample(1:nrow(data.all), bound)
test = -train

data.train = data.all[train,]
data.test = data.all[test,]

### data upload

data.train = read.csv("downsize_3.csv")
data.test = read.csv("data_test.csv")
data.validate = read.csv("data_validate.csv")

data.train = data.train[,-1]
data.test = data.test[,-1]
data.validate = data.validate[,-1]



### LDA

lda_model = lda(label ~ . - Record, data = data.train)

lda_pred = predict(lda_model, data.test, type="prob")
lda_pred_y = lda_pred$class
lda_prob = lda_pred$posterior
colnames(lda_prob) = c("Prob_0", "Prob_1")
data.test.pred = cbind(data.test, lda_pred_y,lda_prob)

write.csv(data.test.pred, "LDA_base_test_d3.csv")

lda_pred = predict(lda_model, data.train, type="prob")
lda_pred_y = lda_pred$class
lda_prob = lda_pred$posterior
colnames(lda_prob) = c("Prob_0", "Prob_1")
data.train.pred = cbind(data.train, lda_pred_y,lda_prob)

write.csv(data.train.pred, "LDA_base_train_d3.csv")


lda_pred = predict(lda_model, data.validate, type="prob")
lda_pred_y = lda_pred$class
lda_prob = lda_pred$posterior
colnames(lda_prob) = c("Prob_0", "Prob_1")
data.validate.pred = cbind(data.validate, lda_pred_y,lda_prob)

write.csv(data.validate.pred, "LDA_base_validate_d3.csv")







data.test.pred.order = data.test.pred[order(-data.test.pred$Prob_1),]

top3percent = floor(nrow(data.test.pred.order)*0.03)

data.test.pred.top3percent = data.test.pred.order[1:top3percent,]

data.test.pred.top3percent$label = as.numeric(data.test.pred.top3percent$label)
data.test.pred.top3percent$lda_pred_y = as.numeric(data.test.pred.top3percent$lda_pred_y)

sum(data.test.pred.top3percent$label)/sum(data.test.pred.top3percent$lda_pred_y)

### QDA
str(data.train)
data.train = data.train[,-c(2 : 9)]
data.test = data.test[,-c(2:9)]
data.validate = data.validate[,-c(2:9)]




qda_model = qda(label ~ . - Record, data = data.train)

qda_pred = predict(qda_model, data.test, type="prob")
qda_pred_y = qda_pred$class
qda_prob = qda_pred$posterior
colnames(qda_prob) = c("Prob_0", "Prob_1")
data.test.pred = cbind(data.test, qda_pred_y,qda_prob)

write.csv(data.test.pred, file = "QDA_base_test_d3.csv")


qda_pred = predict(qda_model, data.train, type="prob")
qda_pred_y = qda_pred$class
qda_prob = qda_pred$posterior
colnames(qda_prob) = c("Prob_0", "Prob_1")
data.train.pred = cbind(data.train, qda_pred_y,qda_prob)

write.csv(data.train.pred, file = "QDA_base_train_d3.csv")


qda_pred = predict(qda_model, data.validate, type="prob")
qda_pred_y = qda_pred$class
qda_prob = qda_pred$posterior
colnames(qda_prob) = c("Prob_0", "Prob_1")
data.validate.pred = cbind(data.validate, qda_pred_y,qda_prob)

write.csv(data.validate.pred, file = "QDA_base_validate_d3.csv")








data.test.pred.order = data.test.pred[order(-data.test.pred$Prob_1),]

top3percent = floor(nrow(data.test.pred.order)*0.03)

data.test.pred.top3percent = data.test.pred.order[1:top3percent,]

data.test.pred.top3percent$label = as.numeric(data.test.pred.top3percent$label)
data.test.pred.top3percent$qda_pred_y = as.numeric(data.test.pred.top3percent$qda_pred_y)

sum(data.test.pred.top3percent$label)/sum(data.test.pred.top3percent$qda_pred_y)




