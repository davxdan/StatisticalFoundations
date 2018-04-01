%web_drop_table(WORK.MF);
FILENAME REFFILE '/folders/myshortcuts/StatisticalFoundations/Stats Unit 12 Homework/unit12data/Archive/Meadowfoam Data.csv';
PROC IMPORT DATAFILE=REFFILE
	DBMS=CSV
	OUT=WORK.MF;
	GETNAMES=YES;
RUN;