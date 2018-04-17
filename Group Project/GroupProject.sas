/* Import the train data */
/* SAS Encountered errors with MasVnrArea and GarageYrBlt due to "NA" in Numeric Fields. SAS set the "NA" values to "." Therefore no issues for now */
%web_drop_table(WORK.TRAIN);
FILENAME REFFILE '/folders/myshortcuts/StatisticalFoundations/Group Project/train.csv';
PROC IMPORT DATAFILE=REFFILE
	DBMS=CSV
	OUT=WORK.TRAIN;
	GETNAMES=YES;
RUN;
PROC CONTENTS DATA=WORK.TRAIN; RUN;
%web_open_table(WORK.TRAIN);

/* Analysis Question 2 */

	/* Correct Skew in Saleprice (log) looking much more normal and consistent with what stacy did for Q1*/
	data Q2TRAIN; 
	set WORK.TRAIN; 
	logSalePrice = log(SalePrice);
	run;

/* Variable Selection Models */
	/* Looking for Large R^2 and small CV Press */
	/* Forward */
	proc glmselect data =Q2TRAIN plots=all;
	class MSZoning Street Alley LotShape LandContour Utilities LotConfig LandSlope Neighborhood Condition1 Condition2 BldgType HouseStyle RoofStyle RoofMatl Exterior1st Exterior2nd MasVnrType ExterQual ExterCond Foundation BsmtQual BsmtCond BsmtExposure BsmtFinType1 BsmtFinType2
	Heating HeatingQC CentralAir Electrical KitchenQual Functional FireplaceQu GarageType GarageFinish GarageQual GarageCond PavedDrive PoolQC Fence MiscFeature SaleType SaleCondition;
	model logSalePrice = MSSubClass MSZoning LotArea Street Alley LotShape LandContour Utilities LotConfig LandSlope Neighborhood Condition1 Condition2 BldgType HouseStyle OverallQual
	OverallCond YearBuilt YearRemodAdd RoofStyle RoofMatl Exterior1st Exterior2nd MasVnrType MasVnrArea ExterQual ExterCond Foundation BsmtQual BsmtCond BsmtExposure BsmtFinType1 BsmtFinSF1 
	BsmtFinType2 BsmtFinSF2 BsmtUnfSF TotalBsmtSF Heating HeatingQC CentralAir Electrical _1stFlrSF _2ndFlrSF LowQualFinSF GrLivArea BsmtFullBath BsmtHalfBath FullBath HalfBath BedroomAbvGr 
	KitchenAbvGr KitchenQual TotRmsAbvGrd Functional Fireplaces FireplaceQu GarageType GarageYrBlt GarageFinish GarageCars GarageArea GarageQual GarageCond PavedDrive WoodDeckSF OpenPorchSF 
	EnclosedPorch _3SsnPorch ScreenPorch PoolArea PoolQC Fence MiscFeature MiscVal MoSold YrSold SaleType SaleCondition
	/selection =Forward (stop=CV) cvmethod=random(5) stats=adjrsq; 
	
	/* Backward */
	proc glmselect data =Q2TRAIN plots=all;
	class MSZoning Street Alley LotShape LandContour Utilities LotConfig LandSlope Neighborhood Condition1 Condition2 BldgType HouseStyle RoofStyle RoofMatl Exterior1st Exterior2nd MasVnrType ExterQual ExterCond Foundation BsmtQual BsmtCond BsmtExposure BsmtFinType1 BsmtFinType2
	Heating HeatingQC CentralAir Electrical KitchenQual Functional FireplaceQu GarageType GarageFinish GarageQual GarageCond PavedDrive PoolQC Fence MiscFeature SaleType SaleCondition;
	model logSalePrice = MSSubClass MSZoning LotArea Street Alley LotShape LandContour Utilities LotConfig LandSlope Neighborhood Condition1 Condition2 BldgType HouseStyle OverallQual
	OverallCond YearBuilt YearRemodAdd RoofStyle RoofMatl Exterior1st Exterior2nd MasVnrType MasVnrArea ExterQual ExterCond Foundation BsmtQual BsmtCond BsmtExposure BsmtFinType1 BsmtFinSF1 
	BsmtFinType2 BsmtFinSF2 BsmtUnfSF TotalBsmtSF Heating HeatingQC CentralAir Electrical _1stFlrSF _2ndFlrSF LowQualFinSF GrLivArea BsmtFullBath BsmtHalfBath FullBath HalfBath BedroomAbvGr 
	KitchenAbvGr KitchenQual TotRmsAbvGrd Functional Fireplaces FireplaceQu GarageType GarageYrBlt GarageFinish GarageCars GarageArea GarageQual GarageCond PavedDrive WoodDeckSF OpenPorchSF 
	EnclosedPorch _3SsnPorch ScreenPorch PoolArea PoolQC Fence MiscFeature MiscVal MoSold YrSold SaleType SaleCondition
	/selection =backward (stop=CV) cvmethod=random(5) stats=adjrsq;
	
	/* Stepwise */
	proc glmselect data =Q2TRAIN plots=all;
	class MSZoning Street Alley LotShape LandContour Utilities LotConfig LandSlope Neighborhood Condition1 Condition2 BldgType HouseStyle RoofStyle RoofMatl Exterior1st Exterior2nd MasVnrType ExterQual ExterCond Foundation BsmtQual BsmtCond BsmtExposure BsmtFinType1 BsmtFinType2
	Heating HeatingQC CentralAir Electrical KitchenQual Functional FireplaceQu GarageType GarageFinish GarageQual GarageCond PavedDrive PoolQC Fence MiscFeature SaleType SaleCondition;
	model logSalePrice = MSSubClass MSZoning LotArea Street Alley LotShape LandContour Utilities LotConfig LandSlope Neighborhood Condition1 Condition2 BldgType HouseStyle OverallQual
	OverallCond YearBuilt YearRemodAdd RoofStyle RoofMatl Exterior1st Exterior2nd MasVnrType MasVnrArea ExterQual ExterCond Foundation BsmtQual BsmtCond BsmtExposure BsmtFinType1 BsmtFinSF1 
	BsmtFinType2 BsmtFinSF2 BsmtUnfSF TotalBsmtSF Heating HeatingQC CentralAir Electrical _1stFlrSF _2ndFlrSF LowQualFinSF GrLivArea BsmtFullBath BsmtHalfBath FullBath HalfBath BedroomAbvGr 
	KitchenAbvGr KitchenQual TotRmsAbvGrd Functional Fireplaces FireplaceQu GarageType GarageYrBlt GarageFinish GarageCars GarageArea GarageQual GarageCond PavedDrive WoodDeckSF OpenPorchSF 
	EnclosedPorch _3SsnPorch ScreenPorch PoolArea PoolQC Fence MiscFeature MiscVal MoSold YrSold SaleType SaleCondition
	/selection =stepwise (stop=CV)  cvmethod=random(5) stats=adjrsq;

/* Assumptions */
	/* 	Forward Selected */
	proc glm data=Q2TRAIN plots=all;
	class Neighborhood;
	model logSalePrice = Neighborhood OverallQual BsmtFinSF1 GrLivArea /solution;
	
	/* 	Backward Selected */
	proc glm data=Q2TRAIN plots=all;
	class MSZoning Street Alley LotShape LandContour Utilities LotConfig LandSlope Neighborhood Condition1 Condition2 BldgType HouseStyle RoofStyle RoofMatl Exterior1st Exterior2nd MasVnrType ExterQual ExterCond Foundation BsmtQual BsmtCond BsmtExposure BsmtFinType1 BsmtFinType2
	Heating HeatingQC CentralAir Electrical KitchenQual Functional FireplaceQu GarageType GarageFinish GarageQual GarageCond PavedDrive PoolQC Fence MiscFeature SaleType SaleCondition;
	model logSalePrice = MSSubClass MSZoning LotArea Street Alley LotShape LandContour Utilities LotConfig LandSlope Neighborhood Condition1 Condition2 BldgType HouseStyle
	OverallQual OverallCond YearBuilt YearRemodAdd RoofStyle RoofMatl Exterior1st Exterior2nd MasVnrType MasVnrArea ExterQual ExterCond Foundation BsmtQual BsmtCond 
	BsmtExposure BsmtFinType1 BsmtFinSF1 BsmtFinType2 BsmtFinSF2 BsmtUnfSF Heating HeatingQC CentralAir Electrical _1stFlrSF _2ndFlrSF LowQualFinSF BsmtFullBath BsmtHalfBath
	FullBath HalfBath BedroomAbvGr KitchenAbvGr KitchenQual TotRmsAbvGrd Functional Fireplaces FireplaceQu GarageType GarageYrBlt GarageFinish GarageCars GarageArea 
	GarageQual GarageCond PavedDrive WoodDeckSF OpenPorchSF EnclosedPorch _3SsnPorch ScreenPorch PoolArea PoolQC Fence MiscFeature MiscVal MoSold YrSold SaleType SaleCondition /solution;
	
	/* 	Stepwise Selected */
	proc glm data=Q2TRAIN plots=all;
	class Neighborhood BldgType RoofMatl;
	model logSalePrice = Neighborhood BldgType OverallQual OverallCond YearBuilt RoofMatl BsmtFinSF1 TotalBsmtSF GrLivArea/ solution;

/* 	Custom */
	/* Check for normality in non-categorical variables*/
	/* proc sgscatter data=work.import; /*Too many variables to really make sense of the graphics but it works */
	/* matrix LotArea YearBuilt YearRemodAdd MasVnrArea BsmtFinSF1 BsmtFinSF2 BsmtUnfSF TotalBsmtSF _1stFlrSF _2ndFlrSF LowQualFinSF GrLivArea TotRmsAbvGrd GarageYrBlt GarageArea WoodDeckSF OpenPorchSF EnclosedPorch _3SsnPorch ScreenPorch PoolArea MiscVal SalePrice; */
	/* 	proc glm since categorical variables */
	/* remove extreme outliers and fix "NA" in lotfrontage */
	data Q2CUSTOMTRAIN; 
	set Q2TRAIN; 
	logSalePrice = log(SalePrice);
	if LotArea > 100000 then delete;
	if GrLivArea = 5642 then delete;
	if lotfrontage = "NA" then lotfrontage = .;
	
	/* Run again with log saleprice and extreme outliers removed. Cooks D and Studentized residuals are looking better. Give up on lotfrontage variable*/
	proc reg data=Q2CUSTOMTRAIN;
	model logSalePrice = LotArea YearBuilt YearRemodAdd MasVnrArea BsmtFinSF1 BsmtFinSF2 BsmtUnfSF TotalBsmtSF _1stFlrSF _2ndFlrSF LowQualFinSF
	 GrLivArea TotRmsAbvGrd GarageYrBlt GarageArea WoodDeckSF OpenPorchSF EnclosedPorch _3SsnPorch ScreenPorch PoolArea MiscVal /VIF;

	/* Run again with log saleprice and extreme outliers removed. Cooks D looks good. Studentized residuals are a mess probably due to colinearity among variables. Give up on lotfrontage variable*/
	proc glm data=Q2CUSTOMTRAIN plots=all;
	class MSZoning Street Alley LotShape LandContour Utilities LotConfig LandSlope Neighborhood Condition1 Condition2 BldgType HouseStyle RoofStyle RoofMatl Exterior1st Exterior2nd MasVnrType ExterQual ExterCond Foundation BsmtQual BsmtCond BsmtExposure BsmtFinType1 BsmtFinType2
	Heating HeatingQC CentralAir Electrical KitchenQual Functional FireplaceQu GarageType GarageFinish GarageQual GarageCond PavedDrive PoolQC Fence MiscFeature SaleType SaleCondition;
	model logSalePrice = MSSubClass MSZoning LotArea Street Alley LotShape LandContour Utilities LotConfig LandSlope Neighborhood Condition1 Condition2 BldgType HouseStyle OverallQual
	OverallCond YearBuilt YearRemodAdd RoofStyle RoofMatl Exterior1st Exterior2nd MasVnrType MasVnrArea ExterQual ExterCond Foundation BsmtQual BsmtCond BsmtExposure BsmtFinType1 BsmtFinSF1 
	BsmtFinType2 BsmtFinSF2 BsmtUnfSF TotalBsmtSF Heating HeatingQC CentralAir Electrical _1stFlrSF _2ndFlrSF LowQualFinSF GrLivArea BsmtFullBath BsmtHalfBath FullBath HalfBath BedroomAbvGr 
	KitchenAbvGr KitchenQual TotRmsAbvGrd Functional Fireplaces FireplaceQu GarageType GarageYrBlt GarageFinish GarageCars GarageArea GarageQual GarageCond PavedDrive WoodDeckSF OpenPorchSF 
	EnclosedPorch _3SsnPorch ScreenPorch PoolArea PoolQC Fence MiscFeature MiscVal MoSold YrSold SaleType SaleCondition /solution;



	/* proc glmselect data=work.import testdata=work.Q2test plots(stepaxis = number) = (criterionpanel ASEPlot); */
	/* model SalePrice = LotArea YearBuilt YearRemodAdd MasVnrArea BsmtFinSF1 BsmtFinSF2 BsmtUnfSF TotalBsmtSF _1stFlrSF _2ndFlrSF LowQualFinSF */
	/*  GrLivArea TotRmsAbvGrd GarageYrBlt GarageArea WoodDeckSF OpenPorchSF EnclosedPorch _3SsnPorch ScreenPorch PoolArea MiscVal / */
	/*  selection=stepwise(select = sl stop = sl slentry = .15 sls = .15); */


/* Predictions */
	/* Import the test data */
	%web_drop_table(WORK.TEST);
	FILENAME REFFILE '/folders/myshortcuts/StatisticalFoundations/Group Project/test.csv';
	PROC IMPORT DATAFILE=REFFILE
		DBMS=CSV
		OUT=WORK.TEST;
		GETNAMES=YES;
	RUN;
	PROC CONTENTS DATA=WORK.TEST; RUN;
	%web_open_table(WORK.TEST);
	
	/* Add Saleprice column to test data */
	data Q2TEST; 
	set WORK.TEST; 
	SalePrice = .;
	run;
	
	/* Combine the train and test data */
	data Q2PREDICT;
	set  WORK.Q2TRAIN WORK.Q2TEST;
	run;

/* Forward */
	proc glm data = Q2PREDICT plots=all;
	class Neighborhood;
	model logSalePrice = Neighborhood OverallQual BsmtFinSF1 GrLivArea /cli solution;
	output out = ForwardSelectedresults p = Predict;
	run;
	
	data ForwardSelectedresults;
	set ForwardSelectedresults;
	predictedSalePrice = logsaleprice;
	keep id Predict saleprice logsaleprice predictedSalePrice;
	
	proc print data=ForwardSelectedresults;


/* Backward */
	proc glm data = Q2PREDICT plots=all;
	class MSZoning Street Alley LotShape LandContour Utilities LotConfig LandSlope Neighborhood Condition1 Condition2 BldgType HouseStyle RoofStyle RoofMatl Exterior1st Exterior2nd MasVnrType ExterQual ExterCond Foundation BsmtQual BsmtCond BsmtExposure BsmtFinType1 BsmtFinType2
	Heating HeatingQC CentralAir Electrical KitchenQual Functional FireplaceQu GarageType GarageFinish GarageQual GarageCond PavedDrive PoolQC Fence MiscFeature SaleType SaleCondition;
	model logSalePrice = MSSubClass MSZoning LotArea Street Alley LotShape LandContour Utilities LotConfig LandSlope Neighborhood Condition1 Condition2 BldgType HouseStyle
	OverallQual OverallCond YearBuilt YearRemodAdd RoofStyle RoofMatl Exterior1st Exterior2nd MasVnrType MasVnrArea ExterQual ExterCond Foundation BsmtQual BsmtCond 
	BsmtExposure BsmtFinType1 BsmtFinSF1 BsmtFinType2 BsmtFinSF2 BsmtUnfSF Heating HeatingQC CentralAir Electrical _1stFlrSF _2ndFlrSF LowQualFinSF BsmtFullBath BsmtHalfBath
	FullBath HalfBath BedroomAbvGr KitchenAbvGr KitchenQual TotRmsAbvGrd Functional Fireplaces FireplaceQu GarageType GarageYrBlt GarageFinish GarageCars GarageArea 
	GarageQual GarageCond PavedDrive WoodDeckSF OpenPorchSF EnclosedPorch _3SsnPorch ScreenPorch PoolArea PoolQC Fence MiscFeature MiscVal MoSold YrSold SaleType SaleCondition  /cli solution;
	output out = BackwardSelectedresults p = Predict;
	run;
	
	data BackwardSelectedresults;
	set BackwardSelectedresults;
	predictedSalePrice = logsaleprice;
	keep id Predict saleprice logsaleprice predictedSalePrice;
	
	proc print data=BackwardSelectedresults;
/* Stepwise */
	proc glm data = Q2PREDICT plots=all;
	class Neighborhood BldgType RoofMatl;
	model logSalePrice = Neighborhood BldgType OverallQual OverallCond YearBuilt RoofMatl BsmtFinSF1 TotalBsmtSF GrLivArea
	 /cli solution;
	output out = StepwiseSelectedresults p = Predict;
	run;
	
	data StepwiseSelectedresults;
	set StepwiseSelectedresults;
	predictedSalePrice = logsaleprice;
	keep id Predict saleprice logsaleprice predictedSalePrice;
	
	proc print data=StepwiseSelectedresults;














/* Custom  Remember to check diagnostics */

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
