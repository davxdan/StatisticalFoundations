/* A Wilcoxon Rank Sum test is performed between the two groups. */
proc means data = work.hsb2 median;
class race;
var write;
run;
data quantile;
aquant = quantile('NORMAL', .975);
run;
proc print data = quantile;
run;
proc npar1way data = WORK.hsb2 Wilcoxon;
where race = 1|race = 4;
class race;
var write;
exact Wilcoxon/mc;
run;
/* 𝐶𝑟𝑖𝑡𝑖𝑐𝑎𝑙 𝑉𝑎𝑙𝑢𝑒 (𝑛𝑜𝑟𝑚𝑎𝑙 𝑎𝑝𝑝𝑟𝑥𝑜𝑖𝑚𝑎𝑡𝑖𝑜𝑛):𝑧_.975=±1.96 */
/* 𝑇𝑒𝑠𝑡 𝑆𝑡𝑎𝑡𝑖𝑠𝑡𝑖𝑐:𝑧=−3.72 */
/* 𝑃−𝑣𝑎𝑙𝑢𝑒= .0002 */
/* 𝑅𝑒𝑗𝑒𝑐𝑡 𝐻_0 */

/* proc npar1way data = WORK.hsb2 Wilcoxon; */
/* class female; */
/* var write; */
/* exact Wilcoxon/mc; */
/* run; */
