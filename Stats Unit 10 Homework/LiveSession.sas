%web_drop_table(WORK.MALE);
FILENAME REFFILE '/folders/myfolders/Stats Unit 10 Homework/Male Display Data Set.csv';

PROC IMPORT DATAFILE=REFFILE
	DBMS=CSV
	OUT=WORK.MALE;
	GETNAMES=YES;
	
	data salesdata;
input Month Sales;
datalines;
1 2.678969
1 6.452194
1 1.837394
1 6.108601
1 5.369281
2 1.766862
2 6.898837
2 1.579677
2 3.726494
2 8.953184
3 8.680436
3 9.931636
3 6.691443
3 11.39723
3 14.93447
;
run;

proc print data = salesdata;
run;

proc glm data = salesdata;
model sales = month / clparm;
run;
***OR***;
proc reg data= movie;
model gross = budget / clb;
run;

proc reg data= movie;
model gross = budget / cli;
run;