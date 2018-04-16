/* Import the train data */
/* SAS Encountered errors with MasVnrArea and GarageYrBlt due to "NA" in Numeric Fields. SAS set the "NA" values to "." Therefore no issues for now */
%web_drop_table(WORK.IMPORT);
FILENAME REFFILE '/folders/myshortcuts/StatisticalFoundations/Group Project/train.csv';
PROC IMPORT DATAFILE=REFFILE
	DBMS=CSV
	OUT=WORK.IMPORT;
	GETNAMES=YES;
RUN;
PROC CONTENTS DATA=WORK.IMPORT; RUN;
%web_open_table(WORK.IMPORT);



/* Import the test data */
%web_drop_table(WORK.IMPORT1);
FILENAME REFFILE '/folders/myshortcuts/StatisticalFoundations/Group Project/test.csv';
PROC IMPORT DATAFILE=REFFILE
	DBMS=CSV
	OUT=WORK.IMPORT1;
	GETNAMES=YES;
RUN;
PROC CONTENTS DATA=WORK.IMPORT1; RUN;
%web_open_table(WORK.IMPORT1);

/* Add Saleprice column to test data */
data Q2test; 
set work.import1; 
SalePrice = .;
run;

/* Combine the train and test data */
data Q2;
set  work.import work.q2test;
run;

/* Analysis Question 2 */
/* Check for normality in non-categorical variables*/
/* proc sgscatter data=work.import; /*Too many variables to really make sense of the graphics but it works */
/* matrix LotArea YearBuilt YearRemodAdd MasVnrArea BsmtFinSF1 BsmtFinSF2 BsmtUnfSF TotalBsmtSF _1stFlrSF _2ndFlrSF LowQualFinSF GrLivArea TotRmsAbvGrd GarageYrBlt GarageArea WoodDeckSF OpenPorchSF EnclosedPorch _3SsnPorch ScreenPorch PoolArea MiscVal SalePrice; */

/* Run with all variables just like Dr.MGee */
proc reg data=Q2;
model SalePrice = LotArea YearBuilt YearRemodAdd MasVnrArea BsmtFinSF1 BsmtFinSF2 BsmtUnfSF TotalBsmtSF _1stFlrSF _2ndFlrSF LowQualFinSF
 GrLivArea TotRmsAbvGrd GarageYrBlt GarageArea WoodDeckSF OpenPorchSF EnclosedPorch _3SsnPorch ScreenPorch PoolArea MiscVal /VIF;

/*Big outliers so Look at saleprice alone */
proc univariate data= work.Q2;
QQPLOT SalePrice;
HIST SalePrice;

/* Correct Skew in Saleprice (log) looking much more normal and consistent with what stacy did for Q1*/
data Q2; 
set Q2; 
logSalePrice = log(SalePrice);

/* Run with all variables again with logsaleprice */
proc reg data=Q2;
model logSalePrice = LotArea YearBuilt YearRemodAdd MasVnrArea BsmtFinSF1 BsmtFinSF2 BsmtUnfSF TotalBsmtSF _1stFlrSF _2ndFlrSF LowQualFinSF
 GrLivArea TotRmsAbvGrd GarageYrBlt GarageArea WoodDeckSF OpenPorchSF EnclosedPorch _3SsnPorch ScreenPorch PoolArea MiscVal /VIF;

/* remove extreme outliers */
data Q2; 
set work.Q2; 
logSalePrice = log(SalePrice);
if LotArea > 100000 then delete;
if GrLivArea = 5642 then delete;

/* Run again with log saleprice and extreme outliers removed. Cooks D and Studentized residuals are looking better*/
proc reg data=Q2;
model logSalePrice = LotArea YearBuilt YearRemodAdd MasVnrArea BsmtFinSF1 BsmtFinSF2 BsmtUnfSF TotalBsmtSF _1stFlrSF _2ndFlrSF LowQualFinSF
 GrLivArea TotRmsAbvGrd GarageYrBlt GarageArea WoodDeckSF OpenPorchSF EnclosedPorch _3SsnPorch ScreenPorch PoolArea MiscVal /VIF;







/* Models */
/* Looking for Large R^2 and small CV Press */
/* Forward */
proc glmselect data =Q2;
model logSalePrice = LotArea YearBuilt YearRemodAdd MasVnrArea BsmtFinSF1 BsmtFinSF2 BsmtUnfSF TotalBsmtSF  _2ndFlrSF LowQualFinSF 
GrLivArea  GarageYrBlt GarageArea WoodDeckSF OpenPorchSF EnclosedPorch _3SsnPorch ScreenPorch PoolArea MiscVal
/selection =Forward (stop=CV) stats=adjrsq; 

/* Backward */
proc glmselect data =q2;
model logSalePrice = LotArea YearBuilt YearRemodAdd MasVnrArea BsmtFinSF1 BsmtFinSF2 BsmtUnfSF TotalBsmtSF  _2ndFlrSF LowQualFinSF 
GrLivArea  GarageYrBlt GarageArea WoodDeckSF OpenPorchSF EnclosedPorch _3SsnPorch ScreenPorch PoolArea MiscVal
/selection =backward (stop=CV) cvmethod=random(5) stats=adjrsq;

/* Stepwise */
proc glmselect data =q2;
model logSalePrice = LotArea YearBuilt YearRemodAdd MasVnrArea BsmtFinSF1 BsmtFinSF2 BsmtUnfSF TotalBsmtSF  _2ndFlrSF LowQualFinSF 
GrLivArea  GarageYrBlt GarageArea WoodDeckSF OpenPorchSF EnclosedPorch _3SsnPorch ScreenPorch PoolArea MiscVal
/selection =stepwise (stop=CV) cvmethod=random(5) stats=adjrsq;

/* Check diagnostics */


/* Maybe save for custom model */
/* Run again with log saleprice and extreme outliers removed. Also removed _1stFlrSF and TotRmsAbvGrd since because they have extreme outliers and high VIF colinearity with GrLivArea anyway. Keep GrLiveArea because it has lowest variance*/
/* Cooks D looking much better. Noted tha there are some variables such as BsmtFinSF have high VIF. These probably need to be categorized since not all homes will have finished basements  */
proc reg data=Q2;
model logSalePrice = LotArea YearBuilt YearRemodAdd MasVnrArea BsmtFinSF1 BsmtFinSF2 BsmtUnfSF TotalBsmtSF  _2ndFlrSF LowQualFinSF
 GrLivArea  GarageYrBlt GarageArea WoodDeckSF OpenPorchSF EnclosedPorch _3SsnPorch ScreenPorch PoolArea MiscVal / selection=cp VIF;




proc univariate data=work.import; /*reveals more categorical variables. For example some homes have no BsmtFinSF1 while others do so I am ignoring these for now*/
QQPLOT LotArea YearBuilt YearRemodAdd MasVnrArea BsmtFinSF1 BsmtFinSF2 BsmtUnfSF TotalBsmtSF _1stFlrSF _2ndFlrSF LowQualFinSF GrLivArea TotRmsAbvGrd GarageYrBlt GarageArea WoodDeckSF OpenPorchSF EnclosedPorch _3SsnPorch ScreenPorch PoolArea MiscVal SalePrice; 

/* Purely measurable non categorical variables are: LotArea Year Built _1stFlrSF GrLivArea TotRmsAbvGrd SalePrice. Now to check normality on them. */
proc sgscatter data=work.import; 
matrix LotArea YearBuilt _1stFlrSF GrLivArea TotRmsAbvGrd SalePrice;

proc univariate data=work.import; 
QQPLOT LotArea YearBuilt _1stFlrSF GrLivArea TotRmsAbvGrd SalePrice;
HIST LotArea YearBuilt _1stFlrSF GrLivArea TotRmsAbvGrd SalePrice;







/* Correct Values in MasVnrArea and GarageYrBlt by converting to text and setting category to "None" */
/* 	From Descriptions: */
/* 		MasVnrArea:  Masonry veneer area in square feet */
/* 		GarageYrBlt: Year garage was built */
/* data Q2; */
/* set work.import; */
/* if GarageYrBlt = . then GarageYearBuilt = "None"; */
/* else GarageYearBuilt = GarageYrBlt; */
/* if MasVnrArea = . then MasonryVenirArea = "None"; */
/* else MasonryVenirArea = MasVnrArea; */
/* run; */

/* Analysis Question 1  */
/* 	GrLivArea: Above grade (ground) living area square feet  */
/* 	Neighborhood: Physical locations within Ames city limits  */
/* 	BrkSide	Brookside  */
/* 	Edwards	Edwards  */
/* 	Names	North Ames  */
/*  */
/* %web_drop_table(WORK.IMPORT);  */
/* FILENAME REFFILE '/folders/myshortcuts/StatisticalFoundations/Group Project/train.csv';  */
/* PROC IMPORT DATAFILE=REFFILE  */
/* 	DBMS=CSV  */
/* 	OUT=WORK.IMPORT;  */
/* 	GETNAMES=YES;  */
/*  */
/* data Q1;  */
/* set work.import (keep = GrLivArea  SalePrice Neighborhood);  */
/* if Neighborhood NOT = "BrkSide" AND  Neighborhood NOT = "Edwards" AND  Neighborhood NOT = "NAmes" then delete;  */
/* run;  */
/*   */
/* Fit  */
/* proc sgplot data=Q1;   */
/* scatter x=GrLivArea y=SalePrice / group=Neighborhood;   */
/* ellipse  x=GrLivArea y=SalePrice;  */
/* proc sgpanel data=Q1;  */
/* panelby Neighborhood;  */
/* reg x=GrLivArea y=SalePrice / group=Neighborhood alpha = .05 CLM CLI;  */
/* Slopes are clearly different. So use separate slopes model   */
/* proc glm data=Q1 plots=all;   */
/* class Neighborhood  (REF="BrkSide");   */
/* model SalePrice = Neighborhood | GrLivArea /solution clparm alpha = .05;   */
/* Right Skew in Saleprice  */
/* proc univariate data = Q1;  */
/* HISTOGRAM SalePrice;  */
/* QQPLOT SalePrice;  */
/*   */
/* Correct Skew in Saleprice Transform y (sqrt)  */
/* data Q1sqrt;  */
/* set Q1;  */
/* sqrtSalePrice = sqrt(SalePrice);  */
/* proc univariate data = Q1sqrt;  */
/* HISTOGRAM sqrtSalePrice;  */
/* QQPLOT sqrtSalePrice;  */
/* proc sgplot data=Q1sqrt;   */
/* scatter x=GrLivArea y=sqrtSalePrice / group=Neighborhood;   */
/* ellipse  x=GrLivArea y=sqrtSalePrice;  */
/* proc sgpanel data=Q1sqrt;  */
/* panelby Neighborhood;  */
/* reg x=GrLivArea y=sqrtSalePrice / group=Neighborhood alpha = .05 CLM CLI;  */
/* proc glm data=Q1sqrt;   */
/* class Neighborhood  (REF="BrkSide");   */
/* model sqrtSalePrice = Neighborhood | GrLivArea /solution clparm alpha = .05;   */
/* proc univariate data = Q1sqrt;  */
/* HISTOGRAM sqrtSalePrice;  */
/* QQPLOT sqrtSalePrice;  */
/* HISTOGRAM GrLivArea;  */
/* QQPLOT GrLivArea;  */
/*   */
/* GrLivArea Outliers in Edwards are ruining everything so lets report with and without them  */
/* data Q1sqrtOl;  */
/* set Q1;  */
/* sqrtSalePrice = sqrt(SalePrice);  */
/* if GrLivArea > 3500 then delete;  */
/* proc univariate data = Q1sqrtOl;  */
/* HISTOGRAM sqrtSalePrice;  */
/* QQPLOT sqrtSalePrice;  */
/* HISTOGRAM GrLivArea;  */
/* QQPLOT GrLivArea;  */
/* proc sgplot data=Q1sqrtOl;   */
/* scatter x=GrLivArea y=sqrtSalePrice / group=Neighborhood;   */
/* ellipse  x=GrLivArea y=sqrtSalePrice;  */
/* proc sgpanel data=Q1sqrtOl;  */
/* panelby Neighborhood;  */
/* reg x=GrLivArea y=sqrtSalePrice / group=Neighborhood alpha = .05 CLM CLI;  */
/* Model  */
/* proc glm data=Q1sqrtOl plots=all;   */
/* class Neighborhood  (REF="BrkSide");   */
/* model sqrtSalePrice = Neighborhood | GrLivArea /solution clparm alpha = .05;  */
/* Model  */
/*   */
/*   */
/* Square footage still causing a mess so try log of x    */
/* data Q1sqrtOllogx;  */
/* set Q1;  */
/* sqrtSalePrice = sqrt(SalePrice);  */
/* if GrLivArea > 3500 then delete;  */
/* logGrLivArea = log(GrLivArea);  */
/* proc univariate data = Q1sqrtOllogx;  */
/* HISTOGRAM sqrtSalePrice;  */
/* QQPLOT sqrtSalePrice;  */
/* HISTOGRAM logGrLivArea;  */
/* QQPLOT logGrLivArea;  */
/*   */
/* proc sgplot data=Q1sqrtOllogx;   */
/* scatter x=logGrLivArea y=sqrtSalePrice / group=Neighborhood;   */
/* ellipse  x=logGrLivArea y=sqrtSalePrice;  */
/*   */
/* proc sgpanel data=Q1sqrtOllogx;  */
/* panelby Neighborhood;  */
/* reg x=logGrLivArea y=sqrtSalePrice / group=Neighborhood alpha = .05 CLM CLI;  */
/*   */
/* Use separate Slopes Model  */
/* proc glm data=Q1sqrtOllogx plots=all;   */
/* class Neighborhood  (REF="BrkSide");   */
/* model sqrtSalePrice = Neighborhood | logGrLivArea /solution clparm alpha = .05;  */
