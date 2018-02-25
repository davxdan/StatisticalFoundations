/* Alternative to t-test when the normality is in doubt */
/* Wilcoxon Two Sample Test = Two-Sided Pr > |Z|	0.0010 */
proc npar1way data = WORK.hsb2 Wilcoxon;
class female;
var write;
run;

/* Also the Kruskal-Wallis Test Chi-Square	11.0833  */

