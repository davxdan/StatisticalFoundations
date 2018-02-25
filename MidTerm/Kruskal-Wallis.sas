/* Test if the 1st  race has a different mean writing score than the 4th race */
/* 𝐶𝑟𝑖𝑡𝑖𝑐𝑎𝑙 𝑉𝑎𝑙𝑢𝑒:𝑠𝑘𝑖𝑝 */
/* 𝑇𝑒𝑠𝑡 𝑆𝑡𝑎𝑡𝑖𝑠𝑡𝑖𝑐:𝜒^2=22.1942 */
/* 𝑃−𝑣𝑎𝑙𝑢𝑒< .0001 */
/* 𝑅𝑒𝑗𝑒𝑐𝑡 𝐻_0   */
proc npar1way data = work.hsb2;
class race;
var write;
run;
/* There is sufficient evidence (p-value < .0001) at the significance level of 0.05 
that at least one of the medians is different. */
/* We will then test if the 1st race has a different median from the 4th race. */
/* A multiple comparison adjustment is unnecessary here since we are only examining one comparison and the hypothesis was formulated before we looked at the data. */

