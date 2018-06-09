data monkey;
infile 'C:\Users\danie\Documents\GitHub\Statistics\Applied Unit 5\monkey.csv' dlm=',' firstobs=2;
input Monkey $ Treatment $ Week  Memory $ PerCorrect NewPerCorrect;
run;


*Lets first run a basic two way anova;

proc glm data=monkey;
class Treatment Memory Week;
model NewPerCorrect=Treatment Week Treatment*Week;
estimate 'What is this contrast?' Treatment -1 1 Treatment*Week -.5 -.5 0 0 0 .5 .5 0 0 0;
lsmeans Treatment*Week / pdiff tdiff adjust=Tukey;
run;

*Note the combination order to help you with the contrasts is
  Treatment "Control" "Treatment"
  Week 2 4 8 12 16;

*Now, we know that we have repeated measures on the same monkey and thus correlated data.
Let's see what happens if we try to handle that in proc mixed using a repeated statement;
*The type=CS option is the compound symmetry assumption Dr.  McGee's video mentions.  We will discuss this in more detail later;


proc mixed data=monkey;
class Treatment Memory Monkey Week;
model NewPerCorrect=Treatment Week Treatment*Week;
repeated Week/ type=CS subject=Monkey;
lsmeans Treatment*Week / pdiff tdiff adjust=Tukey;
estimate 'What is this contrast?' Treatment -1 1 Treatment*Week -.5 -.5 0 0 0 .5 .5 0 0 0;
run;


/* 3.	Based on what you know about 2way anova, is there an interaction?
Also, to get at one of the researcher’s questions, figure out the contrast
that would test for the difference in mean percentage between Treated and 
Control groups specifically for Week2. */
proc print data=monkey;

proc mixed data=monkey;
class Treatment Memory Monkey Week;
model NewPerCorrect=Treatment Week Treatment*Week;
repeated Week/ type=CS subject=Monkey;
lsmeans Treatment*Week / pdiff tdiff adjust=Tukey;
estimate 'Control groups specifically for Week2' Treatment -1 1 Treatment*Week -1 0 0 0 0 1 0 0 0 0;
run;

/* 4.	Can you also write a contrast to test for Week 12 vs Week2 for the Treated group?
Include the contrast in both of the procs and compare the result.  Are they the same, if not
what is different? */

/* Week		2 4 8 12 16 */
proc mixed data=monkey;
class Treatment Memory Monkey Week;
model NewPerCorrect=Treatment Week Treatment*Week;
repeated Week/ type=CS subject=Monkey;
lsmeans Treatment*Week / pdiff tdiff adjust=Tukey;
estimate ' Week 12 vs Week2 Treatment' Week -1 0 0 1 0 Treatment*Week 0 0 0 0 0 -1 0 0 1 0 ;
run;




