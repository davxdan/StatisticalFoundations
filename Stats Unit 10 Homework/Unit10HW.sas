%web_drop_table(WORK.MaleData);
FILENAME REFFILE '/folders/myshortcuts/StatisticalFoundations/Stats Unit 10 Homework/Male Display Data Set.csv';
PROC IMPORT DATAFILE=REFFILE
	DBMS=CSV
	OUT=WORK.MaleData;
	GETNAMES=YES;

proc SGPLOT data=work.maledata;
scatter y=Tcell x=Mass;
run;

proc reg data=work.maledata alpha=.01;
model Tcell=Mass /R CLB CLI ;
run;
