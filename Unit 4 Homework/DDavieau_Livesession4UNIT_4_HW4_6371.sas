
/* Problem 2a Wilcoxon rank-sum test to examine the differences.*/

/* Generated Code (IMPORT) */
/* Source File: Logging.csv */
/* Source Path: /folders/myfolders/Unit 4 Homework */
/* Code generated on: 2/3/18, 1:13 PM */
%web_drop_table(WORK.IMPORT);
FILENAME REFFILE '/folders/myfolders/Unit 4 Homework/Logging.csv';
PROC IMPORT DATAFILE=REFFILE
	DBMS=CSV
	OUT=WORK.IMPORT;
	GETNAMES=YES;
RUN;
PROC CONTENTS DATA=WORK.IMPORT; RUN;
%web_open_table(WORK.IMPORT);

proc print data = import;

proc npar1way data=scores wilcoxon;
class schtyp;
var write;
run;
/* Now look at differences in math and writing scores by race.  */
proc npar1way data=words wilcoxon;
class race;
var write;
exact Wilcoxon/mc;
run;
