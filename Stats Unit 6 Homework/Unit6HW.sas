/* Problem 1 Bonferroni */
	/* Generated Code (IMPORT) */
	/* Source File: Unit 6 Handicap Data.csv */
	/* Source Path: /folders/myfolders/Stats Unit 6 Homework */
	/* Code generated on: 2/17/18, 10:13 AM */
	%web_drop_table(WORK.HandicapData);
	FILENAME REFFILE 
		'/folders/myfolders/Stats Unit 6 Homework/Unit 6 Handicap Data.csv';
	PROC IMPORT DATAFILE=REFFILE DBMS=CSV OUT=WORK.HandicapData;
		GETNAMES=YES;
	PROC print DATA=WORK.HandicapData;

/* 	Bonferroni Test	(Full) */
/* 		proc glm data = work.handicapdata; */
/* 		class  Handicap; */
/* 		model  Score =  Handicap; */
/* 		means Handicap / HOVTEST=bf bon cldiff; */
		
/* 		Get Means: Results are same as book	 */
/* 		proc glm data = work.handicapdata; */
/* 		class  Handicap; */
/* 		model  Score =  Handicap; */
/* 		means Handicap; */

		proc glm data= work.handicapdata ORDER = DATA;
		class  Handicap;
		model  Score =  Handicap;
		means Handicap/ HOVTEST=bf bon cldiff;
		CONTRAST 'Amputee - Crutches' Handicap 0 1 -1 0 0 ;
		CONTRAST 'Amputee - Wheelchair' Handicap 0 1 0 0 -1;
		CONTRAST 'Crutches - Wheelchair' Handicap 0 0 1 0 -1;
		
/* Problem 2 Verify Halfwidth */
/* LSD */
proc glm data= work.handicapdata ORDER = DATA;
		class  Handicap;
		model  Score =  Handicap;
		means Handicap/ HOVTEST=bf LSD cldiff; /*Slightly different code and output from the last slide: cl vs cldiff*/
/* Dunnet */
proc glm data= work.handicapdata ORDER = DATA;
		class  Handicap;
		model  Score =  Handicap;
		means Handicap/ HOVTEST=bf DUNNETT('None') cldiff; 
/* Tukey (When the group sizes are different, this is the Tukey-Kramer test.) See the CLDIFF and LINES options */
proc glm data= work.handicapdata ORDER = DATA;
		class  Handicap;
		model  Score =  Handicap;
		means Handicap/ HOVTEST=bf TUKEY cldiff;
/* Bonferronni */
proc glm data= work.handicapdata ORDER = DATA;
		class  Handicap;
		model  Score =  Handicap;
		means Handicap/ HOVTEST=bf bon cldiff;

/* SCHEFFE */
proc glm data= work.handicapdata ORDER = DATA;
		class  Handicap;
		model  Score =  Handicap;
		means Handicap/ HOVTEST=bf SCHEFFE cldiff;

/* Problem 3 */
/* proc glm data= work.handicapdata ORDER = DATA; */
/* 		class  Handicap; */
/* 		model  Score =  Handicap; */
/* 		means Handicap/  HOVTEST=bf; */
/* 		lsmeans Handicap/ pdiff adjust= BON cl; */