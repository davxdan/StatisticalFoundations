%web_drop_table(WORK.CrabsRaw);
FILENAME REFFILE '/folders/myshortcuts/StatisticalFoundations/Stats Unit 12 Homework/unit12data/Archive/Crab17.csv';
PROC IMPORT DATAFILE=REFFILE
	DBMS=CSV
	OUT=WORK.CrabsRaw;
	GETNAMES=YES;

proc sort data=work.crabsraw;
by descending Species;

proc sgplot data=work.crabsraw;
scatter x=Height y=Force / group=Species;
ellipse x=Height y=Force;

proc sgplot data=work.crabsraw;
reg x=Height y=Force  / alpha = .05 group=Species CLM CLI;

proc sgplot data=work.crabsraw;
reg x=Height y=Force  / alpha = .05 group=Species CLM;

proc sgscatter data=work.crabsraw;
matrix Force Height / group=Species;

proc sgscatter data=work.crabsraw;
plot Force*Height / group=Species pbspline;

proc sgpanel data=work.crabsraw;
panelby Species;
reg x=Height y=Force / group=Species alpha = .05 CLM CLI;


proc glm data=work.crabsraw;
class Species (REF="Lophopanopeus bel");
model Force = Species | Height /solution;


proc glm data=work.crabsraw plots = all;
class Species;
Model Force = Height Species / Solution alpha = .05;


/* transform y (log) */
data CrabsLogy;
set crabsraw;
LogForce = log(Force);

proc sort data=work.crabslogy;
by descending Species;

proc sgplot data=work.crabslogy;
scatter x=Height y=LogForce / group=Species;
ellipse x=Height y=LogForce;

proc sgplot data=work.crabslogy;
reg x=Height y=LogForce  / alpha = .05 group=Species CLM CLI;

proc sgplot data=work.crabslogy;
reg x=Height y=LogForce  / alpha = .05 group=Species CLM;

proc sgscatter data=work.crabslogy;
matrix LogForce Height / group=Species;

proc sgscatter data=work.crabslogy;
plot LogForce*Height / group=Species pbspline;

proc sgpanel data=work.crabslogy;
panelby Species;
reg x=Height y=LogForce / group=Species alpha = .05 CLM CLI;


proc glm data=work.crabslogy;
class Species (REF="Lophopanopeus bel");
model LogForce = Species | Height /solution;


proc glm data=work.crabslogy plots = all;
class Species;
Model LogForce = Height Species / Solution alpha = .05;



