/* Generated Code (IMPORT) */
/* Source File: view.csv */
/* Source Path: /folders/myshortcuts/StatisticalFoundations/FinalExamPrep */
/* Code generated on: 4/20/18, 1:30 PM */

%web_drop_table(WORK.IMPORT);


FILENAME REFFILE '/folders/myshortcuts/StatisticalFoundations/FinalExamPrep/view.csv';

PROC IMPORT DATAFILE=REFFILE
	DBMS=CSV
	OUT=WORK.IMPORT;
	GETNAMES=YES;
RUN;

PROC CONTENTS DATA=WORK.IMPORT; RUN;
PROC PRINT DATA=work.import;


%web_open_table(WORK.IMPORT);

/* Wilcoxon */
		data TrumpCruz; 
		set IMPORT; 
		if Candidate = "Carson" then delete;
		
		data TrumpCarson; 
		set IMPORT; 
		if Candidate = "Cruz" then delete;
		
		data CruzCarson; 
		set IMPORT; 
		if Candidate = "Trump" then delete;

		proc npar1way data = TrumpCarson Wilcoxon5;
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

