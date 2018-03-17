%web_drop_table(WORK.BB);
FILENAME REFFILE '/folders/myfolders/Stats Unit 9 Homework/Baseball_Data.csv';

PROC IMPORT DATAFILE=REFFILE
	DBMS=CSV
	OUT=WORK.BB;
	GETNAMES=YES;


proc reg data= BB; 
model wins = payroll /clb; 
run; 


/*28 DF and .975 results in . 05 alpha */
data quantile;
	myquant=quantile('t', 0.975, 28);
proc print data=quantile;
run;




data movie;                                                                                                                             
input budget gross;                                                                                                                     
datalines;                                                                                                                              
62 65                                                                                                                                   
90 64                                                                                                                                   
50 48                                                                                                                                   
35 57   
200 601                                                                                                                                
100 146                                                                                                                                 
90  47                                                                                                                                  
;                                                                                                                                       
proc print data = movie;
run;
proc glm data = movie;
model gross = budget / clparm;
run;
***OR***;
proc reg data= movie;
model gross = budget / clb;
run;

proc reg data= movie;
model gross = budget / cli;
run;
