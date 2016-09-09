library(dplyr)

data = read.csv("data_train.csv", header = T)
data$label=as.factor(data$label)
summary(data$label)

fraud=data[data$label==1,]

sample1=sample_n(data[data$label==0,],size=1948)
sample3=sample_n(data[data$label==0,],size=1948*3)
sample5=sample_n(data[data$label==0,],size=1948*5)
sample7=sample_n(data[data$label==0,],size=1948*7)
sample10=sample_n(data[data$label==0,],size=1948*10)

down1=rbind(sample1,fraud) %>% arrange(Record)
down3=rbind(sample3,fraud) %>% arrange(Record)
down5=rbind(sample5,fraud) %>% arrange(Record)
down7=rbind(sample7,fraud) %>% arrange(Record)
down10=rbind(sample10,fraud) %>% arrange(Record)

write.csv(down1,"down1.csv")
write.csv(down3,"down3.csv")
write.csv(down5,"down5.csv")
write.csv(down7,"down7.csv")
write.csv(down10,"down10.csv")

data=read.csv("data.csv")
data=data[,1:10]
library(lubridate)
data$DATE=mdy(data$DATE)
data$month=month(data$DATE)
data2=data %>%
  group_by(month)%>%
  summarise(fraud=sum(Fraud.label))
data2$month=as.factor(data2$month)
library(ggplot2)
ggplot(data2,aes(x=month,y=fraud))+
  geom_bar(stat="identity")