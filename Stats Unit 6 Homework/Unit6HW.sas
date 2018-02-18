/* Problem 1 Bonferroni */
	/* Generated Code (IMPORT) */
	/* Source File: Unit 6 Handicap Data.csv */
	/* Source Path: /folders/myfolders/Stats Unit 6 Homework */
	/* Code generated on: 2/17/18, 10:13 AM */
	%web_drop_table(WORK.HandicapData);
	FILENAME REFFILE 
		'/folders/myfolders/Stats Unit 6 Homework/Unit 6 Handicap Data.csv';
	PROC IMPORT DATAFILE=REFFILE DBMS=CSV OUT=WORK.HandicapData;
		GETNAMES=YES;
	PROC print DATA=WORK.HandicapData;

/* 	Bonferroni Test	(Full) */
/* 		proc glm data = work.handicapdata; */
/* 		class  Handicap; */
/* 		model  Score =  Handicap; */
/* 		means Handicap / HOVTEST=bf bon cldiff; */
		
/* 		Get Means: Results are same as book	 */
/* 		proc glm data = work.handicapdata; */
/* 		class  Handicap; */
/* 		model  Score =  Handicap; */
/* 		means Handicap; */

		proc glm data= work.handicapdata ORDER = DATA;
		class  Handicap;
		model  Score =  Handicap;
		means Handicap/ HOVTEST=bf bon cldiff;
		CONTRAST 'Amputee - Crutches' Handicap 0 1 -1 0 0 ;
		CONTRAST 'Amputee - Wheelchair' Handicap 0 1 0 0 -1;
		CONTRAST 'Crutches - Wheelchair' Handicap 0 0 1 0 -1;
		
/* Problem 2 Verify Halfwidth */
BON Performs Bonferroni t tests
DUNCAN Performs Duncan’s multiple range test
DUNNETT Performs Dunnett’s two-tailed t test
DUNNETTL Performs Dunnett’s lower one-tailed t test
DUNNETTU Performs Dunnett’s upper one-tailed t test
GABRIEL Performs Gabriel’s multiple-comparison procedure
REGWQ Performs the Ryan-Einot-Gabriel-Welsch multiple range test
SCHEFFE Performs Scheffé’s multiple-comparison procedure
SIDAK Performs pairwise t tests on differences between means
SMM or GT2 Performs pairwise comparisons based on the studentized maximum modulus
and Sidak’s uncorrelated-t inequality
SNK Performs the Student-Newman-Keuls multiple range test
T or LSD Performs pairwise t tests
TUKEY Performs Tukey’s studentized range test (HSD)
WALLER Performs the Waller-Duncan k-ratio t test
Specify additional details for multiple comparison tests
ALPHA= Specifies the level of significance
CLDIFF Presents confidence intervals for all pairwise differences between means
CLM Presents results as intervals for the mean of each level of the variables
E= Specifies the error mean square used in the multiple comparisons
ETYPE= Specifies the type of mean square for the error effect
HTYPE= Specifies the MS type for the hypothesis MS
KRATIO= Specifies the Type 1/Type 2 error seriousness ratio
LINES Lists the means in descending order and indicating nonsignificant subsets
by line segments
NOSORT Prevents the means from being sorted into descending order
Test for homogeneity of variances
HOVTEST Requests a homogeneity of variance test
Compensate for heterogeneous variances
WELCH Requests the variance-weighted one-way ANOVA of Welch (1951)

		