library(glmnet)
library(ISLR)
library(leaps)
Hitters =na.omit(Hitters)
View(Hitters)

#This is a good data set to practice EDA on. There are lots of questionable data points
#as you explore the data.
summary(Hitters)

#Lets make a nicer table
index<-which(sapply(Hitters,is.numeric))
tab.cont<-c()

for (i in index){
  tab.cont<-rbind(tab.cont,summary(Hitters[,i]))
}
rownames(tab.cont)<-names(Hitters)[index]
View(tab.cont)


#Lets do some categorie tables.  There is nothing super informative here but sanity check
#here would be to make sure it is spilt roughly 50/50 as it should
prop.table(table(Hitters$League))
prop.table(table(Hitters$NewLeague))
prop.table(table(Hitters$Division))


#We are interested in trying to predict players salaries. Lets explore any trends
attach(Hitters)
par(mfrow=c(1,3))
plot(Salary~League)
plot(Salary~NewLeague)
plot(Salary~Division)
par(mfrow=c(1,1))
plot(Salary~interaction(League,Division),xlab="By Division and League")

cor.mat<-cor(Hitters[,index])
#These are the correlations of each predictor to salary
sort(cor.mat[17,])
plot(CRBI,Salary)
plot(CRuns,Salary)
plot(CHits,Salary)
plot(CAtBat,Salary)
plot(CHmRun,Salary)
plot(CWalks,Salary)
plot(RBI,Salary)
plot(Walks,Salary)
plot(Hits,Salary)
plot(Runs,Salary)
plot(Years,Salary)
plot(AtBat,Salary)
plot(HmRun,Salary)
plot(PutOuts,Salary)

boxplot(Salary~League)
boxplot(Salary~Division)


#How are the predictors correlated to each other. Anything aggregious we may want to go ahead
#and make a call.
library(gplots)
cor.mat<-cor(Hitters[,index])
#This is a really handy tool for visualizing multicollinearity
heatmap.2(cor.mat,,density.info="none", trace="none",col=redgreen(75),scale="none")

pairs(Hitters[,1:7])
pairs(Hitters[,8:13])
pairs(Hitters[,16:20])

#So far there is nothing really super obvious in terms of strong relationships to salary.
#However lets go ahead and fit a full model (knowing we are probably overfitting, just
#to see how residuals look.

#Lets do a training test set split to see how LASSO does compared to OLS and FWD selection.
#For now lets just work with the predictors we have.
dim(Hitters)
set.seed(1) 
index<-sample(1:nrow(Hitters),nrow(Hitters)/2)
train<-Hitters[index,]
test<-Hitters[-index,]

full.model<-lm(Salary~.,train)
par(mfrow=c(1,1))
plot(full.model)
summary(full.model)

testMSE_full<-mean((test$Salary-predict(full.model,test))^2)
testMSE_full




#Forward Selection
#bringing in the predict function
predict.regsubsets =function (object , newdata ,id ,...){
  form=as.formula (object$call [[2]])
  mat=model.matrix(form ,newdata )
  coefi=coef(object ,id=id)
  xvars=names(coefi)
  mat[,xvars]%*%coefi
}
#

testMSE_fwd<-c()
#Fitting forward selection models on the full set
reg.fwd=regsubsets(Salary~.,data=train,method="forward",nvmax=18)
#note my index is to 10 since that what I set it in regsubsets
for (i in 1:18){
  predictions<-predict.regsubsets(object=reg.fwd,newdata=test,id=i) 
  testMSE_fwd[i]<-mean((test$Salary-predictions)^2)
}
par(mfrow=c(1,1))
plot(1:18,testMSE_fwd,type="l",xlab="# of predictors",ylab="test MSE")
index2<-which(testMSE_fwd==min(testMSE_fwd))
points(index2,testMSE_fwd[index2],col="red",pch=10)

testMSE_fwd[index2]


#LASSO
#LASSO call requires us to format the data set a little 
x=model.matrix(Salary~.,train)[,-1]
y=train$Salary
#Remind them about categorical predictor logistics


xtest<-model.matrix(Salary~.,test)[,-1]
ytest<-test$Salary


cv.out=cv.glmnet(x,y,alpha=1) #alpha=1 performs LASSO
plot(cv.out)
bestlambda<-cv.out$lambda.1se
#Refit full data set
lasso.mod<-glmnet(x,y,lambda=bestlambda)

lasso.pred=predict (lasso.mod ,s=bestlambda ,newx=xtest)

testMSE_LASSO<-mean((ytest-lasso.pred)^2)
testMSE_LASSO


#Compare the test MSE to see what worked out better
#Here LASSO does not do as well.  Its biased estimated are having
#a negative impact.
testMSE_LASSO
testMSE_fwd[index2]
testMSE_full



#What to do next????
#We can consider adding additional model complexity interactions etc, to see if that helps.
#Exploring 3d plots may help
#If the constant variance is a concern, we can go back and log transform salary
#    - Doing this creates nonlinear relations with the x's though so we would have to go transform them
#    - This definitely could be a worthy endevaor that could improve prediction accuracy
plot(full.model)

plot(CRBI,Salary)
plot(CRBI,log(Salary))
plot(CRBI^(1/2),log(Salary))


#Just as a quick example of the full regression model and then adding a sqrt term.
summary(lm(log(Salary)~.,Hitters))
summary(lm(log(Salary)~.+I(CRBI^(1/2)),Hitters))

plot(lm(log(Salary)~.+I(CRBI^(1/2)),Hitters))










