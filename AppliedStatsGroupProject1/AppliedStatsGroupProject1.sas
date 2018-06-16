/* Import the train OO9data */
FILENAME REFFILE 'C:\Users\danie\Documents\GitHub\Statistics\AppliedStatsGroupProject1\Train_v2_Subset_Scrubbed_Random20percent.csv';
PROC IMPORT DATAFILE=REFFILE DBMS=CSV OUT=WORK.TRAIN;
	GETNAMES=YES;
RUN;
PROC CONTENTS DATA=WORK.TRAIN;
RUN;

/* Question of interest is does f2 and or f5 indicate amount of loss? */
/* Since qoi is only about AMOUNT loss Remove all observations that have no loss */
data train(keep=f2 f5 loss);
	set train;
if loss = 0 then delete;
run;
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
	*Since the first plot is actually 2 (male female) the corresponding symbol1 and symbol2 options are used which is telling sas to make error bars.  The option is hiloctj;
	plot2 Mean*f2=f5  / vaxis=axis2 noaxis nolegend;
	*This plot uses the final 2 symbols options to plot the mean points;
	run;
quit;
/* -----------------------------There's clearly interaction; also Zomfg the variances are all over the place----------------------------- */

/* Model */
symbol interpol=none color=blue value=dot height=1.5;
proc glm data=train plots=residuals;
class f2 f5;
model loss = f2*f5;
output out=resids rstudent=rstudent p=yhat;
/* p=yhat makes it use predicted values instead of ... */
run;
proc gplot data=resids;
plot rstudent*yhat;
run;
/* Residuals are a disaster so begin transform*/
/* -----------Transform loss using log------------- */
data trainlogloss;
set train;
logloss=log(loss);
run;
proc print data=trainlogloss;

/* Run model again with logloss */
symbol interpol=none color=blue value=dot height=1.5;
proc glm data=trainlogloss plots=residuals;
class f2 f5;
model logloss = f2*f5;
output out=resids rstudent=rstudent p=yhat;
/* p=yhat makes it use predicted values instead of ... */
run;
proc gplot data=resids;
plot rstudent*yhat;
run;
/* Residuals looking better but still some patterns */
/* R2  is stoopid low. This is because the error is soo high. If I could start over I would have chosen a different dataset. */


/* Randomized Complete Block Design Model with logloss */

/* Contrasts */
/* f2=1	f2=2	f2=3	f2=4	f2=6	f2=7	f2=8	f2=9	f2=10	f2=11	f5=1	f5=2	f5=3	f5=4	f5=7	f5=10	f5=13	f5=15	f5=16	f5=17 */












/* 	2 Way ANOVA */
/* proc glm data=math PLOTS=(DIAGNOSTICS RESIDUALS); */
/* 	class sex background; */
/* 	model score=background sex background*sex; */
/* 	lsmeans background / pdiff tdiff adjust=bon; */
/* 	estimate 'B vs A' background -1 1 0; */
/* 	estimate 'What do you think?' background -1 0 1; */
/* 	estimate 'What do you think2?' sex -1 1; */
/* 	run; */

/*      Correct Skew*/
/*	data TRAIN; */
/*	set WORK.TRAIN; */
/*	logSalePrice = log(SalePrice);*/
/*	run;*/
/*f2, f5, f13 and f778 are categorical,*/
/*f4 probably categorical, only 61 distinct values*/
/* Variable Selection Models */
/* Looking for Large R^2 and small CV Press */

/* Forward */
/* proc glmselect data=TRAIN plots=all; */
/* 	class f2 f5 f13 f778; */
/* 	model loss=f1 f3 f4 f6 f7 f8 f9 f10 /selection=Forward (stop=CV)  */
/* 		cvmethod=random(5) stats=adjrsq; */
/* Backward */
/* proc glmselect data=TRAIN plots=all; */
/* 	class f2 f5 f13 f778; */
/* 	model loss=f1 f3 f4 f6 f7 f8 f9 f10 /selection=backward (stop=CV)  */
/* 		cvmethod=random(5) stats=adjrsq; */
/* Stepwise */
/* proc glmselect data=TRAIN plots=all; */
/* 	class f2 f5 f13 f778; */
/* 	model loss=f1 f3 f4 f6 f7 f8 f9 f10 /selection=stepwise (stop=CV)  */
/* 		cvmethod=random(5) stats=adjrsq; */



			/* -----------------------------Sugi29 SAa Coder's Corner-----------------------------*/
			/* http://www2.sas.com/proceedings/sugi29/045-29.pdf ABSTRACT: PROC MEANS analyzes datasets */
			/* according to the variables listed in its Class statement. Its computed */
			/* _TYPE_ variable can be used to determine which class variables were used for the analysis variable calculation. It */
			/* can be very difficult to determine by inspection of the _TYPE_ variable which class variables were used in a */
			/* calculation of any given row. The %TypeFormat macro takes the CLASS variable list and creates a format that */
			/* associates the values of the _TYPE_ variable with a string listing the variables used in the calculation separated by */
			/* the '*' character. */
			/* A group of rows with identical _TYPE_ values indicates that the same variables were used in calculating the analysis */
			/* variables, and each row with this _TYPE_ value represents a different combination of the level of the variables. */
			/* Rows with different _TYPE_ variables indicate that different combinations of variables were used.  */
			/* A solution to this problem is to use the %TypeFormat macro (code included), which associates the _TYPE_ variable value to a */
			/* string that lists the classification variables used in a particular calculation. */
			%macro TypeFormat(formatname=typefmt,var=x1 x2 x3 x4);
			/* Count the number of variables, put into var_count */
			%local var_count; %let var_count = 1;
			%do %until (%scan(&var,&var_count) eq); %let var_count = %eval(&var_count+1); %end;
			%let var_count = %eval(&var_count-1);
			/* Assign each variable name to an indexed macro &&var_val&i */
			%local i; %let i = %eval(&var_count);
			%do %until (&i <= 0);
			 %local var_val&i;
			%let var_val&i = %scan(&var,&i); %let i = %eval(&i-1);
			 %end;
			/* Create temp dataset to use as format */
			data _tmp;
			keep label start fmtname type;
			retain fmtname "&formatname" type 'n';
			length label $ 256 sep $ 1;
			sep = '*'; * Separator character;
			/* Loop through the type combinations */
			type_iter = 2**(&var_count) - 1; * Loop through the types;
			var_iter = &var_count; * Loop over the binary digits;
			do start = 0 to type_iter; * Type iteration loop;
			i_tmp = start; label = '';
			do j = var_iter to 1 by (-1); * Binary digit loop;
			 bin_digit = int(i_tmp/(2**(j-1)));
			if bin_digit = 1 then do;
			 * Get appropriate variable name;
			x = symget('var_val'||left(trim(put(&var_count - j + 1,3.))));
			* Add the separator to the string;
			 x = left(trim(x))||sep;
			* Append selected variable name to label string;
			 newlabel = trim(label)||x;
			 * Reassign label as newlabel;
			 label = newlabel;
			* Decrement i_tmp if bin_digit is in types binary representation;
			 i_tmp = i_tmp - 2**(j-1);
			 end;
			 end;
			label = left(label); * justify label test to left;
			 len = length(label);
			* Take off separator that was appended to end;
			 label = substr(label,1,len-1);
			 output;
			 end;
			 stop;
			 run;
			* create the format from _tmp dataset;
			proc format cntlin=_tmp; run;
			* Delete _tmp dataset to clean up work library;
			proc datasets; delete _tmp; quit; run;
			%mend TypeFormat;