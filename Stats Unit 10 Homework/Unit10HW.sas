data maledata;
input Mass Tcell;
datalines;
3.33 0.252
4.62 0.263
5.43 0.251
5.73 0.251
6.12 0.183
6.29 0.213
6.45 0.332
6.51 0.203
6.65 0.252
6.75 0.342
6.81 0.471
7.56 0.431
7.83 0.312
8.02 0.304
8.06 0.37
8.18 0.381
9.08 0.43
9.15 0.43
9.35 0.213
9.42 0.508
9.95 0.411
4.5  .
3	 .
4	 .
5	 .
6	 .
7	 .
8	 .
9	 .
;

proc SGPLOT data=work.maledata;
scatter y=Tcell x=Mass;
run;


proc reg data=work.maledata alpha=.01;
model Tcell=Mass /R CLB CLI CLM;
run;

proc reg data=work.maledata alpha=.01;
model Tcell=Mass /R;

run;

data quantile;
	myquant=quantile('t', 0.995, 19);
proc print data=quantile;

/* Prediction Mean 4.5 */
proc reg data=work.maledata alpha=.01;
model Tcell=Mass /CLM;
run;

/* Prediction 4.5 */
proc reg data=work.maledata alpha=.01;
model Tcell=Mass /CLI;
run;
