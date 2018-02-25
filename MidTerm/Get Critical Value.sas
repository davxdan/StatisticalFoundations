data quantile;
	myquant=quantile('t', 0.975, 199);

	/*199 is DF and .975 results in 95% CL*/
run;

proc print data=quantile;
run;