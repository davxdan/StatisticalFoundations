setwd("~/Desktop/MSDS_NEW/PreLive/Unit3")

ACT<-read.csv("MathACT.csv")


#Plotting data via ggplot2
library(ggplot2)
attach(ACT)
mysummary<-function(x){
  result<-c(length(x),mean(x),sd(x),sd(x)/length(x))
  names(result)<-c("N","Mean","SD","SE")
  return(result)
}
sumstats<-aggregate(Score~Background*Sex,data=ACT,mysummary)
sumstats<-cbind(sumstats[,1:2],sumstats[,-(1:2)])

ggplot(sumstats,aes(x=Background,y=Mean,group=Sex,colour=Sex))+
  ylab("ACT Score")+
  geom_line()+
  geom_point()+
  geom_errorbar(aes(ymin=Mean-SE,ymax=Mean+SE),width=.1)


#Note how using the standard errors emphasises what we will see statistically
#If we summarize the error bars using variability estimates we will get something
#slighlty different.  It highlights the importance of making sure your graphics full communicate
#what is being presented.
#Plottings SDs can allow you to assess constant variance.  SE's cannot.
ggplot(sumstats,aes(x=Background,y=Mean,group=Sex,colour=Sex))+
  ylab("ACT Score")+
  geom_line()+
  geom_point()+
  geom_errorbar(aes(ymin=Mean-SD,ymax=Mean+SD),width=.1)


#Running ANOVA model with interaction term
#Note the options command is to ensure we get our type III
#sums of squares correct.  There is some technical detail there 
#but as long as you do it before running the model you are okay.
options(contrasts=c("contr.sum","contr.poly"))
mymodel<-aov(Score~Background+Sex+Background:Sex,data=ACT)


#Lets look at residuals first as no testing really matters yet.
par(mfrow=c(2,2))
plot(mymodel)

#These are pretty ugly we can do something about that with ggplot2
attributes(mymodel)
myfits<-data.frame(fitted.values=mymodel$fitted.values,residuals=mymodel$residuals)

#Residual vs Fitted
plot1<-ggplot(myfits,aes(x=fitted.values,y=residuals))+ylab("Residuals")+
  xlab("Predicted")+geom_point()
plot1  

#QQ plot of residuals  #Note the diagonal abline is only good for qqplots of normal data.
plot2<-ggplot(myfits,aes(sample=residuals))+
  stat_qq()+geom_abline(intercept=mean(myfits$residuals), slope = sd(myfits$residuals))
plot2
#Histogram of residuals
plot3<-ggplot(myfits, aes(x=residuals)) + 
  geom_histogram(aes(y=..density..),binwidth=1,color="black", fill="gray")+
  geom_density(alpha=.1, fill="red")
plot3

library(gridExtra)
grid.arrange(plot1, plot2,plot3, ncol=3)

#Note for you guys who want to make a residuals versus leverage plot
#for regression purposes, you just need to add an additional column
#to the myfits data frame using  hatvalues(mymodel) to obtain the leverage values.
#I'll let you figure it out in ggplot2
par(mfrow=c(1,1))
myfits$leverage<-hatvalues(mymodel)
plot(myfits$leverage,myfits$residuals)



#Now lets dive into the statistics
#The type III sums of squares
library(car)
Anova(mymodel,type=3)
#If you wnat the type I for some reason you can get that using
#the standard anova call.  You can verify that the only fstatistic
#that corresponds between the two tables is the last one.
anova(mymodel)
#Again don't use this second one unless you have a reason to.



#Contrasts and comparison plots are a little more challenging programatically in R
#although it gives you more flexibility once you have it sorted out.
#I will attempt to break it down from simple to more challenging.

#In this example there is no sig. interaction so we may want to just 
#compare each factor seperately with multilpe test corrections.
#If we have no specific comparisons then we just want to look at everything.
#Note if there are a lot of comparisons, the results can be quite conservative.
TukeyHSD(mymodel,"Background",conf.level=.95)
plot(TukeyHSD(mymodel,"Background",conf.level=.95))


TukeyHSD(mymodel,"Sex",conf.level=.95)
plot(TukeyHSD(mymodel,"Sex",conf.level=.95))

#Keep in mind using these tools you are at the mercy of the level names.
#a,b,c are easy to read, but if they are long the graphics will get messy.
#You could store the tukey results in a dataframe and then use ggplot2 to pretty 
#it up.


#There are other approaches to get at comparisons within a single factor
#but the above tool is handy for two way anova scenarios and the interaction
#is not sifnificant.

#We can easily do it for an interaction as well.  Again tests can be more
#conservative as the number of tests increase.

TukeyHSD(mymodel,"Background:Sex",conf.level=.95)
plot(TukeyHSD(mymodel,"Background:Sex",conf.level=.95))




#If you have an interaction effect and you have many comparisons that
#you do not wish to investigate. It may be helpful to look at specific comparisons.
#

#Suppose we wanted to conduct test between males vs females at each background level.
#The following script is something that I developed in an R package called qusage
#back in 2013.  Rather than dealing with the ones and zeros, you can just specify
#the comparison you want based on the factor level names. It works for interactions
#or basic one way factors when interactions are not of interest.
#This approach will also work with lmer lme4 objects for repeated measures.

library(lsmeans) #maybe need eemeans package
contrast.factor<-~Background*Sex
mycontrast<-c("amale-afemale","bmale-bfemale","cmale-cfemale")
dat<-ACT
#lsmeans(mymodel)

#Running a loop that determines the appropriate 0's and 1's for each 
#contrast specified above.
final.result<-c()



for( j in 1:length(mycontrast)){
contrast.factor.names<-gsub(" ", "", unlist(strsplit(as.character(contrast.factor),split = "*", fixed = T))[-1])
contrast.factor.2 <- vector("list", length(contrast.factor.names))
for (i in 1:length(contrast.factor.names)) {
  contrast.factor.2[[i]] <- levels(dat[, contrast.factor.names[i]])
}
new.factor.levels <- do.call(paste, c(do.call(expand.grid, 
                                              contrast.factor.2), sep = ""))
temp.cont<-mycontrast[j]
contrast2 <- list(comparison = as.vector(do.call(makeContrasts, 
                                                list(contrasts = temp.cont, levels = new.factor.levels))))

contrast.result <- summary(contrast(lsmeans(mymodel, 
                                            contrast.factor), contrast2, by = NULL))

final.result<-rbind(final.result,contrast.result)
}
#Cleaning up and applying bonferroni correction to the number
#of total comparisons investigated.
final.result$contrast<-mycontrast
final.result$bonf<-length(mycontrast)*final.result$p.value
final.result$bonf[final.result$bonf>1]<-1

final.result
View(final.result)




##############################################################
#If you wanted to just compare background with this approach.
#Note you will see warning because you are comparing factor levels
#now that assume no interaction is present, but your model has an
#interaction term.  Removing the interaction, or making sure that 
#there is no interaction between the two factors is critical before 
#blindly looking at a one factor comparisons in a vaccum.

contrast.factor<-~Background
mycontrast<-c("b-a","c-a","c-b")
dat<-ACT
#lsmeans(mymodel)

#Running a loop that determines the appropriate 0's and 1's for each 
#contrast specified above.
final.result<-c()



for( j in 1:length(mycontrast)){
  contrast.factor.names<-gsub(" ", "", unlist(strsplit(as.character(contrast.factor),split = "*", fixed = T))[-1])
  contrast.factor.2 <- vector("list", length(contrast.factor.names))
  for (i in 1:length(contrast.factor.names)) {
    contrast.factor.2[[i]] <- levels(dat[, contrast.factor.names[i]])
  }
  new.factor.levels <- do.call(paste, c(do.call(expand.grid, 
                                                contrast.factor.2), sep = ""))
  temp.cont<-mycontrast[j]
  contrast2 <- list(comparison = as.vector(do.call(makeContrasts, 
                                                   list(contrasts = temp.cont, levels = new.factor.levels))))
  
  contrast.result <- summary(contrast(lsmeans(mymodel, 
                                              contrast.factor), contrast2, by = NULL))
  
  final.result<-rbind(final.result,contrast.result)
}
#Cleaning up and applying bonferroni correction to the number
#of total comparisons investigated.
final.result$contrast<-mycontrast
final.result$bonf<-length(mycontrast)*final.result$p.value
final.result$bonf[final.result$bonf>1]<-1

final.result
View(final.result)

