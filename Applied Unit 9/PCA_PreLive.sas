data q;
input ZIP Fire Theft Age Income Race Vol Invol ;
cards;
26    6.2   29    60.4  11744 10    5.3   0
40    9.5   44    76.5  9323  22.2  3.1   0.1
13    10.5  36    73.5  9948  19.6  4.8   1.2
57    7.7   37    66.9  10656 17.3  5.7   0.5
14    8.6   53    81.4  9730  24.5  5.9   0.7
10    34.1  68    52.6  8231  54    4     0.3
11    11    75    42.6  21480 4.9   17.9  0
25    6.9   18    78.5  11104 7.1   6.9   0
18    7.3   31    90.1  10694 5.3   7.6   0.4
47    15.1  25    89.8  9631  21.5  3.1   1.1
22    29.1  34    82.7  7995  43.1  1.3   1.9
31    2.2   14    40.2  13722 1.1   14.3  0
46    5.7   11    27.9  16250 1     12.1  0
56    2     11    7.7   13686 1.7   10.9  0
30    2.5   22    63.8  12405 1.6   10.7  0
34    3     17    51.2  12198 1.5   13.8  0
41    5.4   27    85.1  11600 1.8   8.9   0
35    2.2   9     44.4  12765 1     11.5  0
39    7.2   29    84.2  11084 2.5   8.5   0.2
51    15.1  30    89.8  10510 13.4  5.2   0.8
44    16.5  40    72.7  9784  59.8  2.7   0.8
24    18.4  32    72.9  7342  94.4  1.2   1.8
12    36.2  41    63.1  6565  86.2  0.8   1.8
7     39.7  47    83    7459  50.2  5.2   0.9
23    18.5  22    78.3  8014  74.2  1.8   1.9
8     23.3  29    79    8177  55.5  2.1   1.5
16    12.2  46    48    8212  62.3  3.4   0.6
32    5.6   23    71.5  11230 4.4   8     0.3
9     21.8  4     73.1  8330  46.2  2.6   1.3
53    21.6  31    65    5583  99.7  0.5   0.9
15    9     39    75.4  8564  73.5  2.7   0.4
38    3.6   15    20.8  12102 10.7  9.1   0
29    5     32    61.8  11876 1.5   11.6  0
36    28.6  27    78.1  9742  48.8  4     1.4
21    17.4  32    68.6  7520  98.9  1.7   2.2
37    11.3  34    73.4  7388  90.6  1.9   0.8
52    3.4   17    2     13842 1.4   12.9  0
20    11.9  46    57    11040 71.2  4.8   0.9
19    10.5  42    55.9  10332 94.1  6.6   0.9
49    10.7  43    67.5  10908 66.1  3.1   0.4
17    10.8  34    58    11156 36.4  7.8   0.9
55    4.8   19    15.2  13323 1     13    0
43    10.4  25    40.8  12960 42.5  10.2  0.5
28    15.6  28    57.8  11260 35.1  7.5   1
27    7     3     11.4  10080 47.4  7.7   0.2
33    7.1   23    49.2  11428 34    11.6  0.3
45    4.9   27    46.6  13731 3.1   10.9  0
;
data q;
	set q;
	Location="North";
	if zip in (23,8,16,32,9,53,15,38,29,36,21,37,49,52,20,19,17,28,43,55,27,33) then Location = "South";
	run;

/********************************************************
			Basic PCA 
********************************************************/
ods rtf ; *places results in a word file;
ods graphics on;
proc means data =q n mean median std var min max maxdec=2;
      var Fire Theft Age Income Race ;
      run;
proc corr data=q plots=matrix(histogram);
      var Fire Theft Age Income Race;
      run;
* Use corr or covar matrix?;
proc princomp plots=all data=q cov out=pca;
      var Fire Theft Age Income Race ;
      run;
proc princomp plots=all data=q out=pca;
      var Fire Theft Age Income Race ;
	  id zip ;
      run;
proc princomp plots=all data=q out=pca;
      var Fire Theft Age Income Race ;
	  id Location ;
      run;
      
      
      
proc means data =q n mean median std var min max maxdec=2;
      var Fire Theft Age Income Race ;
      run;  
proc means data =pca n mean median std var min max maxdec=2;
      var Fire Theft Age Income Race ZIP Prin1 Prin2 Prin3 Prin4 Prin5;
      run;
      
      
      
      
proc gplot data=pca;
	  plot prin2*prin1=location;
	  run;
ods graphics off;
ods rtf close; *completes word file;

/********************************************************
			PCA Regression
********************************************************/
proc corr data=pca plots=matrix(histogram);
      var vol prin1 - prin5;
      run;
proc pls data=q method=pcr;
	model vol =Fire Theft Age Income Race;
	run;
proc reg data=pca;
	model vol= prin1-prin5;
	run;

/********************************************************
			Basic CCA 
********************************************************/
ods graphics on;
proc means data =q n mean median var std min max maxdec=2;
      var Vol invol Fire Theft Age Income Race ;
      run;
proc corr data=q plots=matrix(histogram);
      var vol invol;
      with Fire Theft Age Income Race;
      run;
proc corr data=q plots=matrix(histogram);
      var vol invol;
      run;
proc cancorr data=q out=cca;
	with Fire Theft Age Income Race;
	var Vol Invol ;
	run;
ods graphics off;
	
/********************************************************
			CCA for MANOVA 
********************************************************/
ods rtf;
ods graphics on;
proc means data =q n mean median var std min max maxdec=2;
	class location ;
      var Fire Theft Age Income Race ;
      run;
proc glm data=q;
	class location;
	model Fire Theft Age Income Race = location;
	manova h=location / canonical;
	run;
ods graphics off;
ods rtf close;

