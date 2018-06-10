/* Import the train data */
FILENAME REFFILE 'C:\Users\danie\Documents\GitHub\Statistics\AppliedStatsGroupProject1\Train_v2_Subset_Scrubbed_Random20percent.csv';

PROC IMPORT DATAFILE=REFFILE DBMS=CSV OUT=WORK.TRAIN;
	GETNAMES=YES;
RUN;

PROC CONTENTS DATA=WORK.TRAIN;
RUN;



/* -----------------------------ANOVA----------------------------- */
proc means data=train n mean max min range std missing noprint fw=8;
	class f2 f5 f13 f778;
	var loss;
	output out=meansout mean=mean std=std;
	title 'Summary of loss';
run;

/* 	Plotting */
PROC PRINT data=meansout;
	Title '_TYPE_ WITHOUT formatting';
run;

/* %TypeFormat(formatname=testtyp,var=f2 f5 f13 f778); */
/* PROC PRINT data=meansout; */
/* var _type_ f2 f5 f13 f778 _freq_; */
/* format _type_ testtyp.; */
/* title '_TYPE_ WITH formatting'; run;  */

/* Theres probably a better way to do this will come back if time */
data summarystats;
	set meansout;
if mean = 0 then delete;
	if _TYPE_^=12  then
		delete;
	run;
proc sort data=summarystats;
by f5;
run;
proc print data =  summarystats;
data plottingdata(keep=f5 f2 mean std meanloss);
	set summarystats;
	by f5 f2;
	meanloss=mean;
	output;
	meanloss=mean - std;
	output;
	meanloss=mean + std;
	output;
run;
proc sort data=plottingdata;
	by f5;
run;

/* proc print data=plottingdata; */



*Plotting options to make graph look somewhat decent;
title1 'Plot Means with Standard Error Bars';
symbol1 interpol=hiloctj color=green line=1;
symbol2 interpol=hiloctj color=red line=1;
symbol3 interpol=hiloctj color=blue line=1;
symbol4 interpol=hiloctj color=purple line=1;
symbol5 interpol=hiloctj color=black line=1;
symbol6 interpol=hiloctj color=orange line=1;
symbol7 interpol=hiloctj color=brown line=1;
symbol8 interpol=hiloctj color=darkkhaki line=1;
symbol9 interpol=hiloctj color=pink line=1;
symbol10 interpol=hiloctj color=brpk line=1;
symbol11 interpol=hiloctj color=depk line=1;

symbol12 interpol=none color=vibg value=dot height=1.5;
symbol13 interpol=none color=depk value=dot height=1.5;

axis1 offset=(5, 5);
axis2 label=("MeanLoss and a f2") order=(-9 to 11.5 by 1) minor=(n=1);
*data has to be sorted on the variable which you are going to put on the x axis;
proc gplot data=plottingdata;
	plot meanloss*f5=f2 / vaxis=axis2 haxis=axis1;
	*Since the first plot is actually 2 (male female) the corresponding symbol1 and symbol2 options are used which is telling sas to make error bars.  The option is hiloctj;
	plot2 Mean*f5=f2  / vaxis=axis2 noaxis nolegend;
	*This plot uses the final 2 symbols options to plot the mean points;
	run;
quit;
*This is the end of the plotting code;








/* 	2 Way ANOVA */
proc glm data=math PLOTS=(DIAGNOSTICS RESIDUALS);
	class sex background;
	model score=background sex background*sex;
	lsmeans background / pdiff tdiff adjust=bon;
	estimate 'B vs A' background -1 1 0;
	estimate 'What do you think?' background -1 0 1;
	estimate 'What do you think2?' sex -1 1;
	run;

/*      Correct Skew*/
/*	data TRAIN; */
/*	set WORK.TRAIN; */
/*	logSalePrice = log(SalePrice);*/
/*	run;*/
/*f2, f5, f13 and f778 are categorical,*/
/*f4 probably categorical, only 61 distinct values*/
/* Variable Selection Models */
/* Looking for Large R^2 and small CV Press */

/* Forward */
proc glmselect data=TRAIN plots=all;
	class f2 f5 f13 f778;
	model loss=f1 f3 f4 f6 f7 f8 f9 f10 /selection=Forward (stop=CV) 
		cvmethod=random(5) stats=adjrsq;
/* Backward */
proc glmselect data=TRAIN plots=all;
	class f2 f5 f13 f778;
	model loss=f1 f3 f4 f6 f7 f8 f9 f10 /selection=backward (stop=CV) 
		cvmethod=random(5) stats=adjrsq;
/* Stepwise */
proc glmselect data=TRAIN plots=all;
	class f2 f5 f13 f778;
	model loss=f1 f3 f4 f6 f7 f8 f9 f10 /selection=stepwise (stop=CV) 
		cvmethod=random(5) stats=adjrsq;



			/* -----------------------------Sugi29 SAa Coder's Corner-----------------------------*/
			/* http://www2.sas.com/proceedings/sugi29/045-29.pdf ABSTRACT: PROC MEANS analyzes datasets */
			/* according to the variables listed in its Class statement. Its computed */
			/* _TYPE_ variable can be used to determine which class variables were used for the analysis variable calculation. It */
			/* can be very difficult to determine by inspection of the _TYPE_ variable which class variables were used in a */
			/* calculation of any given row. The %TypeFormat macro takes the CLASS variable list and creates a format that */
			/* associates the values of the _TYPE_ variable with a string listing the variables used in the calculation separated by */
			/* the '*' character. */
			/* A group of rows with identical _TYPE_ values indicates that the same variables were used in calculating the analysis */
			/* variables, and each row with this _TYPE_ value represents a different combination of the level of the variables. */
			/* Rows with different _TYPE_ variables indicate that different combinations of variables were used.  */
			/* A solution to this problem is to use the %TypeFormat macro (code included), which associates the _TYPE_ variable value to a */
			/* string that lists the classification variables used in a particular calculation. */
			%macro TypeFormat(formatname=typefmt,var=x1 x2 x3 x4);
			/* Count the number of variables, put into var_count */
			%local var_count; %let var_count = 1;
			%do %until (%scan(&var,&var_count) eq); %let var_count = %eval(&var_count+1); %end;
			%let var_count = %eval(&var_count-1);
			/* Assign each variable name to an indexed macro &&var_val&i */
			%local i; %let i = %eval(&var_count);
			%do %until (&i <= 0);
			 %local var_val&i;
			%let var_val&i = %scan(&var,&i); %let i = %eval(&i-1);
			 %end;
			/* Create temp dataset to use as format */
			data _tmp;
			keep label start fmtname type;
			retain fmtname "&formatname" type 'n';
			length label $ 256 sep $ 1;
			sep = '*'; * Separator character;
			/* Loop through the type combinations */
			type_iter = 2**(&var_count) - 1; * Loop through the types;
			var_iter = &var_count; * Loop over the binary digits;
			do start = 0 to type_iter; * Type iteration loop;
			i_tmp = start; label = '';
			do j = var_iter to 1 by (-1); * Binary digit loop;
			 bin_digit = int(i_tmp/(2**(j-1)));
			if bin_digit = 1 then do;
			 * Get appropriate variable name;
			x = symget('var_val'||left(trim(put(&var_count - j + 1,3.))));
			* Add the separator to the string;
			 x = left(trim(x))||sep;
			* Append selected variable name to label string;
			 newlabel = trim(label)||x;
			 * Reassign label as newlabel;
			 label = newlabel;
			* Decrement i_tmp if bin_digit is in types binary representation;
			 i_tmp = i_tmp - 2**(j-1);
			 end;
			 end;
			label = left(label); * justify label test to left;
			 len = length(label);
			* Take off separator that was appended to end;
			 label = substr(label,1,len-1);
			 output;
			 end;
			 stop;
			 run;
			* create the format from _tmp dataset;
			proc format cntlin=_tmp; run;
			* Delete _tmp dataset to clean up work library;
			proc datasets; delete _tmp; quit; run;
			%mend TypeFormat; 
			

/* -----------------------------Dr. Turner----------------------------- */
*Calculating a summary stats table and outputing the results in a dataset called "meansout";
proc means data=math n mean max min range std fw=8;
	class Sex Background;
	var Score;
	output out=meansout mean=mean std=std;
	title 'Summary of Math ACT Scores';
run;
/* The following chunk of code is some basic code to plot the summary statistics in a convenient profile type plot. */
/* This will probably take you some time to understand how sas works to finally get the plot but for those who put in the */
/* effort, your understanding of SAS will be better for it and you will soon figure out you can do a lot of differnt things. */
/* For those of you who do not have the time, the alternative is to take the summary statistics output and move them over to */
/* excel and create a plot over there. */
data summarystats;
	set meansout;
	if _TYPE_=0 then
		delete;
	if _TYPE_=1 then
		delete;
	if _TYPE_=2 then
		delete;
run;
/* This data step creates the necessary data set to plot the mean estimates along with the error bars */
data plottingdata(keep=Sex Background mean std newvar);
	set summarystats;
	by Sex Background;
	newvar=mean;
	output;
	newvar=mean - std;
	output;
	newvar=mean + std;
	output;
run;
/* Plotting options to make graph look somewhat decent */
title1 'Plot Means with Standard Error Bars from Calculated Data for Groups';
symbol1 interpol=hiloctj color=vibg line=1;
symbol2 interpol=hiloctj color=depk line=1;
symbol3 interpol=none color=vibg value=dot height=1.5;
symbol4 interpol=none color=depk value=dot height=1.5;
axis1 offset=(2, 2);
axis2 label=("Math ACT") order=(0 to 40 by 10) minor=(n=1);
/* data has to be sorted on the variable which you are going to put on the x axis */
proc sort data=plottingdata;
	by Background;
run;
proc gplot data=plottingdata;
	plot NewVar*Background=Sex / vaxis=axis2 haxis=axis1;
/* 	Since the first plot is actually 2 (male female) the corresponding symbol1 and symbol2 options are used which is  */
/* 	telling sas to make error bars.  The option is hiloctj */
	plot2 Mean*Background=Sex / vaxis=axis2 noaxis nolegend;
	/* This plot uses the final 2 symbols options to plot the mean points */
	run;
quit;
/* This is the end of the plotting code */








/* Last Project Code */
	/* Assumptions */
	/* 	Forward Selected */
proc glm data=Q2TRAIN plots=all;
	class Neighborhood;
	model logSalePrice=Neighborhood OverallQual BsmtFinSF1 GrLivArea /solution;

	/* 	Backward Selected */
proc glm data=Q2TRAIN plots=all;
	class MSZoning Street Alley LotShape LandContour Utilities LotConfig LandSlope 
		Neighborhood Condition1 Condition2 BldgType HouseStyle RoofStyle RoofMatl 
		Exterior1st Exterior2nd MasVnrType ExterQual ExterCond Foundation BsmtQual 
		BsmtCond BsmtExposure BsmtFinType1 BsmtFinType2 Heating HeatingQC CentralAir 
		Electrical KitchenQual Functional FireplaceQu GarageType GarageFinish 
		GarageQual GarageCond PavedDrive PoolQC Fence MiscFeature SaleType 
		SaleCondition;
	model logSalePrice=MSSubClass MSZoning LotArea Street Alley LotShape 
		LandContour Utilities LotConfig LandSlope Neighborhood Condition1 Condition2 
		BldgType HouseStyle OverallQual OverallCond YearBuilt YearRemodAdd RoofStyle 
		RoofMatl Exterior1st Exterior2nd MasVnrType MasVnrArea ExterQual ExterCond 
		Foundation BsmtQual BsmtCond BsmtExposure BsmtFinType1 BsmtFinSF1 
		BsmtFinType2 BsmtFinSF2 BsmtUnfSF Heating HeatingQC CentralAir Electrical 
		_1stFlrSF _2ndFlrSF LowQualFinSF BsmtFullBath BsmtHalfBath FullBath HalfBath 
		BedroomAbvGr KitchenAbvGr KitchenQual TotRmsAbvGrd Functional Fireplaces 
		FireplaceQu GarageType GarageYrBlt GarageFinish GarageCars GarageArea 
		GarageQual GarageCond PavedDrive WoodDeckSF OpenPorchSF EnclosedPorch 
		_3SsnPorch ScreenPorch PoolArea PoolQC Fence MiscFeature MiscVal MoSold 
		YrSold SaleType SaleCondition /solution;

	/* 	Stepwise Selected */
proc glm data=Q2TRAIN plots=all;
	class Neighborhood BldgType RoofMatl;
	model logSalePrice=Neighborhood BldgType OverallQual OverallCond YearBuilt 
		RoofMatl BsmtFinSF1 TotalBsmtSF GrLivArea/ solution;

	/* 	Custom */
	/* 	See if we can improve stepwise */
data Q2CUSTOMTRAIN;
	set Q2TRAIN;
	logSalePrice=log(SalePrice);

	if LotArea > 100000 then
		delete;

	if GrLivArea > 5641 then
		delete;

	/* 	Check for colinearity in variables */
proc SGSCATTER data=Q2CUSTOMTRAIN;
	matrix Neighborhood BldgType OverallQual OverallCond YearBuilt RoofMatl 
		BsmtFinSF1 TotalBsmtSF GrLivArea;

	/* 	Check for variable Inflation */
proc reg data=Q2CUSTOMTRAIN;
	model logSalePrice=OverallQual OverallCond YearBuilt BsmtFinSF1 TotalBsmtSF 
		GrLivArea / selection=cp VIF;

proc glm data=Q2CUSTOMTRAIN plots=all;
	class Neighborhood BldgType RoofMatl;
	model logSalePrice=Neighborhood BldgType OverallQual OverallCond YearBuilt 
		RoofMatl BsmtFinSF1 TotalBsmtSF GrLivArea/ solution;

	/* 		Try Custom Model		 */
proc glmselect data=Q2CUSTOMTRAIN plots=all;
	class Neighborhood BldgType RoofMatl;
	model logSalePrice=Neighborhood BldgType OverallQual OverallCond YearBuilt 
		RoofMatl BsmtFinSF1 TotalBsmtSF GrLivArea /selection=stepwise (stop=CV) 
		cvmethod=random(5) stats=adjrsq;

	/* Predictions */
	/* Import the test data */
	%web_drop_table(WORK.TEST);
	FILENAME REFFILE 
		'/folders/myshortcuts/StatisticalFoundations/Group Project/test.csv';

PROC IMPORT DATAFILE=REFFILE DBMS=CSV OUT=WORK.TEST;
	GETNAMES=YES;
RUN;

PROC CONTENTS DATA=WORK.TEST;
RUN;

%web_open_table(WORK.TEST);

/* Add Saleprice column to test data */
data Q2TEST;
	set WORK.TEST;
	SalePrice=.;
run;

/* Combine the train and test data */
data Q2PREDICT;
	set WORK.Q2TRAIN WORK.Q2TEST;
run;

/* Forward */
proc glm data=Q2PREDICT plots=all;
	class Neighborhood;
	model logSalePrice=Neighborhood OverallQual BsmtFinSF1 GrLivArea /cli solution;
	output out=ForwardSelectedresults p=Predict;
	run;

data ForwardSelectedresults;
	set ForwardSelectedresults;
	predictedSalePrice=logsaleprice;
	keep id Predict saleprice logsaleprice predictedSalePrice;

proc print data=ForwardSelectedresults;
	/* Backward */
proc glm data=Q2PREDICT plots=all;
	class MSZoning Street Alley LotShape LandContour Utilities LotConfig LandSlope 
		Neighborhood Condition1 Condition2 BldgType HouseStyle RoofStyle RoofMatl 
		Exterior1st Exterior2nd MasVnrType ExterQual ExterCond Foundation BsmtQual 
		BsmtCond BsmtExposure BsmtFinType1 BsmtFinType2 Heating HeatingQC CentralAir 
		Electrical KitchenQual Functional FireplaceQu GarageType GarageFinish 
		GarageQual GarageCond PavedDrive PoolQC Fence MiscFeature SaleType 
		SaleCondition;
	model logSalePrice=MSSubClass MSZoning LotArea Street Alley LotShape 
		LandContour Utilities LotConfig LandSlope Neighborhood Condition1 Condition2 
		BldgType HouseStyle OverallQual OverallCond YearBuilt YearRemodAdd RoofStyle 
		RoofMatl Exterior1st Exterior2nd MasVnrType MasVnrArea ExterQual ExterCond 
		Foundation BsmtQual BsmtCond BsmtExposure BsmtFinType1 BsmtFinSF1 
		BsmtFinType2 BsmtFinSF2 BsmtUnfSF Heating HeatingQC CentralAir Electrical 
		_1stFlrSF _2ndFlrSF LowQualFinSF BsmtFullBath BsmtHalfBath FullBath HalfBath 
		BedroomAbvGr KitchenAbvGr KitchenQual TotRmsAbvGrd Functional Fireplaces 
		FireplaceQu GarageType GarageYrBlt GarageFinish GarageCars GarageArea 
		GarageQual GarageCond PavedDrive WoodDeckSF OpenPorchSF EnclosedPorch 
		_3SsnPorch ScreenPorch PoolArea PoolQC Fence MiscFeature MiscVal MoSold 
		YrSold SaleType SaleCondition /cli solution;
	output out=BackwardSelectedresults p=Predict;
	run;

data BackwardSelectedresults;
	set BackwardSelectedresults;
	predictedSalePrice=logsaleprice;
	keep id Predict saleprice logsaleprice predictedSalePrice;

proc print data=BackwardSelectedresults;
	/* Stepwise */
proc glm data=Q2PREDICT plots=all;
	class Neighborhood BldgType RoofMatl;
	model logSalePrice=Neighborhood BldgType OverallQual OverallCond YearBuilt 
		RoofMatl BsmtFinSF1 TotalBsmtSF GrLivArea /cli solution;
	output out=StepwiseSelectedresults p=Predict;
	run;

data StepwiseSelectedresults;
	set StepwiseSelectedresults;
	predictedSalePrice=logsaleprice;
	keep id Predict saleprice logsaleprice predictedSalePrice;

proc print data=StepwiseSelectedresults;
	/* Custom */
data Q2PREDICT;
	set WORK.Q2CUSTOMTRAIN WORK.Q2TEST;
run;

proc glm data=Q2PREDICT plots=all;
	class Neighborhood BldgType RoofMatl;
	model logSalePrice=Neighborhood BldgType OverallQual OverallCond YearBuilt 
		RoofMatl BsmtFinSF1 TotalBsmtSF GrLivArea /cli solution;
	output out=CustomSelectedresults p=Predict;
	run;

data CustomSelectedresults;
	set CustomSelectedresults;
	predictedSalePrice=logsaleprice;
	keep id Predict saleprice logsaleprice predictedSalePrice;

proc print data=CustomSelectedresults;