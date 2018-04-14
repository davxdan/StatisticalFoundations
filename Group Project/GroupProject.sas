/* Generated Code (IMPORT) */
/* Source File: train.csv */
/* Source Path: /folders/myshortcuts/StatisticalFoundations/Group Project */
/* Code generated on: 4/14/18, 8:39 AM */

%web_drop_table(WORK.IMPORT);
FILENAME REFFILE '/folders/myshortcuts/StatisticalFoundations/Group Project/train.csv';
PROC IMPORT DATAFILE=REFFILE
	DBMS=CSV
	OUT=WORK.IMPORT;
	GETNAMES=YES;

RUN;
PROC CONTENTS DATA=WORK.IMPORT; RUN;
%web_open_table(WORK.IMPORT);

/* Analysis Question 1 */

/* GrLivArea: Above grade (ground) living area square feet */

/* Neighborhood: Physical locations within Ames city limits */
/*        BrkSide	Brookside */
/*        Edwards	Edwards */
/*        Names	North Ames */

data Q1;
set work.import;
if Neighborhood NOT = "BrkSide" AND  Neighborhood NOT = "Edwards" AND  Neighborhood NOT = "NAmes" then delete; 
IF Neighborhood = "BrkSide" THEN 1 
run;

proc sgscatter data=Q1;
matrix GrLivArea  SalePrice / group=Neighborhood;

proc sgplot data=Q1;
scatter x=GrLivArea y=SalePrice / group=Neighborhood;

proc sgpanel data=Q1;
panelby Neighborhood;
reg x=GrLivArea y=SalePrice / group=Neighborhood alpha = .05 CLM CLI;

proc glm data=work.crabsraw plots = all;
class Species;
Model Force = Height Species / Solution alpha = .05;


proc glm data= work.Q1 plots = all;
class  Neighborhood;
model SalePrice = neighborhood  GrLivArea/ Solution alpha = .05;

proc reg data= Q1;
model Saleprice = GrLivArea neighborhood / COVB;


