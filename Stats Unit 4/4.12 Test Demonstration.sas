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