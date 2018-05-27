

##########################################################
#This first section is to serve as a jumping off point to 
#fitting regression models in R as well as to visualize what
#it means when we are building linear models and adding complexity
##

library(ISLR)
library(car)
library(scatterplot3d)
library(rgl)
library(leaps) #forward selection
library(glmnet) #lasso, ridge, elastic net

#Change your working directory so that it is pointed 
#to the location of where your csv files are.
setwd("Z:/STA328/Rlabs")



#This is a simple data set to try to predict sales based on
#different types of advertisment spending.

Adver<-read.csv("Advertising.csv",header=T)
Adver<-Adver[,-1]
attach(Adver)
View(Adver)

#  Exploratory Data Analysis
#This is a handy for quickly making sure the variables
#are the right data type.  Sometimes categorical predictors
#will be read in as continuous and you will need to fix that.
summary(Adver)

#Correlation plots
pairs(Adver[,4:1])
par(mfrow=c(1,3))
plot(newspaper,sales)
plot(radio,sales)
plot(TV,sales)

par(mfrow=c(1,1))
pairs(Adver[,4:1])


#Lets fit an additive model (no interactions) inlucding all 3 
full.fit<-lm(sales~TV+radio+newspaper)
par(mfrow=c(2,2))
#Lets look at residuals
plot(full.fit)
par(mfrow=c(1,1))
hist(full.fit$residuals)
#Here we might be concerned about normality assumptions
#However before quickly making that jump we may want to consider
#adding model complexity.


#Upon visual inspection, there is not much going on for newspaper
#We could leave it in for the time being but for teaching purposes
#I'm going to remove it for the time being.  (Its not important)
reduced.fit<-lm(sales~TV+radio)
plot(reduced.fit)

#summary options provides testing information
#Remember, we do not trust this output until assumptions are met
#It may be helpful thought just to look at an Rsquared value or VIFs
summary(reduced.fit)

#Get VIFs for inspection
vif(reduced.fit)

#With two continous predictors its important to realize that multiple
#regression is just fitting a plane in 3D.  The following graphs
#show you the data in 3d and the regression predictions as a plane.
par(mfrow=c(1,1))
s3d <- scatterplot3d(TV,radio,sales, type="p", highlight.3d=TRUE, pch=16, main="Reduce model fit",angle=35)
s3d$plane3d(reduced.fit,draw_polygon=T)

#Looking at it from another angle
s3d <- scatterplot3d(TV,radio,sales, type="p", highlight.3d=TRUE, pch=16, main="Reduce model fit",angle=-35)
s3d$plane3d(reduced.fit,draw_polygon=T)

#The residual plots from before, along with the graphs we just made,
#we can see that the fit is "off" in certain areas.
#It turns out we can model some of the curvature by including an interaction term.
inter.fit<-lm(sales~TV+radio+TV:radio)
par(mfrow=c(2,2))
plot(inter.fit)
par(mfrow=c(1,1))
hist(inter.fit$residuals)

#Note Adjusted R square improves to .9673 it was .8 something before 
summary(inter.fit)

#For mac users you may need to download Xquartz before the code will
#run.  But this is really handy to compare the predictions with a simple
#model and one with interactions.

plot3d(TV,radio,sales)
surface3d(0:300,0:50,outer(0:300,0:50,function(x,y) {2.9211+.04574*x+.18799*y}),alpha=.4)


plot3d(TV,radio,sales)
surface3d(0:300,0:50,outer(0:300,0:50,function(x,y) {6.75+.019*x+.0288*y+.0011*x*y}),alpha=.4)

#Lets compare AICs
AIC(full.fit)
AIC(reduced.fit)
AIC(inter.fit) #Winner winner, Chicken Dinner




#So for MLR, the modeler has to be clever enough to think about adding
#the interaction term.  With a large number of predictors, adding complexity
#is very time consuming.

#What makes random forests, knn, and other nonparameteric approaches so appealing
#is that with large data sets, the comoplexity can be estimated without making any
#inherent complexity assumptions.

#The following is a knn fit using K=5.  No interaction terms was needed to specify up front.
#Generating a set of data points to predict so we can see the prediction surface
predictors<-data.frame(TV=rep(0:300,51),radio=rep(0:50,each=301))
train<-data.frame(TV=TV,radio=radio)
knn.5<-FNN::knn.reg(train = train, test =predictors, y = sales, k = 5)

pred.surface<-matrix(knn.5$pred,301,51)
plot3d(TV,radio,sales)
surface3d(0:300,0:50,pred.surface,alpha=.4)



#########################################################
#The following code is going to illustrate forward feature selection
#and cross validation

dim(Auto)

summary(Auto)
#Some variables do not have the correct data type so I am fixing it
Auto$cylinders<-as.factor(Auto$cylinders)
Auto$origin<-as.factor(Auto$origin)

#Running forward selection and the algorithm is going to stop after adding six coefficients.
reg.fwd=regsubsets(log(mpg)~cylinders+displacement + horsepower + weight + acceleration+origin,data=Auto,method="forward",nvmax=6)
#summary is not that helpful here
summary(reg.fwd)

#These are the metric fits for each iteration of foward selection
#So the 1st value is for the one predictor model while the last is 
#the 6 predictor model
summary(reg.fwd)$adjr2
summary(reg.fwd)$rss
summary(reg.fwd)$bic

#To get the coefficients from model that is the "best" we can just call
#it with coef.
coef(reg.fwd,1)
coef(reg.fwd,2)
coef(reg.fwd,3)
coef(reg.fwd,4)
coef(reg.fwd,5)
coef(reg.fwd,6)

#The logistical issue here with R is that these are realy handy in 
#building models, but it is a little more cumbersome to refit the data
#set using lm so that t-test and other information is available.
#With categorical predictors you just have to include the whole thing.
#
#For exampe using BIC above, we would only fit a simple model with weight.

final.model<-lm(log(mpg)~weight,data=Auto)
summary(final.model)


#The above forward selection code can be too optimistic since we did not 
#use CV or incorporate a training and test set split.
#The following code is for a simple training/test split.



set.seed(12345)
index<-sample(1:dim(Auto)[1],260,replace=F)
train<-Auto[index,]
test<-Auto[-index,]



reg.fwd=regsubsets(log(mpg)~cylinders+displacement + horsepower + weight + acceleration+origin,data=train,method="forward",nvmax=10)

#Unfortunately the regsubsets function doesnt't work nicely with the predict function in the past.
#Below is a custom function to do just that. There are a lot of moving parts here so lets just use it
#for now.

#Here the object is a regsubset object of your model fit,
#newdata is for the new data you want to predict.
#id is the step in the forward selection procedure, so if id=2, we are looking at a 2 predictor model.
predict.regsubsets =function (object , newdata ,id ,...){
  form=as.formula (object$call [[2]])
  mat=model.matrix(form ,newdata )
  coefi=coef(object ,id=id)
  xvars=names(coefi)
  mat[,xvars]%*%coefi
}

#Calculate test MSE

testMSE<-c()
#note my index is to 10 since that what I set it in regsubsets
for (i in 1:10){
  predictions<-predict.regsubsets(object=reg.fwd,newdata=test,id=i) 
  testMSE[i]<-mean((log(test$mpg)-predictions)^2)
}
par(mfrow=c(1,1))
plot(1:10,testMSE,type="l",xlab="# of predictors",ylab="test MSE")
index<-which(testMSE==min(testMSE))
points(index,testMSE[index],col="red",pch=10)



#Building final model with full data set.  Can use our predict function to predict future
#values.
reg.final=regsubsets(log(mpg)~cylinders+displacement + horsepower + weight + acceleration+origin,data=Auto,method="forward",nvmax=10)
coef(reg.final,3)




#The following is a Kfold cv run using forward selection
#Embedding CV with feature selection takes a little more complexity of looping 
#and book keeping.

k=10  #number of folds

#This will be our matrix of cv test errors. 1 row for each fold, each column reperesents the number of predictors
#included in the model.
cv.errors<-matrix(NA,10,8)


Auto<-Auto[,1:9]

set.seed(12345)
folds<-sample(1:k,nrow(Auto),replace=T)  #Here we are not forcing them to be as balanced as possible

folds<-c(rep(1:k,each=floor(nrow(Auto)/k)),1:(nrow(Auto)-floor(nrow(Auto)/k)*k)) #forcing more balanced
#the function above will have an issue if the folds are perfectly balanced.  See me.

folds<-sample(folds,length(folds),replace=F) #shuffling


for(i in 1:k){
  best.fit=regsubsets(log(mpg)~cylinders+displacement + horsepower + weight + acceleration+origin,data=Auto[folds!=i,],method="forward",nvmax=8)
  for(j in 1:8){
    pred=predict.regsubsets (best.fit ,Auto[folds ==i,],id=j)
    cv.errors[i,j]<-mean( ( log(Auto$mpg[ folds==i])-pred)^2)
  }
}

#Calculating the average prediction error
mean.cv<-apply(cv.errors,2,mean)
#Creating a plot similar to what we see in SAS
plot(1:8,mean.cv,type="l",xlab="# of predictors",ylab="testMSE 10-Fold CV")
index<-which(mean.cv==min(mean.cv))
points(index,mean.cv[index],col="red",pch=10)

test.se<-apply(cv.errors,2,sd)/sqrt(k)
#Creating a 1-sd rule to decide # of predictors
sd1rule<-mean.cv-test.se
index2<-which(sd1rule<min(mean.cv))
points(index2,mean.cv[index2],col="blue",pch=18)

#The 1SD rule is often used so that we don't incude too many predictors
#that offer little increase in prediction performance.
#Here we see that 3 features would be optimal based on the CV run.

#Now we fit the entire data set spefically using 3 features.

reg.final=regsubsets(log(mpg)~cylinders+displacement + horsepower + weight + acceleration+origin,data=Auto,method="forward",nvmax=10)
coef(reg.final,3)










