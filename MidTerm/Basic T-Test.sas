proc ttest data=WORK.HSB2 h0=50;
	/*Testing to see if mean writing score is =50 in this case*/
	var write;


/* Test the claim that the mean writing score is different for males and females.  Include all 6 steps.    */
/* 𝑇𝑒𝑠𝑡 𝑆𝑡𝑎𝑡𝑖𝑠𝑡𝑖𝑐:−3.66 */
/* 𝑃−𝑣𝑎𝑙𝑢𝑒= .0003 */
/* 𝑅𝑒𝑗𝑒𝑐𝑡 𝐻_0 */
/* A 95% confidence interval for this difference is: (2.2 points, 7.5 points), a positive difference in favor of females. */
proc ttest data=WORK.HSB2 sides=2;
	/*Testing normality of the writing scores male "0" and female "1" in the Female column*/
	class female;
	var write;