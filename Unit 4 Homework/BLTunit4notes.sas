/*Notes from the "Measuring Accuracy" BLT to Bootstrap Sample*/
/*GEnerate Random Normal Data with mean 22 and SD 5 */
data original;
do j = 1 to 50
rnorm = 22 + 5*rannor(345768) /*345768 is a seed to enable regen of same sampl*/
output;
end;
run;

data _NULL_;
if 0 then set original nobs=n;
call symputx('nrows',n); /*calcultes observations from above*/
stop;
run;
%put nobs=&nrows;

data bootsamp;
do sampnum = 1 to 1000; /*change this for different reps*/
x = round(ranuni(0)* &nrows); /*x randomly selected from values*/
set original nobs= numrecs point=x; /* This selected the xth */
output; /* Send the selected observation to the new datas set */
end;
end;
stop; /* Required when using point */
run;

/* proc print data=bootsamp; */
data bootorig;
set original (in=a) bootsamp (drop=i);
if a then sampnum = 0;
run;

proc means noprint data=bootorig;
class sampnum;
var rnorm;
output out=bootout
mean=mean
var=var
n=n;
run;

data calcbias;
merge bootout;
by sampnum;
sampmean = mean;
sampvar = var;
retain origmean;
if sampnum=0 then origmean=mean;
/*Calculate bias and MSE */
bias = sampmean-origmean;
bias2 = bias*bias;
mse = sampvar - bias2;
run;
proc print data = calcbias;
var bias mse;
run;



