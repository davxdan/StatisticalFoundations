/* Brown and Forsythe's Test for Homogeneity of "write" Variance */
/* Histogram isn’t good for variance visualization and a boxplot will be better.
/*But it is recommended to use Brown-Forsythe test which is a formal test.
/*There is sufficient evidence (p-value = .0022) at significance level of 0.05 to conclude that the variance of the male writing scores is different from that of the females.  */
		proc glm data = work.hsb2; 
		class female;
		model  write =  female;
		means female / HOVTEST=bf;