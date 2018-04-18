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
	model logSalePrice = Neighborhood BldgType OverallQual OverallCond YearBuilt RoofMatl BsmtFinSF1 TotalBsmtSF GrLivArea/ solution ;

	/* 	Custom */
	/* 	See if we can improve stepwise */
		data Q2CUSTOMTRAIN; 
		set Q2TRAIN; 
		logSalePrice = log(SalePrice);
		if LotArea > 100000 then delete;
		if GrLivArea > 5641 then delete;
		
		/* 	Check for colinearity in variables */
		proc SGSCATTER data=Q2CUSTOMTRAIN;
		matrix 	 Neighborhood BldgType OverallQual OverallCond YearBuilt RoofMatl BsmtFinSF1 TotalBsmtSF GrLivArea;

		/* 	Check for variable Inflation */	
		proc reg data=Q2CUSTOMTRAIN;
		model logSalePrice =  OverallQual OverallCond YearBuilt BsmtFinSF1 TotalBsmtSF GrLivArea / selection=cp VIF;
					
		proc glm data=Q2CUSTOMTRAIN plots=all;
		class Neighborhood BldgType RoofMatl;
		model logSalePrice = Neighborhood BldgType OverallQual OverallCond YearBuilt RoofMatl BsmtFinSF1 TotalBsmtSF GrLivArea/ solution;
		
		/* 		Try Custom Model		 */
		proc glmselect data =Q2CUSTOMTRAIN plots=all;
		class Neighborhood BldgType RoofMatl;
		model logSalePrice = Neighborhood BldgType OverallQual OverallCond YearBuilt RoofMatl BsmtFinSF1 TotalBsmtSF GrLivArea
		/selection =stepwise (stop=CV)  cvmethod=random(5) stats=adjrsq;

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

/* Custom */
	data Q2PREDICT;
	set  WORK.Q2CUSTOMTRAIN WORK.Q2TEST;
	run;
		
	proc glm data =Q2PREDICT plots=all;
	class Neighborhood BldgType RoofMatl;
	model logSalePrice = Neighborhood BldgType OverallQual OverallCond YearBuilt RoofMatl BsmtFinSF1 TotalBsmtSF GrLivArea
	/cli solution;
	output out = CustomSelectedresults p = Predict;
	run;
	
	data CustomSelectedresults;
	set CustomSelectedresults;
	predictedSalePrice = logsaleprice;
	keep id Predict saleprice logsaleprice predictedSalePrice;
	proc print data=CustomSelectedresults;
