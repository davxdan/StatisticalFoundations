/* Boxplot */
proc boxplot data=WORK.LEDUCATION;
	plot loggedIncome2005*Educ;