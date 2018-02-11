/* Generated Code (IMPORT) */
/* Source File: ex0525.csv */
/* Source Path: /folders/myfolders/Datasets */
/* Code generated on: 2/10/18, 10:02 AM */
%web_drop_table(WORK.Education);
FILENAME REFFILE '/folders/myfolders/Datasets/ex0525.csv';
PROC IMPORT DATAFILE=REFFILE
	DBMS=CSV
	OUT=WORK.Education;
	GETNAMES=YES;
RUN;
PROC CONTENTS DATA=WORK.Education; RUN;
DATA Education(DROP = Subject); 
SET Education;
RUN;
Proc Print data=Education; run;
proc Sort data=Education;
	by Educ;

	/*  */
/* proc univariate data=Education; */
/* 	by Educ; */
/* 	histogram; */
/* 	qqplot Income2005; */
/* run; */
/*  */
/* Boxplot */
/* proc boxplot data=Education; */
/* 	plot Income2005*Educ; */
/* run; */

/* Means */
/* proc means data=Education; */
/* run; */
/* ANOVA using GLM */
Proc GLM data=Education;
class Educ;
model Income2005 = Educ;
means Educ / bon Tukey SNK REGWQ;
run;
/* Log Transform the Education Data */
data lEducation;
set Education;
loggedIncome2005 = log(Income2005);
DATA  WORK.LEDUCATION(DROP =  Income2005); 
SET  WORK.LEDUCATION;
RUN;

proc Sort data=lEducation;
	by Educ;
/*  */
/* proc univariate data=lEducation; */
/* 	by Educ; */
/* 	histogram; */
/* 	qqplot loggedIncome2005; */
/* run; */

/* Boxplot */
proc boxplot data=WORK.LEDUCATION;
	plot loggedIncome2005*Educ;
run;

/* Means */
/* proc means data= WORK.LEDUCATION; */
/* run; */
/* ANOVA using GLM */
Proc GLM data= WORK.LEDUCATION;
class Educ;
model  loggedIncome2005 = Educ;
means Educ;
run;


/* Check my numbers vs books */
%web_drop_table(WORK.IMPORT);
FILENAME REFFILE '/folders/myfolders/Datasets/case0502.csv';
PROC IMPORT DATAFILE=REFFILE
	DBMS=CSV
	OUT=WORK.IMPORT;
	GETNAMES=YES;
RUN;
Proc GLM data= WORK.IMPORT;
class  Judge;
model  Percent =  Judge;
means  Judge ;
run;
/* means Educ / bon Tukey SNK REGWQ; */
/* proc ttest data = Education; */
/* class Educ; */
/* var Income2005; */
/* run; */
/* Below is an excerpt from a SAS help document that shows the types of post hoc tests available in SAS. */
/* MEANS effects / options ;    */
/* The following MEANS statement options are used to select a multiple comparison procedure:  */
/* BON DUNCAN DUNNETT DUNNETTL DUNNETTU GABRIEL GT2 LSD REGWF REGWQ SCHEFFE SIDAK SMM SNK T TUKEY WALLER. */
/* The following MEANS statement options specify details for the multiple comparison procedure: ALPHA= p CLDIFF CLM  */
/* To perform post-hoc analyses in SAS, you need to add a “means” statement after the model statement (see code below). */
/* Proc GLM data=smile; */
/* class smile; */
/* model rating = smile; */
/* means smile / bon Tukey SNK REGWQ; */
/* run; */
/*  */
/*  */
/* D.	Comparisons to a control */
/* The Dunnett’s test is used for comparisons of each group to a control group. The syntax is a little different, since the control group must be specified. Is there evidence that the mean rating for the control group is statistically significantly from the mean ratings of other groups? */
/* Proc GLM data=smile; */
/* class smile; */
/* model rating = smile; */
/* means smile / dunnett(‘CONTROL’); /* You have to supply the control group! */
/* run; */
/*  */
/* Analysis of Random Effects */
/* An experiment was conducted to compare four different fermentation processes: F1, F2, F3, and F4.  An organic raw material is common to each process and can be made in batches that are adequate for four runs.  This raw material exhibits substantial variation batch-to-batch.  A block design was used with the following results (the response in a measure of fermentation efficiency and in measured in percent): */
/*  */
/* Data Ferment; */
/*   input Batch Process $ Response @@; */
/*   title1 'Mason, Gunst, & Hess: Exercise 10.17'; */
/* Datalines; */
/* 1  F1  84 2  F1  79 3  F1  76 4  F1  82 5  F1  74 */
/* 1  F2  83 2  F2  72 3  F2  82 4  F2  97 5  F2  76 */
/* 1  F3  92 2  F3  87 3  F3  82 4  F3  84 5  F3  75 */
/* 1  F4  89 2  F4  74 3  F4  80 4  F4  79 5  F4  83 */
/* ; */
/* run; */
/* Proc Print data=Ferment; */
/* run; */
/* ods rtf; */
/* Proc GLM data=Ferment; */
/* * Illustrate that GLM Standard Errors are Incorrect; */
/*   class batch process; */
/*   model response = batch process; */
/*   random batch / test; */
/*   lsmeans process / stderr pdiff; */
/* run; */
/* Proc Mixed data=Ferment CL Covtest; */
/* * Mixed has Correct Standard Errors; */
/*   class batch process; */
/*   model response = process; */
/*   random batch ; */
/*   lsmeans process / adjust=tukey pdiff; */
/* run; */
/* ods rtf close; */
/*  */
/*  */
/* Option Groups for Common Analyses */
/* This section summarizes the syntax for the common analyses supported in the ONEWAYANOVA statement.  */
/* One-Degree-of-Freedom Contrast */
/* You can use the NPERGROUP== option in a balanced design, as in the following statements. Default values for the SIDES=, NULLCONTRAST=, and ALPHA= options specify a two-sided test for a contrast value of 0 with a significance level of 0.05.  */
/* proc power; */
/*        onewayanova test=contrast */
/*           contrast = (1 0 -1) */
/*           groupmeans = 3 | 7 | 8 */
/*           stddev = 4 */
/*           npergroup = 50 */
/*           power = .; */
/*     run;  */
/* You can also specify an unbalanced design with the NTOTAL= and GROUPWEIGHTS= options:  */
/*    proc power; */
/*        onewayanova test=contrast */
/*           contrast = (1 0 -1) */
/*           groupmeans = 3 | 7 | 8 */
/*           stddev = 4 */
/*           groupweights = (1 2 2) */
/*           ntotal = .  */
/*          power = 0.9; */
/*     run;  */
/* Another way to specify the sample sizes is with the GROUPNS= option:  */
/*    proc power; */
/*        onewayanova test=contrast */
/*           contrast = (1 0 -1) */
/*           groupmeans = 3 | 7 | 8 */
/*           stddev = 4 */
/*           groupns = (20 40 40) */
/*           power = .; */
/*     run;  */
/*  */
/* Overall F Test */
/* The following statements demonstrate a power computation for the overall F test in a one-way ANOVA. The default of ALPHA=0.05 specifies a significance level of 0.05.  */
/*    proc power; */
/*        onewayanova test=overall */
/*           groupmeans = 3 | 7 | 8 */
/*           stddev = 4 */
/*           npergroup = 50 */
/*           power = .; */
/*     run;  */
/*      */
/* Get the Critical Value */
/* data critval; */
/* cv = quantile("T", .05, 49);  */
/* alpha  = .05; */
/* proc print data = critval; */
/* run; */