%web_drop_table(WORK.BB);


FILENAME REFFILE '/folders/myshortcuts/StatisticalFoundations/Stats Unit 9 Homework/Baseball_Data.csv';

PROC IMPORT DATAFILE=REFFILE
	DBMS=CSV
	OUT=WORK.BB;
	GETNAMES=YES;

proc reg data= BB; 
model wins = payroll /clb; 
run; 


/*28 DF and .975 results in .05 alpha */
data quantile;
	myquant=quantile('t', 0.975, 28);
proc print data=quantile;


data quantile;
	myquant=quantile('t', 0.995, 198);
proc print data=quantile;

proc reg data= WORK.import alpha=.01; 
model math = science /clb; 
run; 



