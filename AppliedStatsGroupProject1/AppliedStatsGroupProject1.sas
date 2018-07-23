/* Import the train OO9data */
FILENAME REFFILE 'C:\Users\danie\Documents\GitHub\Statistics\AppliedStatsGroupProject1\Train_v2_Subset_Scrubbed_Random20percent.csv';
PROC IMPORT DATAFILE=REFFILE DBMS=CSV OUT=WORK.TRAIN;
	GETNAMES=YES;
RUN;
PROC CONTENTS DATA=WORK.TRAIN;
RUN;

/* Question of interest*/
/*Do f2 and f5 together affect amount of loss? */
/* Does f2 alone affect the amount of loss? */
/* Does f5 alone affect the amount of loss? */
/* Since qoi is only about AMOUNT loss Remove all observations that have no loss */
proc sort data=train;
by f2;
run;
/* -----------------------------Check for interaction prior to ANOVA----------------------------- */
proc means data=train n mean max min range std missing noprint fw=8;
	class f2 f5;
	var loss;
	output out=meansout mean=mean std=std;
	title 'Summary of loss';
run;
proc print data=meansout;
data summarystats;
	set meansout;
	if _TYPE_^=3  then delete;
run;
proc print data=summarystats;
data plottingdata(keep=f2 f5 std mean meanloss);
	set summarystats;
	by f2 f5;
	meanloss=mean;
	output;
	meanloss=mean - std;
	output;
	meanloss=mean + std;
	output;
run;
proc sort data=plottingdata;
	by f2;
run;
proc print data=plottingdata;
*Mimic Dr. Turner: Plotting options to make graph look somewhat decent;
title1 'Plot Means with Standard Error Bars';
symbol1 interpol=hiloctj color=green line=1;
symbol2 interpol=hiloctj color=red line=1;
symbol3 interpol=hiloctj color=blue line=1;
symbol4 interpol=hiloctj color=purple line=1;
symbol5 interpol=hiloctj color=black line=1;
symbol6 interpol=hiloctj color=orange line=1;
symbol7 interpol=hiloctj color=brown line=1;
symbol8 interpol=hiloctj color=darkkhaki line=1;
symbol9 interpol=hiloctj color=pink line=1;
symbol10 interpol=hiloctj color=brpk line=1;
symbol11 interpol=hiloctj color=depk line=1;
symbol12 interpol=none color=green value=dot height=.1;
symbol13 interpol=none color=red value=dot height=1;
symbol14 interpol=none color=blue value=dot height=1;
symbol15 interpol=none color=purple value=dot height=1;
symbol16 interpol=none color=black value=dot height=1;
symbol17 interpol=none color=orange value=dot height=1;
symbol18 interpol=none color=brown value=dot height=1;
symbol19 interpol=none color=darkkhaki value=dot height=1;
symbol20 interpol=none color=pink value=dot height=1;
symbol21 interpol=none color=brpk value=dot height=1;
symbol22 interpol=none color=depk value=dot height=1;
axis1 offset=(5, 5);
axis2 label=("MeanLoss") order=(-16 to 50 by 1) minor=(n=1);
proc gplot data=plottingdata;
	plot meanloss*f2=f5 / vaxis=axis2 haxis=axis1;
	plot2 Mean*f2=f5  / vaxis=axis2 noaxis nolegend;
	run;
quit;
/* -----------------------------There's clearly interaction; also Zomfg the variances are all over the place----------------------------- */


/* Model Selection */
/* Forward */
proc glmselect data=TRAIN plots=all;
	class f2 f5 f13;
	model loss=f2 f5 f13 /selection=Forward
	cvmethod=random(5) stats=adjrsq;
/* Backward */
proc glmselect data=TRAIN plots=all;
	class f2 f5 f13;
	model loss=f2 f5 f13  /selection=backward 
	cvmethod=random(5) stats=adjrsq;
/* Stepwise */
proc glmselect data=TRAIN plots=all;
	class f2 f5 f13;
	model loss=f2 f5 f13 /selection=stepwise
	cvmethod=random(5) stats=adjrsq;
/* Lasso */
proc glmselect data = TRAIN plots=all;
class f2 f5 f13;
model loss=f2 f5 f13 / selection = lasso CVDETAILS;
run;




/* Model */
symbol interpol=none color=blue value=dot height=1.5;
proc glm data=train PLOTS=(DIAGNOSTICS RESIDUALS)PLOTS(MAXPOINTS=10000);
class f2 f5;
model loss = f2 f5 f2*f5;
lsmeans f2 f5 f2*f5 / pdiff tdiff adjust=bon;
run;
/* Residuals are a disaster so begin transform*/
/* -----------Transform loss using log------------- */
data trainlogloss;
set train;
logloss=log(loss);
run;
proc print data=trainlogloss;

/* Run model again with logloss */
proc glm data=trainlogloss PLOTS=(DIAGNOSTICS RESIDUALS)PLOTS(MAXPOINTS=10000);
class f2 f5;
model logloss = f2 f5 f2*f5;
lsmeans f2 f5 f2*f5 / pdiff tdiff adjust=bon;
run;
/* Residuals looking better but still some patterns and extreme observations */
/* Type 3 is when we adjust variance for both explanatory variables. It's different ni this case because the data is unbalances */
/* Over all f p value 0.0051 so we reject overall null. There indeed is an effect. */
/*  */

proc sgscatter data = trainlogloss;
plot logloss*f2;


/* f2 pval 0.0265 so F2 is significant */
/* f5 pval 0.6487 so f5 is not statistically significant */
/* f2*f5 pval 0.0757 Noy significant */
/* R2  is stoopid low. This is because the error is soo high. If I could start over I would have chosen a different dataset. */
/* this tells me f5 is useless so re-run with only f2 */

/* Run model again with f2 and logloss */
proc glm data=trainlogloss PLOTS=(DIAGNOSTICS RESIDUALS)PLOTS(MAXPOINTS=10000);
class f2;
model logloss = f2;
output out=resids rstudent=rstudent p=yhat;
/* p=yhat makes it use predicted values instead of ... */
run;

/*  */
/* The loss doesn't change based on f5 alone p 0.1218 */
proc glm data=trainlogloss PLOTS=(DIAGNOSTICS RESIDUALS)PLOTS(MAXPOINTS=10000);
class f5;
model logloss = f5;
output out=resids rstudent=rstudent p=yhat;
/* p=yhat makes it use predicted values instead of ... */
run;

/* Contrasts */
/* f2 1	2 3 4 6 7 8 9 10 11 */
/* f5=1 */