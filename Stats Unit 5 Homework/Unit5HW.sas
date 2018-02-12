/* Generated Code (IMPORT) */
/* Source File: ex0525.csv */
/* Source Path: /folders/myfolders/Datasets */
/* Code generated on: 2/10/18, 10:02 AM */
%web_drop_table(WORK.Education);
FILENAME REFFILE '/folders/myfolders/Datasets/ex0525.csv';
PROC IMPORT DATAFILE=REFFILE
	DBMS=CSV
	OUT=WORK.Education;
	GETNAMES=YES;
/* PROC CONTENTS DATA=WORK.Education; RUN; */
DATA Education(DROP = Subject); 
SET Education;
/* Proc Print data=Education; run; */
proc Sort data=Education;
	by Educ;

proc univariate data=Education;
	by Educ;
	histogram;
	qqplot Income2005;

/* Boxplot */
proc boxplot data=Education;
	plot Income2005*Educ;


/* ANOVA using GLM */
/* Proc GLM data=Education; */
/* class Educ; */
/* model Income2005 = Educ; */
/* means Educ; */

/* Log Transform the Education Data */
data lEducation;
set Education;
loggedIncome2005 = log(Income2005);
DATA  WORK.LEDUCATION(DROP =  Income2005); 
SET  WORK.LEDUCATION;
RUN;

proc Sort data=lEducation;
	by Educ;

proc univariate data=lEducation;
	by Educ;
	histogram;
	qqplot loggedIncome2005;

/* Boxplot */
proc boxplot data=WORK.LEDUCATION;
	plot loggedIncome2005*Educ;

/* Means */
/* proc means data=lEducation N mean stddev min q1 median q3 max; */
/* by Educ; */
/* var  loggedIncome2005; */


/* ANOVA using GLM */
Proc GLM data= WORK.LEDUCATION;
class Educ;
model  loggedIncome2005 = Educ;
means Educ;
run;

/* Problem 2 extra sum of squares F-test (BYOA …)  */
/* Education Groups 16 and >16*/
	data Educ16;
	set WORK.LEDUCATION;
	if Educ ne ">16" then 
		if Educ ne "16" then OthersModel = "Other";
		else OthersModel = "16yr";
		else OthersModel = "More16yr";
	Proc GLM data= Educ16;
	class   OthersModel;
	model   loggedIncome2005 =   OthersModel;
	Proc GLM data= Educ16;
	class    Educ;
	model   loggedIncome2005 =   Educ;
	
/* Problem 3	Welchs */
Proc GLM data= Educ16;
	class    Educ;
	model   loggedIncome2005 =   Educ;
	means Educ / hovtest=bf Welch;
	
/* 	proc ttest data=Educ16; */
/* 		class Educ; */
/* 		var loggedIncome2005; */


/* Less Complicated Way */
	/* 16 Year Educ */
/* 	data Educ16; */
/* 	set WORK.LEDUCATION; */
/* 	if Educ ne "16" then OthersModel = 'Other'; */
/* 	else OthersModel = "16yr"; */
/* 	run; */
/* 	Others Equal Model */
/* 	Proc GLM data= Educ16 ; */
/* 	class   OthersModel; */
/* 	model   loggedIncome2005 =   OthersModel; */
/* 	run; */
/* 		Over 16 Yr Educ */
/* 	data EducOver16; */
/* 	set WORK.LEDUCATION; */
/* 	if Educ ne ">16" then OthersModel = 'Other'; */
/* 	else OthersModel = "Over16"; */
/* 	run; */
/* 	Others Equal Model */
/* 	Proc GLM data= EducOver16; */
/* 	class   OthersModel; */
/* 	model   loggedIncome2005 =   OthersModel; */
/* 	run; */

/* To Validate My Code and Data against the Book and Slides */
Proc GLM data= WORK.IMPORT;
class  Judge;
model  Percent =  Judge;
means  Judge ;


/* Means */
proc Sort data=WORK.IMPORT;
	by Judge;
/* proc means data=WORK.IMPORT N mean stddev min q1 median q3 max; */
/* by Judge; */
/* var  Percent; */

data spock2 ;
set WORK.IMPORT;
if Judge ne "Spock's" then OthersModel = "Others";
else OthersModel = "S";

/* proc print data = SPOCK2; */

/* Separate Means MOdel */
Proc GLM data= spock2 ;
class  Judge;
model  Percent =  Judge;


/* Others Equal Model */
Proc GLM data= spock2;
class   OthersModel;
model  Percent =   OthersModel;





/* Snippets */