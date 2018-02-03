/* I didnt actually urn this; just notes form the BLT */

data scores;
infile 'c:Desktop\hsb2.csv' dlm = ',' firstobs = 2;
input id female race ses schtyp prog read write math science;
run;
proc print data = scores; run;
ODS rtf;
proc univariate data = scores;
var write math;
class schtyp;
histogram write math;
qqplot write math;
run;
ODS rtf close;

proc npar1way data = scores wilcoxon;
var math;
class schtyp;
exact wilcoxon / mc;
run;

proc npar1way data = scores wilcoxon;
var math;
class ses;
exact wilcoxon / mc;
run;

data Wretching;
Input Treatment$ Vomit; 
datalines;
Marijuana 15
Marijuana 25
Marijuana 0
Marijuana 0
Marijuana 4
Placebo 23
Placebo 50
Placebo 0
Placebo 99
Placebo 31
;


proc print data = Wretching; run;
/* ODS rtf; */
proc univariate data = Wretching;
var Marijuana Placebo;
/* class schtyp; */
histogram  Marijuana Placebo;
qqplot Marijuana Placebo;
run;
/* ODS rtf close; */

proc npar1way data = Wretching wilcoxon;
var Vomit;
class Treatment;
exact wilcoxon / mc;
run;

proc npar1way data = Wretching wilcoxon;
var Marijuana;
class Placebo;
exact wilcoxon / mc;
run;