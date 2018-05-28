%web_drop_table(WORK.Melanoma);
FILENAME REFFILE 'C:\Users\danie\Documents\GitHub\Statistics\Applied Unit 4\Melanomatimeseries.csv';
PROC IMPORT DATAFILE=REFFILE
	DBMS=CSV
	OUT=WORK.Melanoma;
	GETNAMES=YES;
RUN;
PROC CONTENTS DATA=WORK.Melanoma; RUN;
%web_open_table(WORK.Melanoma);
proc print data=work.melanoma;
/*Provided Code*/
/*proc autoreg data=Melanoma all plots(unpack);*/
/* model Melanoma=year;*/
/*run;quit;*/
/*proc autoreg data=Melanoma all plots(unpack);*/
/*model Melanoma=Year  / nlag=1;*/
/*run;quit;*/

/*My Code*/
/*Plot Melanoma vs year*/
/*proc SGPLOT data=work.melanoma; */
/*scatter y=melanoma x=year; */
/*run;*/

/*Plot Sunspots versus Year*/
/*proc SGPLOT data=work.melanoma; */
/*scatter y=Sunspot x=year; */
/*run;*/

/*fit a simple regression model to Sunspot with just an intercept */
/*proc autoreg data=Melanoma all plots(unpack);*/
/*model Sunspot=year;*/
/*run;quit;*/

/* Fit an AR(1), AR(2), AR(3), and AR(4) model by specifying the nlag option to 1,2,3, or 4.*/
proc autoreg data=Melanoma all plots(unpack);
model Sunspot=Year  / nlag= (1 2 3 4);
run;quit;
proc autoreg data=Melanoma all plots(unpack);
model Sunspot=Year  / nlag=2;
run;quit;
proc autoreg data=Melanoma all plots(unpack);
model Sunspot=Year  / nlag=3;
run;quit;
proc autoreg data=Melanoma all plots(unpack);
model Sunspot=Year  / nlag=4;
run;quit;
/*proc timeseries data=work.melanoma*/
/*plots=(series corr);*/
/*var melanoma;*/
/*run;*/
/*proc reg data = work.melanoma;*/
/*model Melanoma= /dw;*/
/*ods output dwstatistic = auto_corr*/
/*	(where=(label1="1st Order Autocorrelation"));*/
/*	run;*/
/*	quit;*/
/*	title 'Durbin-Watson Statistic';*/
