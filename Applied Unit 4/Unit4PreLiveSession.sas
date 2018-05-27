/* data Melanoma;*/
/* infile 'C:\Users\e80100\Desktop\Melanomatimeseries.csv' dlm=',' firstobs=2;*/
/* input Year Melanoma Sunspot;*/
/* run;*/

%web_drop_table(WORK.Melanoma);
FILENAME REFFILE '/folders/myshortcuts/Statistics/Applied Unit 4/Melanomatimeseries.csv';
PROC IMPORT DATAFILE=REFFILE
	DBMS=CSV
	OUT=WORK.Melanoma;
	GETNAMES=YES;
RUN;
PROC CONTENTS DATA=WORK.Melanoma; RUN;
%web_open_table(WORK.Melanoma);
proc print data=work.melanoma;


/* proc autoreg data=Melanoma all plots(unpack); */
/* model Melanoma=year; */
/* run; */
/* quit; */
/*  */
/* model Melanoma=Year  / nlag=1; */
/* run; */
/* quit; */

/* proc reg data = work.melanoma; */
/* model Melanoma= /dw; */

proc SGPLOT data=work.melanoma;
scatter y=melanoma x=year;
run;

proc reg data=work.melanoma;
model melanoma= /R;
run;