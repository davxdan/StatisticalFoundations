/* Problem 2a Wilcoxon rank-sum test to examine the differences.*/
/* Generated Code (IMPORT) */
/* Source File: Logging.csv */
/* Source Path: /folders/myfolders/Unit 4 Homework */
/* Code generated on: 2/3/18, 1:13 PM */

/* Import the data */
%web_drop_table(WORK.IMPORT);
FILENAME REFFILE '/folders/myfolders/Unit 4 Homework/Logging.csv';
PROC IMPORT DATAFILE=REFFILE
	DBMS=CSV
	OUT=WORK.IMPORT;
	GETNAMES=YES;
RUN;
PROC CONTENTS DATA=WORK.IMPORT; RUN;
%web_open_table(WORK.IMPORT);

/* Sort and examine the data for ties and sample sizes */
proc sort data=import;
by  descending  PercentLost;
proc print data=import;

/* Run the Rank Sum test  */
proc npar1way data=WORK.IMPORT wilcoxon alpha = .05;
	class Action;
	var PercentLost;
	exact HL;
run;


/* Problem 3 */
/* Generated Code (IMPORT) */
/* Source File: EducationData.csv */
/* Source Path: /folders/myfolders/Unit 4 Homework */
/* Code generated on: 2/3/18, 6:25 PM */

%web_drop_table(WORK.IMPORT);
FILENAME REFFILE '/folders/myfolders/Unit 4 Homework/EducationData.csv';
PROC IMPORT DATAFILE=REFFILE
	DBMS=CSV
	OUT=WORK.IMPORT;
	GETNAMES=YES;
RUN;
PROC CONTENTS DATA=WORK.IMPORT; RUN;
%web_open_table(WORK.IMPORT);

/* Examine data */
Proc print data =import;

/* Get critical value */
data critval;
cv = quantile("T", .95, 1424); 
alpha  = .05; 
proc print data = critval;

/* Use ttest to get sample sizes */

proc Sort data=IMPORT;
	by Educ;
proc ttest data=  WORK.IMPORT sides=2;
	class  Educ;
	var   Income2005;
run;