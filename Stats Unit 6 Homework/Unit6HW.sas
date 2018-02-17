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

	/* Bonferroni Test	(Full) */
		proc glm data = work.handicapdata;
		class  Handicap;
		model  Score =  Handicap;
		means Handicap / HOVTEST=bf bon cldiff;
		
		proc glm data = work.handicapdata;
		class  Handicap;
		model  Score =  Handicap;
		means Handicap;
		
		proc glm data= work.handicapdata ORDER = DATA;
		class  Handicap;
		model  Score =  Handicap;
		means Handicap/ HOVTEST=bf bon cldiff;
		CONTRAST 'μ2- μ3' Handicap 0 1 -1 0 0 0;
		
		