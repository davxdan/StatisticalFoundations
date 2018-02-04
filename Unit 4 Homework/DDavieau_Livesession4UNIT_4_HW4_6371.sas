/* Problem 2a Wilcoxon rank-sum test to examine the differences.*/

/* Import the data (system generated) */
%web_drop_table(WORK.IMPORT);
FILENAME REFFILE '/folders/myfolders/Unit 4 Homework/Logging.csv';
PROC IMPORT DATAFILE=REFFILE DBMS=CSV OUT=WORK.IMPORT;
	GETNAMES=YES;
RUN;
PROC CONTENTS DATA=WORK.IMPORT;
RUN;
%web_open_table(WORK.IMPORT);

/* Sort and examine the data for ties and sample sizes */
proc sort data=import;
	by descending PercentLost;
proc print data=import;

/* Run the Rank Sum test  */
proc npar1way data=WORK.IMPORT wilcoxon alpha=.05;
	class Action;
	var PercentLost;
	exact HL;
run;


/* Problem 3 */
/* Import the data (system generated) */
%web_drop_table(WORK.IMPORT);
FILENAME REFFILE '/folders/myfolders/Unit 4 Homework/EducationData.csv';
PROC IMPORT DATAFILE=REFFILE DBMS=CSV OUT=WORK.IMPORT;
	GETNAMES=YES;
RUN;
PROC CONTENTS DATA=WORK.IMPORT;
RUN;
%web_open_table(WORK.IMPORT);

/* Examine data */
Proc print data=import;

/* Get critical value */
data critval;
	cv=quantile("T", .95, 8);
	alpha=.05;
proc print data=critval;

/* Use ttest to get sample sizes */
proc Sort data=IMPORT;
	by Educ;
proc ttest data=WORK.IMPORT sides=2;
	class Educ;
	var Income2005;
run;

/* Problem 4b  */
data Patients;
	Input MetabolicExpenditure TraumaStatus$ ;
	datalines;
18.8 Nontraumapatients
20 Nontraumapatients
20.1 Nontraumapatients
20.9 Nontraumapatients
20.9 Nontraumapatients
21.4 Nontraumapatients
22 Traumapatients
22.7 Nontraumapatients
22.9 Nontraumapatients
23 Traumapatients
24.5 Traumapatients
25.8 Traumapatients
30 Traumapatients
37.6 Traumapatients
38.5 Traumapatients
;

	
/* Examine the Data */
proc Sort data=Patients;
	by TraumaStatus;

proc print data=patients;

proc univariate data = Patients;
by TraumaStatus;
histogram;
qqplot MetabolicExpenditure;
run;

/* Get the Critical Value */
data critval;
cv = quantile("T", .05, 28); 
alpha  = .05;
proc print data = critval;
run;

/* proc ttest data=patients; */
/* 	class TraumaStatus; */
/* 	var MetabolicExpenditure; */

/* Run the Rank Sum test  */
proc Sort data=Patients;
	by MetabolicExpenditure;
proc npar1way data=Patients wilcoxon alpha=.05;
	class TraumaStatus;
	var MetabolicExpenditure;
	exact HL;
run;

/* Problem 5b */
data Children;
input Child Before After;
datalines;
1 85 75
2 70 50
3 40 50
4 65 40
5 80 20
6 75 65
7 55 40
8 20 25
9 70 30
;
proc print data = children;
run;

/* A new column "diff" = "site1"-"site2" needs to be created first, and then proc univariate is run with the following commends. */

data Children2;
set Children;
diff= Before-After;
run;

proc print data=children2;

proc univariate data=Children2;
var diff;
histogram;
qqplot diff;
run;

/* Paired Ttest */
data Children;
         input Before After @@;
         datalines;
85 75   70 50   40 50   65 40
80 20   75 65   55 40   20 25
70 30
;         
   ods graphics on;
   proc ttest;
      paired Before*After;
   run;
   ods graphics off;

