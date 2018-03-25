/* import the data */
%web_drop_table(WORK.M);
FILENAME REFFILE '/folders/myshortcuts/StatisticalFoundations/Stats Unit 11 Homework/Metabolism Data Prob 26.csv';
PROC IMPORT DATAFILE=REFFILE
	DBMS=CSV
	OUT=WORK.M;
	GETNAMES=YES;
PROC CONTENTS DATA=WORK.M; RUN;

/* raise mass to power .75 */
data md;
set m;
mass34 = mass**.75;


proc reg data=work.md alpha=.05 plots=all;
model metab = mass34 /cli;

/* transform log(y) */
data mdmetabl;
set md;
metabl = log(metab);
proc reg data=work.mdmetabl alpha=.05 plots=all;
model metabl = mass34 /cli;

/* transform both y amd x (log) */
data mdmetablmass34l;
set md;
metabl = log(metab);
mass34l = log(mass34);
proc reg data=work.mdmetablmass34l alpha=.05 plots=all;
model metabl = mass34l /cli;

/* Generated Code (IMPORT) */
/* Source File: Autism Data Prob 29.csv */
/* Source Path: /folders/myshortcuts/StatisticalFoundations/Stats Unit 11 Homework */
/* Code generated on: 3/25/18, 10:17 AM */

%web_drop_table(WORK.A);
FILENAME REFFILE '/folders/myshortcuts/StatisticalFoundations/Stats Unit 11 Homework/Autism Data Prob 29.csv';
PROC IMPORT DATAFILE=REFFILE
	DBMS=CSV
	OUT=WORK.A;
	GETNAMES=YES;
	
data work.a;
set a;
sqrtYear = sqrt(Year);
sqrtPrevalence = sqrt(Prevalence);
logYear = log(Year);
logPrevalence = log(Prevalence);
log2Year = log2(Year);
log2Prevalence = log2(Prevalence);
log10Year = log10(Year);
log10Prevalence = log10(Prevalence);

proc reg data=work.a alpha=.05 plots=all;
model Year = logPrevalence /cli;












