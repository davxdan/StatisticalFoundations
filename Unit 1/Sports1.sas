%web_drop_table(WORK.SPORTS);


FILENAME REFFILE '/folders/myfolders/Height.csv';

PROC IMPORT DATAFILE=REFFILE
	DBMS=CSV
	OUT=WORK.SPORTS;
	GETNAMES=YES;
RUN;

PROC CONTENTS DATA=WORK.SPORTS; RUN;


%web_open_table(WORK.SPORTS);
proc ttest data = sports alpha=.01 sides =2;
class sport;
/*class Sport;
var = Height;



proc print data = sports;