/* Problem 1 Bonferroni */
	/* 	Load the data */
		%web_drop_table(WORK.HandicapData);
		FILENAME REFFILE 
			'/folders/myfolders/Stats Unit 6 Homework/Unit 6 Handicap Data.csv';
		PROC IMPORT DATAFILE=REFFILE DBMS=CSV OUT=WORK.HandicapData;
			GETNAMES=YES;
		PROC print DATA=WORK.HandicapData;

	/* 	Bonferroni Test (template) */
		proc glm data = work.handicapdata;
		class  Handicap;
		model  Score =  Handicap;
		means Handicap / HOVTEST=bf bon cldiff;
		lsmeans Handicap/ pdiff; 
		/*lsmeans Handicap/ pdiff adjust = bon cl;*/
		
	/*	Get Means just to seeif the results are same as book */
		proc glm data = work.handicapdata;
		class  Handicap;
		model  Score =  Handicap;
		means Handicap;
	/* The Actual Test Used */
		proc glm data= work.handicapdata ORDER = DATA;
		class  Handicap;
		model  Score =  Handicap;
		means Handicap / HOVTEST=bf bon cldiff;
	/*	lsmeans Handicap/ pdiff adjust = bon cl; */
		lsmeans Handicap/ pdiff;
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
	/* Load the Data */
		%web_drop_table(WORK.Education);
		FILENAME REFFILE '/folders/myfolders/Datasets/ex0525.csv';
		PROC IMPORT DATAFILE=REFFILE
		DBMS=CSV
		OUT=WORK.Education;
		GETNAMES=YES;
		/* 	PROC CONTENTS DATA=WORK.Education; */

	/*Get Rid of Unwanted Subject ID to avoiud treating it as a viariable */
		DATA Education(DROP = Subject); 
		SET Education;

	/*Sort the Data CAUTION for Other Tests	 */
		proc Sort data=Education;
		by Educ;
	
	/*Analyze Variances */
		/*Do an ANOVA using GLM */
			Proc GLM data=Education;
			class Educ;
			model Income2005 = Educ;
			means Educ;
			
		/*Generate QQPLots */
			proc univariate data=Education;
			by Educ;
			qqplot Income2005;
	
	/*Execute Tests */
		/*Tukey */
		Proc GLM data=Education;
		class Educ;
		model Income2005 = Educ;
		means Educ / Tukey;
		/*Tukey */
		Proc GLM data=Education;
		class Educ;
		model Income2005 = Educ;
		means Educ / HOVTEST = BF Tukey cldiff;
		lsmeans Educ / pdiff;
		CONTRAST '>16  -  13-15' Educ 0 -1 0 0 1;
		CONTRAST '>16  - 12' Educ -1 0 0 0 1;
		CONTRAST '>16  -  <12' Educ 0 0 0 -1 1;
		CONTRAST '16 -  13-15' Educ 0 -1 1 0 0;
		CONTRAST '16 - 12' Educ -1 0 1 0 0;
		CONTRAST '16 -  <12' Educ 0 0 1 -1 0;
		CONTRAST '13-15  - 12' Educ -1 1 0 0 0;
		CONTRAST '13-15  -  <12' Educ 0 1 0 -1 0;

		/*Dunnett */
		proc glm data= Education ORDER = DATA;
			class  Educ;
			model  Income2005 = Educ;
			means Educ/ HOVTEST=bf DUNNETT('12') cldiff;
			lsmeans Educ / pdiff=control ('12');



