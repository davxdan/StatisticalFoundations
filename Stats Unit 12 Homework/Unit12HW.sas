%web_drop_table(WORK.CrabsRaw);
FILENAME REFFILE '/folders/myshortcuts/StatisticalFoundations/Stats Unit 12 Homework/unit12data/Archive/Crab17.csv';
PROC IMPORT DATAFILE=REFFILE
	DBMS=CSV
	OUT=WORK.CrabsRaw;
	GETNAMES=YES;

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
reg x=Force y=Height / group=Species CLM CLI;

/* goptions reset=all border; */
/* title="Surface PLot"; */
/* proc g3grid  data=work.crabsraw out=CrabGrid; */
/* 	grid Force*Height=Species / */
/* 	axis1=0 to 30 by 1 */
/* 	axis2=0 to 30 by 1; */
/* 	run; */
/* quit; */
/*  */
/* proc g3d data=CrabGrid; */
/* plot Force*Height=Species; */
/* run; */
/* quit; */






