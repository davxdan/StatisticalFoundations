data temp;
input ID SBP DBP SEX $ Age WT;
datalines;
1 120 80 m 15 115
2 130 70 f 25 180
3 140 100 m 89 170
;
title 'Means of BP Data';
proc means data=temp; run;
data thesample;
infile '/folders/myfolders/sample.csv' firstobs= 2;
input a b c;
run;
proc print data = thesample; run;