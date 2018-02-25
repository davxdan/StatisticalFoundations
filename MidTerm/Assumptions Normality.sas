proc ttest data=WORK.HSB2 sides=2;
	/*Testing normality of the writing scores male "0" and female "1" in the Female column*/
	class female;
	var write;
/* The histogram and q-q plot show left skewed distribution, although the sample size of 200 should ensure that the sample mean will be normally distributed (central limit theorem).*/
/*  We will assume the scores are independent of one another and proceed with a one-sample t-test.  */
/* *Transformation is an option if it improves normality, but the inference will be on the median. */