proc sort data=work.hsb2; /*Be carefule this may affect other tests!!*/
	by female; /*Possible values of the "female" column are 0 and 1. Meaning female or not.*/