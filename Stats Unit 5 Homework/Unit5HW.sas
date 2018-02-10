/* Generated Code (IMPORT) */
/* Source File: ex0525.csv */
/* Source Path: /folders/myfolders/Datasets */
/* Code generated on: 2/10/18, 10:02 AM */
%web_drop_table(WORK.IMPORT);
FILENAME REFFILE '/folders/myfolders/Datasets/ex0525.csv';
PROC IMPORT DATAFILE=REFFILE
	DBMS=CSV
	OUT=WORK.IMPORT;
	GETNAMES=YES;
RUN;
PROC CONTENTS DATA=WORK.IMPORT; RUN;
%web_open_table(WORK.IMPORT);

/* proc univariate data = SamoaEmployees; */
/* by EmploymentStatus; */
/* histogram; */
/* qqplot Age; */
/* run; */
/*  */
/* Get the Critical Value */
/* data critval; */
/* cv = quantile("T", .05, 49);  */
/* alpha  = .05; */
/* proc print data = critval; */
/* run; */
/*  */
/* Boxplot */
/* proc boxplot data=SamoaEmployees; */
/* plot Age*EmploymentStatus; */
/* run; */
/*  */




/* SAS Code for ANOVA Exercise */
/*  */
/* Code to enter the data */
/* filename smile 'C:\correct\pathname\leniency.csv'; */
/* data smile; */
/* infile smile firstobs = 2, dlm = ‘,’; */
/* input smile rating; */
/* if smile = 1 then type = “False”; */
/* if smile = 2 then type = “Genuine”; */
/* if smile = 3 then type = “Miserable”; */
/* if smile = 4 then type = “Neutral”; */
/*  */
/* run; */
/* Proc Print data=smile; run; */
/* Always print the data to check that it has been */
/* entered correctly! */
/* Proc GLM data=smile; */
/* class smile; */
/* model rating = smile; */
/* run; */

/* Option Groups for Common Analyses */
/* This section summarizes the syntax for the common analyses supported in the ONEWAYANOVA statement.  */
/* One-Degree-of-Freedom Contrast */
/* You can use the NPERGROUP== option in a balanced design, as in the following statements. Default values for the SIDES=, NULLCONTRAST=, and ALPHA= options specify a two-sided test for a contrast value of 0 with a significance level of 0.05.  */
proc power;
       onewayanova test=contrast
          contrast = (1 0 -1)
          groupmeans = 3 | 7 | 8
          stddev = 4
          npergroup = 50
          power = .;
    run; 
/* You can also specify an unbalanced design with the NTOTAL= and GROUPWEIGHTS= options:  */
   proc power;
       onewayanova test=contrast
          contrast = (1 0 -1)
          groupmeans = 3 | 7 | 8
          stddev = 4
          groupweights = (1 2 2)
          ntotal = . 
         power = 0.9;
    run; 
/* Another way to specify the sample sizes is with the GROUPNS= option:  */
   proc power;
       onewayanova test=contrast
          contrast = (1 0 -1)
          groupmeans = 3 | 7 | 8
          stddev = 4
          groupns = (20 40 40)
          power = .;
    run; 
/*  */
/* Overall F Test */
/* The following statements demonstrate a power computation for the overall F test in a one-way ANOVA. The default of ALPHA=0.05 specifies a significance level of 0.05.  */
   proc power;
       onewayanova test=overall
          groupmeans = 3 | 7 | 8
          stddev = 4
          npergroup = 50
          power = .;
    run; 