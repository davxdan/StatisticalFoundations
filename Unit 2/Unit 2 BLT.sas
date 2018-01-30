/* Unit 2 BLT1 */

/* Calculating the required sample size for the power of .8, One Sample 1 side */
/* proc power; */
/* onesamplemeans */
/* alpha = .05 */
/* nullmean=0 */
/* mean = 5 */
/* stddev = 25 */
/* power = .8 */
/* sides=u */
/* ntotal = .; */
/* run; */

/* Calculating the power for 2 sample Tests */
proc power;
/* test=diff_satt means we have different sample sizes */
twosamplemeans test=diff_satt 
/* alpha = .05 */
/* nullmean=0 */
/* groupmeans = 10|14 */
meandiff= 3 6
/* Because we have multiple SD values after the pipe SAS will calculate for each of them */
groupstddevs = 7| 7 9 12
/* stddev = 20 */
power = .
/* sides=u */
/* A period tells SAS that this is what we want it to calculate */
ntotal = 100;
/* To add a plot of the effect */
plot x=effect min=3 max=6;
run;