data result;
do diet = 1 to 2;
input LDL @@;
output;
end;
datalines;
100
80
;
run;
proc print data=result;
proc glmpower data=result;
class diet;
model LDL = diet;
power
stddev=100
ntotal = .
power = .8;
run;
