

/* Problem 1 */
/* Load Data */
%web_drop_table(WORK.BaseBall);
FILENAME REFFILE '/folders/myfolders/Stats Unit 8 Homework/unit8data/Baseball_Data.csv';
PROC IMPORT DATAFILE=REFFILE
	DBMS=CSV 
	OUT=WORK.BaseBall;
	GETNAMES=YES;
/* Scatter Plot */
proc sgscatter data = work.baseball;
plot Wins*Payroll;

/* Problem 2 */
/* Correlation */
proc corr data= work.baseball;
	
/* Problem 3 */
%web_drop_table(WORK.DeletedSD);
FILENAME REFFILE '/folders/myfolders/Stats Unit 8 Homework/unit8data/DeletedSD_Baseball_Data.csv';
PROC IMPORT DATAFILE=REFFILE
	DBMS=CSV
	OUT=WORK.DeletedSD;
	GETNAMES=YES;
proc sgscatter data = work.DeletedSD;
plot Wins*Payroll;
proc corr data= work.DeletedSD;

data cars;                                                                                                                             
input speed MPG;                                                                                                                     
datalines;                                                                                                                              
20 30
30 28
40 30
50 28
60 24
;
proc sgscatter data=cars;
plot MPG*speed;
proc corr data= cars;                                                                                                                                   
   


