/* 3 pairwise Rank Sum Tests (Wilcoxon... be sure to check back about the Bonferroni correction k=3 thing. Her pvalues are not the same as what is in output.*/
		data TrumpCruz; 
		set IMPORT; 
		if Candidate = "Carson" then delete;
		data TrumpCarson; 
		set IMPORT; 
		if Candidate = "Cruz" then delete;
		data CruzCarson; 
		set IMPORT; 
		if Candidate = "Trump" then delete;

		proc npar1way data = TrumpCarson Wilcoxon;
		var Income;
		class Candidate;
		run;
		proc npar1way data = TrumpCruz Wilcoxon;
		var Income;
		class Candidate;
		run;
		proc npar1way data = CruzCarson Wilcoxon;
		var Income;
		class Candidate;
		run;

/* MultilinearRegression PARALLEL Slopes*/
/* proc print DATA=work.import1; */
proc sgscatter data = work.import1;
matrix Pt BP Age Weight BSA Dur Pulse Pulse_N Stress_;
run;
/* determining if there was a relationship between blood pressure (BP) and weight after accounting for age. */
proc glm data= work.import1 plots = all;
model BP = Age Weight / clparm solution;
run;
/* Write a model that will assume parallel slopes (still BP vs Weight) but will allow for different intercepts for the three different pulse levels (Pulse_C) while still accounting for age (and weight). */
proc glm data= work.import1 plots = all;
class Pulse_C (Ref = "Low");
model BP = Pulse_C Age Weight / clparm solution;
run;

