library(dplyr) 
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

#------------------------Neural Network-down1-----------------------------------------------------

nnet.fit = nnet(label~.-Record, data=down1,size=20,maxit=10000,decay=.001) 
nnet.preds = predict(nnet.fit,newdata=test,type="raw") 
nnet.pred = prediction(nnet.preds,test$label) 
a=data.frame(nnet.preds,nnet.pred@labels)
colnames(a)=c("prob","label")
b1=a %>% arrange(desc(prob)) %>% head(round(nrow(a)*0.03))
nrow(b1[b1$label==1,])/nrow(test[test$label==1,])
write.csv(a,"down1_predict.csv")

nnet.preds = predict(nnet.fit,newdata=validate,type="raw") 
nnet.pred = prediction(nnet.preds,validate$label) 
c=data.frame(nnet.preds,nnet.pred@labels)
colnames(a)=c("prob","label")
d1=a %>% arrange(desc(prob)) %>% head(round(nrow(c)*0.03))
nrow(d1[d1$label==1,])/nrow(validate[validate$label==1,])
write.csv(c,"down1_validate.csv")

#------------------------Neural Network-down3-----------------------------------------------------

nnet.fit = nnet(label~.-Record, data=down3,size=20,maxit=10000,decay=.001) 
nnet.preds = predict(nnet.fit,newdata=test,type="raw") 
nnet.pred = prediction(nnet.preds,test$label) 
a=data.frame(nnet.preds,nnet.pred@labels)
colnames(a)=c("prob","label")
b3=a %>% arrange(desc(prob)) %>% head(round(nrow(a)*0.03))
nrow(b3[b3$label==1,])/nrow(test[test$label==1,])
write.csv(a,"down3_predict.csv")

nnet.preds = predict(nnet.fit,newdata=validate,type="raw") 
nnet.pred = prediction(nnet.preds,validate$label) 
c=data.frame(nnet.preds,nnet.pred@labels)
colnames(a)=c("prob","label")
d3=a %>% arrange(desc(prob)) %>% head(round(nrow(c)*0.03))
nrow(d3[d3$label==1,])/nrow(validate[validate$label==1,])
write.csv(c,"down3_validate.csv")

#------------------------Neural Network-down7-----------------------------------------------------

nnet.fit = nnet(label~.-Record, data=down7,size=20,maxit=10000,decay=.001) 
nnet.preds = predict(nnet.fit,newdata=test,type="raw") 
nnet.pred = prediction(nnet.preds,test$label) 
a=data.frame(nnet.preds,nnet.pred@labels)
colnames(a)=c("prob","label")
b7=a %>% arrange(desc(prob)) %>% head(round(nrow(a)*0.03))
nrow(b7[b7$label==1,])/nrow(test[test$label==1,])
write.csv(a,"down7_predict.csv")

nnet.preds = predict(nnet.fit,newdata=validate,type="raw") 
nnet.pred = prediction(nnet.preds,validate$label) 
c=data.frame(nnet.preds,nnet.pred@labels)
colnames(a)=c("prob","label")
d7=a %>% arrange(desc(prob)) %>% head(round(nrow(c)*0.03))
nrow(d7[d7$label==1,])/nrow(validate[validate$label==1,])
write.csv(c,"down7_validate.csv")

#------------------------Neural Network-train-----------------------------------------------------

nnet.fit = nnet(label~.-Record, data=train,size=20,maxit=10000,decay=.001) 
nnet.preds = predict(nnet.fit,newdata=test,type="raw") 
nnet.pred = prediction(nnet.preds,test$label) 
a=data.frame(nnet.preds,nnet.pred@labels)
colnames(a)=c("prob","label")
b=a %>% arrange(desc(prob)) %>% head(round(nrow(a)*0.03))
nrow(b[b$label==1,])/nrow(test[test$label==1,])
write.csv(a,"train_predict.csv")

nnet.preds = predict(nnet.fit,newdata=validate,type="raw") 
nnet.pred = prediction(nnet.preds,validate$label) 
c=data.frame(nnet.preds,nnet.pred@labels)
colnames(a)=c("prob","label")
d=a %>% arrange(desc(prob)) %>% head(round(nrow(c)*0.03))
nrow(d[d$label==1,])/nrow(validate[validate$label==1,])
write.csv(c,"train_validate.csv")