Question 1
data Bats;                                                                                                                           
input weight;                                                                                                                                                                                                     
datalines;                                                                                                                                                                                                                   
1.7
1.6
1.5
2
2.3
1.6
1.6
1.8
1.5
1.7
1.2
1.4
1.6
1.6
1.6
;
                                                                                                                                                                                                                            
proc print data = Bats;
run; 

proc sort data = Bats;
by weight;
run;

/* critical values */
/* data critval; */
/* cv = quantile("T", .95, 14);  */
/* alpha  = .05;  */
/* proc print data = critval; */
/* run; */

proc ttest data = Bats sides = 2 ho = 1.8  alpha=.05;
var weight;
run;








/* Question 2 , 0 = Not Fired, 1 = Fired */
data SamoaEmployees;
	Input EmploymentStatus Age;
	datalines;
1 34
1 37
1 37
1 38
1 41
1 42
1 43
1 44
1 44
1 45
1 45
1 45
1 46
1 48
1 49
1 53
1 53
1 54
1 54
1 55
1 56
0 27
0 33
0 36
0 37
0 38
0 38
0 39
0 42
0 42
0 43
0 43
0 44
0 44
0 44
0 45
0 45
0 45
0 45
0 46
0 46
0 47
0 47
0 48
0 48
0 49
0 49
0 51
0 51
0 52
0 54
;
/* Sort the Data. This makes the class 0 (Employment status) first so we are subtracting fired from not fired. */
proc Sort data=SamoaEmployees;
	by EmploymentStatus;

/* Proc Print data=SamoaEmployees; */

/* Get the Critical Value */
/* data critval; */
/* cv = quantile("T", .05, 49);  */
/* alpha  = .05; */
/* proc print data = critval; */
/* run; */

/* Run a ttest to get the difference in means */
/* The code I used for homework wasn't quite right. I used sides=l but should have used sides=u I have corrected this restrospectively */
proc ttest data=SamoaEmployees sides=u;
	class EmploymentStatus;
	var Age;
run;




/* Problem 2g */
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

/* Proc Print data=statsclassstudents; */

/* critical values */
/* data critval; */
/* cv = quantile("T", .95, 28);  */
/* alpha  = .05;  */
/* proc print data = critval; */
/* run; */

proc ttest data=StatsClassStudents sides=2;
	class University;
	var Cash;
run;



/* Problem 3 */
*to find the sample size required for a desired power;
proc power;
onesamplemeans
sides = u
mean = 4.3
nullmean = 4
stddev = 1.2
ntotal = .
power = .8 .7 .6
;
plot x = effect min = 4.2  max =5.5;
run;

/* Samoa Employees Power Calcs */

proc power;
twosamplemeans
meandiff = 1.9238 
stddev = 6.1519
ntotal = .
power = .8;
plot x = effect min =.5 max = 2;
run;

proc power;
twosamplemeans
meandiff = 1.9238 
stddev = 6.1519
ntotal = .
power = .8 .7 .6;
plot y = effect min =.5 max = 2;
run;


proc power;
twosamplemeans
meandiff = 1.9238 
stddev = 6.1519
ntotal = .
power = .8 .6;
plot x = effect min = .6  max =1;
run;
