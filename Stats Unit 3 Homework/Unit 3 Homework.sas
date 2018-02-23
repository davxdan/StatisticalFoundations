/* Problem 1 */
/* data SamoaEmployees; */
/* 	Input EmploymentStatus$ Age; */
/* 	datalines; */
/* Fired 34 */
/* Fired 37 */
/* Fired 37 */
/* Fired 38 */
/* Fired 41 */
/* Fired 42 */
/* Fired 43 */
/* Fired 44 */
/* Fired 44 */
/* Fired 45 */
/* Fired 45 */
/* Fired 45 */
/* Fired 46 */
/* Fired 48 */
/* Fired 49 */
/* Fired 53 */
/* Fired 53 */
/* Fired 54 */
/* Fired 54 */
/* Fired 55 */
/* Fired 56 */
/* Notfired 27 */
/* Notfired 33 */
/* Notfired 36 */
/* Notfired 37 */
/* Notfired 38 */
/* Notfired 38 */
/* Notfired 39 */
/* Notfired 42 */
/* Notfired 42 */
/* Notfired 43 */
/* Notfired 43 */
/* Notfired 44 */
/* Notfired 44 */
/* Notfired 44 */
/* Notfired 45 */
/* Notfired 45 */
/* Notfired 45 */
/* Notfired 45 */
/* Notfired 46 */
/* Notfired 46 */
/* Notfired 47 */
/* Notfired 47 */
/* Notfired 48 */
/* Notfired 48 */
/* Notfired 49 */
/* Notfired 49 */
/* Notfired 51 */
/* Notfired 51 */
/* Notfired 52 */
/* Notfired 54 */
/* ; */
/*  */
/* Sort the Data */
/* proc Sort data=SamoaEmployees; */
/* 	by EmploymentStatus; */
/*  */
/* Verify the data */
/* Proc Print data=SamoaEmployees; */
/*  */
/* proc univariate data = SamoaEmployees; */
/* by EmploymentStatus; */
/* histogram; */
/* qqplot Age; */
/* run; */
/*  */
/* Get the Critical Value */
/* data critval; */
/* cv = quantile("T", .05, 49);  */
/* alpha  = .05; */
/* proc print data = critval; */
/* run; */
/*  */
/* Boxplot */
/* proc boxplot data=SamoaEmployees; */
/* plot Age*EmploymentStatus; */
/* run; */
/*  */
/* proc ttest data=SamoaEmployees sides=u ho = 0; */
/* 	class EmploymentStatus; */
/* 	var Age; */
/* run; */

/* Problem 2a */
data StudentCash;
	Input School$ Cash;
	datalines;
SMU 34
SMU 1200
SMU 23
SMU 50
SMU 60
SMU 50
SMU 0
SMU 0
SMU 30
SMU 89
SMU 0
SMU 300
SMU 400
SMU 20
SMU 10
SMU 0
Seattle 20
Seattle 10
Seattle 5
Seattle 0
Seattle 30
Seattle 50
Seattle 0
Seattle 100
Seattle 110
Seattle 0
Seattle 40
Seattle 10
Seattle 3
Seattle 0
;
/*  */
/* Sort the Data */
/* proc Sort data=StudentCash; */
/* 	by School; */
/*  */
/* Verify the data */
/* Proc Print data=StudentCash; */
/*  */
/* proc univariate data = StudentCash; */
/* by School; */
/* histogram; */
/* qqplot Cash; */
/* run; */
/*  */
/* Get the Critical Value */
/* data critval; */
/* cv = quantile("T", .05, 28);  */
/* alpha  = .05; */
/* proc print data = critval; */
/* run; */
/*  */
/* Boxplot */
/* proc boxplot data=StudentCash; */
/* plot Cash*School; */
/* run; */
/*  */
/* proc ttest data=StudentCash sides=2 ho = 0; */
/* 	class School; */
/* 	var Cash; */
/* run; */




/* Problem 2b Permutation */
/* critical values */
data critval;
cv = quantile("T", .95, 28); 
alpha  = .05; 
proc print data = critval;
run;

data StudentCash;
	Input School Cash;
	datalines;
0 34
0 1200
0 23
0 50
0 60
0 50
0 0
0 0
0 30
0 89
0 0
0 300
0 400
0 20
0 10
0 0
1 20
1 10
1 5
1 0
1 30
1 50
1 0
1 100
1 110
1 0
1 40
1 10
1 3
1 0
;

/* Sort the Data */
proc Sort data=StudentCash;
	by School;
/* Difference in means is 114.6 */

ods output off;
ods exclude all;

proc iml;
use StudentCash;
read all var{School Cash} into x;
p = t(ranperm(x[,2],1000));
paf = x[,1]||p;                                                                                                                                                                                                              
create newds from paf;                                                                                                                                                                                                       
append from paf;                                                                                                                                                                                                             
quit;                                                                                                                                                                                                                        
*calculates differences and creates a histogram;                                                                                                                                                                             
ods output conflimits=diff;                                                                                                                                                                                                  
proc ttest data=newds plots=none sides=2 alpha=.05;                                                                                                                                                                                            
  class col1;                                                                                                                                                                                                                
  var col2 - col1001;                                                                                                                                                                                                        
run;                                                                                                                                                                                                                         

ods output on;
ods exclude none;

proc univariate data=diff;                                                                                                                                                                                                   
  where method = "Pooled";                                                                                                                                                                                                   
  var mean;                                                                                                                                                                                                                  
  histogram mean;                                                                                                                                                                                                            
run;                                                                                                                                                                                                                         
                                                                                                                                                                                  
*The code below calculates the number of randomly generated differences that are as extreme or more extreme thant the one observed (divide this number by 1000 you have the pvalue);                                         
*check the log to see how many observations are in the data set.... divide this by 1000 (or however many permutations you generated) and that is the (one sided)p-value;                                                     
data numdiffs;                                                                                                                                                                                                               
set diff;                                                                                                                                                                                                                    
where method = "Pooled";                                                                                                                                                                                                     
if abs(mean) >= 114.6;   *you will need to put the observed difference you got from t test above here.  note if you have a one or two tailed test.;                                                                           
run;                                                                                                                                                                                                                         
* just a visual of the rows produced ... you can get the number of obersvations from the last data step and the Log window.;                                                                                                 
proc print data = numdiffs;                                                                                                                                                                                                  
where method = "Pooled";                                                                                                                                                                                                     
run;



/* Problem 2b If I used Log */
/* critical values */
/* data critval; */
/* cv = quantile("T", .95, 28);  */
/* alpha  = .05;  */
/* proc print data = critval; */
/* run; */
/*  */
/* data StudentCash; */
/* 	Input School$ Cash; */
/* 	datalines; */
/* SMU 34 */
/* SMU 1200 */
/* SMU 23 */
/* SMU 50 */
/* SMU 60 */
/* SMU 50 */
/* SMU 0 */
/* SMU 0 */
/* SMU 30 */
/* SMU 89 */
/* SMU 0 */
/* SMU 300 */
/* SMU 400 */
/* SMU 20 */
/* SMU 10 */
/* SMU 0 */
/* Seattle 20 */
/* Seattle 10 */
/* Seattle 5 */
/* Seattle 0 */
/* Seattle 30 */
/* Seattle 50 */
/* Seattle 0 */
/* Seattle 100 */
/* Seattle 110 */
/* Seattle 0 */
/* Seattle 40 */
/* Seattle 10 */
/* Seattle 3 */
/* Seattle 0 */
/* ; */
/*  */
/* data lStudentCash; */
/* set StudentCash; */
/* loggedcash = log(Cash); */
/*  */
/* proc print data = lStudentCash; */
/*  */
/* proc ttest data= lStudentCash sides=2 ho = 0; */
/* 	class School; */
/* 	var loggedcash; */
/* run; */
/*  */
/* proc ttest data=StudentCash sides=2 ho = 0; */
/* 	class School; */
/* 	var Cash; */
/* run; */


/* Problem 2c No Outliers */
/*  */
/* data StudentNolOutliersCash; */
/* 	Input School$ Cash; */
/* 	datalines; */
/* SMU 34 */
/*  */
/* SMU 23 */
/* SMU 50 */
/* SMU 60 */
/* SMU 50 */
/* SMU 0 */
/* SMU 0 */
/* SMU 30 */
/* SMU 89 */
/* SMU 0 */
/* SMU 300 */
/* SMU 400 */
/* SMU 20 */
/* SMU 10 */
/* SMU 0 */
/* Seattle 20 */
/* Seattle 10 */
/* Seattle 5 */
/* Seattle 0 */
/* Seattle 30 */
/* Seattle 50 */
/* Seattle 0 */
/* Seattle 100 */
/* Seattle 110 */
/* Seattle 0 */
/* Seattle 40 */
/* Seattle 10 */
/* Seattle 3 */
/* Seattle 0 */
/* ; */
/*  */
/* Sort the Data */
/* proc Sort data= StudentNolOutliersCash; */
/* 	by School; */
/*  */
/* Verify the data */
/* Proc Print data= StudentNolOutliersCash; */
/*  */
/* proc univariate data =  StudentNolOutliersCash; */
/* by School; */
/* histogram; */
/* qqplot Cash; */
/* run; */
/*  */
/* Get the Critical Value */
/* data critval; */
/* cv = quantile("T", .05, 49);  */
/* alpha  = .05; */
/* proc print data = critval; */
/* run; */
/*  */
/* Boxplot */
/* proc boxplot data= StudentNolOutliersCash; */
/* plot Cash*School; */
/* run; */
/*  */
/* proc ttest data= StudentNolOutliersCash sides=2 ho = 0; */
/* 	class School; */
/* 	var Cash; */
/* run; */


/* Sample code */
/* data FootballPlayers; */
/* Input Height; */
/* datalines; */
/* 6.329999924 */
/* 6.5 */
/* ; */
/* proc ttest data = FootballPlayers sides = u ho = 6 alpha=.01; */

/* data mice; */
/* input treatment $ tcell; */
/* datalines; */
/* Drug 20.47636971 */
/* Placebo 2.682907434 */
/* ; */


/* proc ttest data = Dogs sides = u ho = 40; */


/* Run a ttest to get the difference in means */



