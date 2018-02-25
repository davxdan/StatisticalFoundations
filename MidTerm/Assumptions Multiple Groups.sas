/* 	The histogram of the largest group (n=145), race=4, shows non normality with left skewness.  */
/* 	Recall that with small sample sizes, it is difficult to ascertain the true shape.  */
/* 	The normality is might be questionable due to moderate sample sizes (smallest n=11).  */
/* 	We will assume the same shapes of the distributions of the four underlying populations.  */
/* 	To be on the safe side, we will then conduct a Kruskal-Wallis Test and make inference on the medians.  */
proc glm data=work.hsb2;
	class race;
	model write=race;
	means race;

proc sort data=work.hsb2; /*Be carefule this may affect other tests!!*/
	by race; /*Possible values of the "female" column are 0 and 1. Meaning female or not.*/
proc univariate data=WORK.hsb2;
	by race;
	histogram write;
	qqplot write;