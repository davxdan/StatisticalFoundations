*Bonferroni adjusted lsmeans t-tests;
proc glm data = prostatedata;
class gleason;
model logpsa = gleason;
lsmeans gleason/ adjust = bon pdiff;
run;
