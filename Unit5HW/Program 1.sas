
filename smile '/folders/myfolders/leniency.csv';
data smile;
infile smile firstobs = 2 delimiter=',';
input smile leniency;
if smile = 1 then type = 'False';
if smile = 2 then type = 'Genuine';
if smile = 3 then type = 'Miserable';
if smile = 4 then type = 'Neutral';
run;

Proc Print data=smile; run;
/* Always print the data to check that it has been */
/* entered correctly! */
Proc GLM data=smile;
class smile;
model leniency = smile;
run;

proc anova data=smile
class type;
model leniency= type;
run;