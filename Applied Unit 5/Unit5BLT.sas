/*  First analysis: Incorrectly using completely randomized design (CRD)Measures of Variation: One-Way CRD */
data simpleCRD;
	input Time Score @@;
	datalines;
1 30 1 14 1 24 1 38 1 26
2 28 2 18 2 20 2 34 2 28
3 34 3 22 3 30 3 44 3 30
;
run;

PROC GLM data=simpleCRD;
	class time;
	model score=time;
	run;
quit;



/*SAS Code for Repeated Measures*/
data simpleRM;
input subject time1 time2 time3;
datalines;
1 30 28 34
2 14 18 22
3 24 20 30
4 38 34 44
5 26 28 30
;
run;
/* Repeated Measures ANOVA Code */
PROC GLM data=simpleRM; /*data option not necessary, but it's good practice */
  model time1 time2 time3 = / nouni;
 /*nouni = no univariate tests. If not specified, SAS will run three */
  /* univariate ANOVA, one for each level of time */
  repeated time 3 / printe;
  /* repeated tells SAS that the variables on the LHS of the model statement */
  /* are repeated measures and not separate variables */
