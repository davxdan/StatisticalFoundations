data law;
infile '/folders/myshortcuts/StatisticalFoundations/FinalExam/Moores Law.csv' delimiter = ',' DSD MISSOVER firstobs=2;
input Processor: $100. TransistorCount Year Designer $ Process Areasqmm PastCurrent $ PastCurrentInd;
run;

proc print data=law;

proc sort data=law;
by descending designer;


/* Compare the Transistor Count for Motorola and AMD.  */
data motoAMD;
infile '/folders/myshortcuts/StatisticalFoundations/FinalExam/motoAMD.csv' delimiter = ',' DSD MISSOVER firstobs=2;
input Processor: $100. TransistorCount Year Designer $ Process Areasqmm PastCurrent $ PastCurrentInd;
run;

PROC PRINT DATA=motoAMD;

Proc GLM data=motoAMD;
class designer;
model TransistorCount = designer;
means designer;



/* proc sgplot data=motoAMD; */
/* scatter x=Year y=TransistorCount / group=designer; */
/* ellipse x=Year y=TransistorCount; */
/*  */

proc npar1way data = motoAMD Wilcoxon alpha=.1;
var TransistorCount;
class designer;
run;


/* Provide 2 Scatter Plots */
proc sgpanel data=motoAMD;
panelby designer;
reg x=Year y=TransistorCount / group=designer alpha = .1;

data motoAMDlogy;
set motoAMD;
LogTransistorCount = log(TransistorCount);

proc sgpanel data=motoAMDlogy;
panelby designer;
reg x=Year y=LogTransistorCount / group=designer alpha = .1 CLM CLI;

/* Consider only the data up to and including 2009. */
data UpIncluding2009; 
set law; 
if Year > 2009 then delete;
LogTransistorCount = log(TransistorCount);
proc print data=UpIncluding2009;

/*   Fit the log (base e) of the number of transistors (response) against the year the chip was made (explanatory).  */
proc glm data= UpIncluding2009 plots = all;
model LogTransistorCount = Year / clparm solution alpha=.1;
run;


/* With the addition of this column, build and fit a model to test if the rate of increase of the current transistor count has significantly decreased from the “past” to the “current” time period. */
/* Use the logged response variable. */
/* You do NOT need to address diagnostics/assumptions for this question. */

data lawlogy; 
set law; 
LogTransistorCount = log(TransistorCount);
proc print data=lawlogy;


proc glm data= lawlogy plots = all;
class PastCurrent (Ref = "Past");
model LogTransistorCount = PastCurrent Year / clparm solution alpha=.1;
run;


/* Predict */
proc reg data=lawlogy;

model LogTransistorCount = Year /selection = cp;

