library(dplyr)
library(gbm)
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

#------------------------Boosted Tree-down1-----------------------------------------------------

bt.fit=gbm(label~.-Record,data=down1, distribution = "bernoulli", n.trees = 5000, interaction.depth = 4, shrinkage = 0.01) 
bt.preds = predict(bt.fit,newdata=test,n.trees = 5000,type="response")
a=data.frame(bt.preds,test$label)
colnames(a)=c("prob","label")
b1=a %>% arrange(desc(prob)) %>% head(round(nrow(a)*0.03))
nrow(b1[b1$label==1,])/nrow(test[test$label==1,])
write.csv(a,"down1_predict.csv")

bt.preds = predict(bt.fit,newdata=validate,n.trees = 5000,type="response")
c=data.frame(bt.preds,validate$label)
colnames(c)=c("prob","label")
d1=c %>% arrange(desc(prob)) %>% head(round(nrow(c)*0.03))
nrow(d1[d1$label==1,])/nrow(validate[validate$label==1,])
write.csv(c,"down1_validate.csv")

#------------------------Boosted Tree-down3-----------------------------------------------------

bt.fit=gbm(label~.-Record,data=down3, distribution = "bernoulli", n.trees = 5000, interaction.depth = 4, shrinkage = 0.01) 
bt.preds = predict(bt.fit,newdata=test,n.trees = 5000,type="response")
a=data.frame(bt.preds,test$label)
colnames(a)=c("prob","label")
b3=a %>% arrange(desc(prob)) %>% head(round(nrow(a)*0.03))
nrow(b3[b3$label==1,])/nrow(test[test$label==1,])
write.csv(a,"down3_predict.csv")

bt.preds = predict(bt.fit,newdata=validate,n.trees = 5000,type="response")
c=data.frame(bt.preds,validate$label)
colnames(c)=c("prob","label")
d3=c %>% arrange(desc(prob)) %>% head(round(nrow(c)*0.03))
nrow(d3[d3$label==1,])/nrow(validate[validate$label==1,])
write.csv(c,"down3_validate.csv")

#------------------------Boosted Tree-down5-----------------------------------------------------

bt.fit=gbm(label~.-Record,data=down5, distribution = "bernoulli", n.trees = 5000, interaction.depth = 4, shrinkage = 0.01) 
bt.preds = predict(bt.fit,newdata=test,n.trees = 5000,type="response")
a=data.frame(bt.preds,test$label)
colnames(a)=c("prob","label")
b5=a %>% arrange(desc(prob)) %>% head(round(nrow(a)*0.03))
nrow(b5[b5$label==1,])/nrow(test[test$label==1,])
write.csv(a,"down5_predict.csv")

bt.preds = predict(bt.fit,newdata=validate,n.trees = 5000,type="response")
c=data.frame(bt.preds,validate$label)
colnames(c)=c("prob","label")
d5=c %>% arrange(desc(prob)) %>% head(round(nrow(c)*0.03))
nrow(d5[d5$label==1,])/nrow(validate[validate$label==1,])
write.csv(c,"down5_validate.csv")

#------------------------Boosted Tree-down7-----------------------------------------------------

bt.fit=gbm(label~.-Record,data=down7, distribution = "bernoulli", n.trees = 5000, interaction.depth = 4, shrinkage = 0.01) 
bt.preds = predict(bt.fit,newdata=test,n.trees = 5000,type="response")
a=data.frame(bt.preds,test$label)
colnames(a)=c("prob","label")
b7=a %>% arrange(desc(prob)) %>% head(round(nrow(a)*0.03))
nrow(b7[b7$label==1,])/nrow(test[test$label==1,])
write.csv(a,"down7_predict.csv")

bt.preds = predict(bt.fit,newdata=validate,n.trees = 5000,type="response")
c=data.frame(bt.preds,validate$label)
colnames(c)=c("prob","label")
d7=c %>% arrange(desc(prob)) %>% head(round(nrow(c)*0.03))
nrow(d7[d7$label==1,])/nrow(validate[validate$label==1,])
write.csv(c,"down7_validate.csv")

#------------------------Boosted Tree-down10-----------------------------------------------------

bt.fit=gbm(label~.-Record,data=down10, distribution = "bernoulli", n.trees = 5000, interaction.depth = 4, shrinkage = 0.01) 
bt.preds = predict(bt.fit,newdata=test,n.trees = 5000,type="response")
a=data.frame(bt.preds,test$label)
colnames(a)=c("prob","label")
b10=a %>% arrange(desc(prob)) %>% head(round(nrow(a)*0.03))
nrow(b10[b10$label==1,])/nrow(test[test$label==1,])
write.csv(a,"down10_predict.csv")

bt.preds = predict(bt.fit,newdata=validate,n.trees = 5000,type="response")
c=data.frame(bt.preds,validate$label)
colnames(c)=c("prob","label")
d10=c %>% arrange(desc(prob)) %>% head(round(nrow(c)*0.03))
nrow(d10[d10$label==1,])/nrow(validate[validate$label==1,])
write.csv(c,"down10_validate.csv")

#------------------------Boosted Tree-train-----------------------------------------------------

bt.fit=gbm(label~.-Record,data=train, distribution = "bernoulli", n.trees = 5000, interaction.depth = 4, shrinkage = 0.01) 
bt.preds = predict(bt.fit,newdata=test,n.trees = 5000,type="response")
a=data.frame(bt.preds,test$label)
colnames(a)=c("prob","label")
b=a %>% arrange(desc(prob)) %>% head(round(nrow(a)*0.03))
nrow(b[b$label==1,])/nrow(test[test$label==1,])
#write.csv(a,"train_predict.csv")

bt.preds = predict(bt.fit,newdata=validate,n.trees = 5000,type="response")
c=data.frame(bt.preds,validate$label)
colnames(c)=c("prob","label")
d=c %>% arrange(desc(prob)) %>% head(round(nrow(c)*0.03))
nrow(d[d$label==1,])/nrow(validate[validate$label==1,])
#write.csv(c,"train_validate.csv")