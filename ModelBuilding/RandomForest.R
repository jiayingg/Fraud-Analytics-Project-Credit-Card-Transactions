library(randomForest) 
library(dplyr)
library(ROCR) 
library(nnet) 
library(rpart) 

# Split data------------------------------------------------------------------------------------

#bound=floor(nrow(data)*0.8)             #define % of training and test set
#data=data[sample(nrow(data)), ]         #sample rows 
#data.train=data[1:bound, ]              #get training set
#data.test=data[(bound+1):nrow(data), ]

# Read data-------------------------------------------------------------------------------------

train=read.csv("data_train.csv")
test=read.csv("data_test.csv")
validate=read.csv("data_validate.csv")

# down1=read.csv("downsize_1.csv")
# down3=read.csv("downsize_3.csv")
# down5=read.csv("downsize_5.csv")
# down7=read.csv("downsize_7.csv")
# down10=read.csv("downsize_10.csv")

down1=read.csv("down1.csv")
down3=read.csv("down3.csv")
down5=read.csv("down5.csv")
down7=read.csv("down7.csv")
down10=read.csv("down10.csv")

# Summary----------------------------------------------------------------------------------------

train$label=as.factor(train$label)
test$label=as.factor(test$label)
validate$label=as.factor(validate$label)
down1$label=as.factor(down1$label)
down3$label=as.factor(down3$label)
down5$label=as.factor(down5$label)
down7$label=as.factor(down7$label)
down10$label=as.factor(down10$label)

summary(train$label)
summary(test$label)
summary(down1$label)
summary(down3$label)
summary(down5$label)
summary(down7$label)
summary(down10$label)

#------------------------Random Forest-down1-0.293617-0.2098609-------------------------------------------------

rf.fit=randomForest(label~.,data=down1[,-1], mtry=5, ntree=1000, importance=TRUE) 
table(rf.fit$predicted)
table(down1$label)

rf.preds = predict(rf.fit,type="prob",newdata=test)[,2] 
rf.pred = prediction(rf.preds, test$label) 
a=data.frame(rf.preds,rf.pred@labels)
colnames(a)=c("prob","label")
b1=a %>% arrange(desc(prob)) %>% head(round(nrow(a)*0.03))
nrow(b1[b1$label==1,])/nrow(test[test$label==1,])
write.csv(a,"down1_predict.csv")

rf.valids = predict(rf.fit,type="prob",newdata=validate)[,2] 
rf.valid = prediction(rf.valids, validate$label) 
c=data.frame(rf.valids,rf.valid@labels)
colnames(c)=c("prob","label")
d1=c %>% arrange(desc(prob)) %>% head(round(nrow(c)*0.03))
nrow(d1[d1$label==1,])/nrow(validate[validate$label==1,])
write.csv(c,"down1_validate.csv")

#------------------------Random Forest-down3-0.3404255-0.221871-------------------------------------------------

rf.fit=randomForest(label~.,data=down3[,-1], mtry=5, ntree=1000, importance=TRUE) 
table(rf.fit$predicted)
table(down3$label)

rf.preds = predict(rf.fit,type="prob",newdata=test)[,2] 
rf.pred = prediction(rf.preds, test$label)
a=data.frame(rf.preds,rf.pred@labels)
colnames(a)=c("prob","label")
b3=a %>% arrange(desc(prob)) %>% head(round(nrow(a)*0.03))
nrow(b3[b3$label==1,])/nrow(test[test$label==1,])
write.csv(a,"down3_predict.csv")

rf.valids = predict(rf.fit,type="prob",newdata=validate)[,2] 
rf.valid = prediction(rf.valids, validate$label) 
c=data.frame(rf.valids,rf.valid@labels)
colnames(c)=c("prob","label")
d3=c %>% arrange(desc(prob)) %>% head(round(nrow(c)*0.03))
nrow(d3[d3$label==1,])/nrow(validate[validate$label==1,])
write.csv(c,"down3_validate.csv")

#------------------------Random Forest-down5-0.3553191-0.2439949-----------------------------------------------

rf.fit=randomForest(label~.,data=down5[,-1], mtry=5, ntree=1000, importance=TRUE) 
table(rf.fit$predicted)
table(down5$label)

rf.preds = predict(rf.fit,type="prob",newdata=test)[,2] 
rf.pred = prediction(rf.preds, test$label)
a=data.frame(rf.preds,rf.pred@labels)
colnames(a)=c("prob","label")
b5=a %>% arrange(desc(prob)) %>% head(round(nrow(a)*0.03))
nrow(b5[b5$label==1,])/nrow(test[test$label==1,])
write.csv(a,"down5_predict.csv")

rf.valids = predict(rf.fit,type="prob",newdata=validate)[,2] 
rf.valid = prediction(rf.valids, validate$label) 
c=data.frame(rf.valids,rf.valid@labels)
colnames(c)=c("prob","label")
d5=c %>% arrange(desc(prob)) %>% head(round(nrow(c)*0.03))
nrow(d5[d5$label==1,])/nrow(validate[validate$label==1,])
write.csv(c,"down5_validate.csv")

#------------------------Random Forest-down7-0.3425532-0.2635904------------------------------------------------

rf.fit=randomForest(label~.,data=down7[,-1], mtry=5, ntree=1000, importance=TRUE) 
table(rf.fit$predicted)
table(down7$label)

rf.preds = predict(rf.fit,type="prob",newdata=test)[,2] 
rf.pred = prediction(rf.preds, test$label)
a=data.frame(rf.preds,rf.pred@labels)
colnames(a)=c("prob","label")
b7=a %>% arrange(desc(prob)) %>% head(round(nrow(a)*0.03))
nrow(b7[b7$label==1,])/nrow(test[test$label==1,])
#write.csv(a,"down7_predict.csv")
b7_10=a %>% arrange(desc(prob)) %>% head(round(nrow(a)*0.1))
nrow(b7_10[b7_10$label==1,])/nrow(test[test$label==1,])
b7_20=a %>% arrange(desc(prob)) %>% head(round(nrow(a)*0.2))
nrow(b7_20[b7_20$label==1,])/nrow(test[test$label==1,])

rf.valids = predict(rf.fit,type="prob",newdata=validate)[,2] 
rf.valid = prediction(rf.valids, validate$label) 
c=data.frame(rf.valids,rf.valid@labels)
colnames(c)=c("prob","label")
d7=c %>% arrange(desc(prob)) %>% head(round(nrow(c)*0.03))
nrow(d7[d7$label==1,])/nrow(validate[validate$label==1,])
#write.csv(c,"down7_validate.csv")
d7_10=c %>% arrange(desc(prob)) %>% head(round(nrow(c)*0.1))
nrow(d7_10[d7_10$label==1,])/nrow(validate[validate$label==1,])
d7_20=c %>% arrange(desc(prob)) %>% head(round(nrow(c)*0.2))
nrow(d7_20[d7_20$label==1,])/nrow(validate[validate$label==1,])

#------------------------Random Forest-down10-0.3702128-0.2566372-----------------------------------------------

rf.fit=randomForest(label~.,data=down10[,-1], mtry=5, ntree=1000, importance=TRUE) 
table(rf.fit$predicted)
table(down10$label)

rf.preds = predict(rf.fit,type="prob",newdata=test)[,2] 
rf.pred = prediction(rf.preds, test$label)
a=data.frame(rf.preds,rf.pred@labels)
colnames(a)=c("prob","label")
b10=a %>% arrange(desc(prob)) %>% head(round(nrow(a)*0.03))
nrow(b10[b10$label==1,])/nrow(test[test$label==1,])
write.csv(a,"down10_predict.csv")

rf.valids = predict(rf.fit,type="prob",newdata=validate)[,2] 
rf.valid = prediction(rf.valids, validate$label) 
c=data.frame(rf.valids,rf.valid@labels)
colnames(c)=c("prob","label")
d10=c %>% arrange(desc(prob)) %>% head(round(nrow(c)*0.03))
nrow(d10[d10$label==1,])/nrow(validate[validate$label==1,])
write.csv(c,"down10_validate.csv")

#------------------------Random Forest-train-0.3425532----------------------------------------------------

rf.fit=randomForest(label~.,data=train[,-1], mtry=5, ntree=1000, importance=TRUE) 
table(rf.fit$predicted)
table(train$label)

rf.preds = predict(rf.fit,type="prob",newdata=test)[,2] 
rf.pred = prediction(rf.preds, test$label)
a=data.frame(rf.preds,rf.pred@labels)
colnames(a)=c("prob","label")
b=a %>% arrange(desc(prob)) %>% head(round(nrow(a)*0.03))
nrow(b[b$label==1,])/nrow(test[test$label==1,])
write.csv(a,"train_predict.csv")

rf.valids = predict(rf.fit,type="prob",newdata=validate)[,2] 
rf.valid = prediction(rf.valids, validate$label) 
c=data.frame(rf.valids,rf.valid@labels)
colnames(c)=c("prob","label")
d=c %>% arrange(desc(prob)) %>% head(round(nrow(c)*0.03))
nrow(d[d$label==1,])/nrow(validate[validate$label==1,])
write.csv(c,"train_validate.csv")
