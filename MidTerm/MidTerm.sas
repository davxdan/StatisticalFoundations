%web_drop_table(WORK.C);
FILENAME REFFILE '/folders/myfolders/MidTerm/Curling.csv';
PROC IMPORT DATAFILE=REFFILE
	DBMS=CSV
	OUT=WORK.C;
	GETNAMES=YES;
%web_open_table(WORK.C);
PROC PRINT data=C;

/* Pure ANOVA */
proc glm data=work.c;
	class Tournament;
	model score=Tournament;
	means Tournament ;
	lsmeans Tournament/ pdiff adjust = bon cl;
	
/* Assumptions	 */
proc sort data=work.c; /*Be carefule this may affect other tests!!*/
	by Tournament; 
proc univariate data=WORK.c;
	by Tournament;
	histogram score;
	qqplot score;

/* Dunnets */
	proc glm data= work.c ORDER = DATA;
			class  Tournament;
			model  Score =  Tournament;
			means Tournament/ HOVTEST=bf DUNNETT('WinterOlympics') cldiff; 



log (1)