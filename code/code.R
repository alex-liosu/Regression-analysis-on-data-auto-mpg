
# read data
#rm(list = ls())
getwd()

data=read.csv2("./auto-mpg.txt",header=FALSE,sep="")
data[1:6]=as.numeric(unlist(data[1:6]))
data=data[-9]

colnames(data)=c("mpg","cylinders","displacement","horsepower","weight","acceleration","model_year","origin")

#clean data

data=na.omit(data)

data=data[-which(data$cylinders==3),]

data=data[-which(data$cylinders==5),]
data$cylinders=as.factor(data$cylinders)
data$model_year=as.factor(data$model_year)
data$origin=as.factor(data$origin)

#original model
library(ggplot2)

model=aov(mpg~.,data=data)

library(broom)

df <- augment(model)
ggplot(df, aes(x = .fitted, y = .std.resid)) + geom_point()+
  labs(x="fitted value",y="standized residuals",title="Original Model")

ggsave("pic1.pdf")


#model with log transformation
model2=aov(log(mpg)~.,data=data)
df1 <- augment(model2)
ggplot(df1, aes(x =.fitted, y =.std.resid)) + geom_point()+
  labs(x="fitted value",y="standized residuals",title="Updated Model")

ggsave("pic2.pdf")

#AIC/BIC
n=length(data$mpg)
lm.both.AIC = step(model2,k=2,direction="both",test="F")
lm.both.BIC = step(model2,k=log(n),direction="both",test="F")

#model of AIC output
library(gridExtra)
model_aic=aov(log(mpg) ~ cylinders + displacement + horsepower + weight + model_year + origin,data=data)

qplot(sample =.stdresid, data = model_aic, stat = "qq") + geom_abline()+
  labs(x="theoretical",y="sample",title="Q-Q plot")

summary(model_aic)

#model of BIC output
model_bic=aov(log(mpg) ~ cylinders + horsepower + weight + model_year + origin,data=data)

qplot(sample =.stdresid, data = model_bic, stat = "qq") + geom_abline()+
  labs(x="theoretical",y="sample")

ggsave("pic3.pdf")
summary(model_bic)
model_bic$coefficients

#residual values of model with BIC
df2 <- augment(model_bic)
ggplot(df2, aes(x =.fitted, y =.std.resid)) + geom_point()+
  labs(x="fitted value",y="standized residuals")

ggsave("pic4.pdf")


#fitted v.s. true

ggplot(data,aes(exp(as.numeric(model_bic$fitted.values)),data$mpg))+
  geom_point()+
  labs(x="fitted value",y="true value")
ggsave("pic5.pdf")

#mpg=data
mpg=data

#correlation matrix
cor(mpg)

#calculate VIF (variance inflation factor)
library(car)
model_basic = lm(formula=mpg~cylinders+displacement+horsepower+weight+acceleration+model_year+origin,data = mpg)
car::vif(model_basic)

#PCA
X = mpg[,2:5]
X$cylinders = as.integer(X$cylinders)
X$displacement = as.numeric(X$displacement)
X$horsepower = as.numeric(X$horsepower)
X$weight = as.numeric(X$weight)
X_pc = prcomp(X, scale=TRUE)

summary(X_pc)

#PCA biplot
biplot(X_pc, scale=0)


# PC1 vs. 4 variables with collinearity
par(mfrow=c(2,2))
plot(mpg$cylinders,mpg$PC1, xlab="Cylinders", ylab="PC1")
plot(mpg$displacement,mpg$PC1,xlab="Displacement", ylab="PC1" )
plot(mpg$horsepower,mpg$PC1,xlab="Horsepower", ylab="PC1")
plot(mpg$weight,mpg$PC1,xlab="Weight", ylab="PC1")


#new model with PC1
mpg$PC1 = X_pc$x[,1]
mpg$PC2 = X_pc$x[,2]
mpg$logmpg = log(mpg$mpg)
aovmodel8 = aov(formula=logmpg~PC1+model_year+origin,data=mpg)
summary(aovmodel8)
aovmodel8$coefficients


auto<-data
data2<-as.matrix(auto[,c(-1,-9)])
data2[,7]<-as.factor(data2[,7])
data2[,6]<-as.factor(data2[,6])
# Using cross validation glmnet
ridge_cv <- cv.glmnet(data2, auto[,1], alpha = 0)
# Best lambda value
best_lambda <- ridge_cv$lambda.min
best_lambda
best_ridge <- glmnet(data2, auto[,1], alpha = 0, lambda = best_lambda)
#R^2
SSTO<-(nrow(auto)-1)*var(auto$mpg)
SSE<-(nrow(auto)-1)*var(auto$mpg-as.numeric(as.matrix(auto[,c(-1,-9)])%*%best_ridge$beta)-best_ridge$a0)
(SSTO-SSE)/(SSTO)






