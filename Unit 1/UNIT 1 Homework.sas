*Unit 1 Homework;

data StatsClassStudents;
	Input University Cash;
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
proc Sort data=StatsClassStudents;
	by University;

/* proc univariate data=StatsClassStudents; */
/* 	by University; */
/* 	VAR Cash; */
/* 	histogram Cash / MIDPOINTS=50 100 150 200 250 300 350 400 450 500 550 600 650  */
/* 		700 750 800 850 900 950 1000 1050 1100 1150 1200; */
/* run; */
/* Proc Print data=statsclassstudents; */
/* proc ttest data=StatsClassStudents sides=u; */
/* 	class University; */
/* 	var Cash; */
/* run; */
/* 114.6; */
/*Permutation; */
* To get the observed difference;                                                                                                                                                                                            
/* proc ttest data=StatsClassStudents sides=2;  * You will need to change the dataset name here.;                                                                                                                                                      */
/*                                                                                                                                                                                                                               */
/*    class University;    *and change the class variable to match yours here;                                                                                                                                                   */
/*                                                                                                                                                                                                                               */
/*    var Cash;          * and change the var name here.;                                                                                                                                                                       */
/*                                                                                                                                                                                                                               */
/* run;                                                                                                                                                                                                                          */

ods output off;
ods exclude all;
                                                                                                                                                                                                                         
*borrowed code from internet ... randomizes observations and creates a matrix ... one row per randomization ;                                                                                                                
proc iml;                                                                                                                                                                                                                    
use StatsClassStudents;                        * change data set name here to match your data set name above;                                                                                                                              
read all var{University Cash} into x;   *change varibale names here ... make sure it is class then var ... in that order.;                                                                                                  
p = t(ranperm(x[,2],1000));    *Note that the "1000" here is the number of permutations. ;                                                                                                                                    
paf = x[,1]||p;                                                                                                                                                                                                              
create newds from paf;                                                                                                                                                                                                       
append from paf;                                                                                                                                                                                                             
quit;                                                                                                                                                                                                                        
                                                                                                                                                                                                                             
*calculates differences and creates a histogram;                                                                                                                                                                             
ods output conflimits=diff;                                                                                                                                                                                                  
proc ttest data=newds plots=none sides=2;                                                                                                                                                                                            
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
                                                                                                                                                                                                                             
                                                                                                                                                                                                                             
*Idea from http://sas-and-r.blogspot.com/2011/10/example-912-simpler-ways-to-carry-out.html ;                                                                                                                                
/* proc ttest data = StatsClassStudents sides = 2 ho = 27 alpha=.05;                               */


