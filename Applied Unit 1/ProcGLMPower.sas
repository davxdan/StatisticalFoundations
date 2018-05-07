/* Use proc power to get sample sizes for analysis of variance (2 way)  */
/* 3 different Light exposure and 2 different flower species */
data exemplary;
	do variety=1 to 2;

		do exposure=1 to 3;

			/* the @@ tells SAS to keep reading across the lines */
			input height @@;
			output;
		end;
	end;

	/* 	Means for each group of flower height data */
	datalines;
	14 16 21
	10 15 16
	;
run;

/* proc glmpower data=exemplary; */
/* class variety exposure; */
/* the vertical bar "|" tells SAS to do all combinations */
/* model height = variety | exposure; */
/* power */
/* stddev = 5 */
/* ntotal = 60 */
/* power = .; */
/* run; */
/* Low power can lead us to think there is no practically significant interaction effect so we need to know power is sufficient */
proc glmpower data=exemplary;
	class variety exposure;

	/* the vertical bar "|" tells SAS to do all combinations */
	model height=variety | exposure;
	power stddev=4 6.5 ntotal=60 power=.;
	plot x=n min=30 max=90;
run;

/* Using proc power to test the equality of 2 proportions */
/* Untreated skin lesion Group. 30% untreated will develop into cancer */
/* Current drug reduces probability of cancer by 10% */
/* New drug we want to reduce by 15% */

/* How many Subjects are needed to test this? */
/* We want power of .8 and alpha .05 (FDA actually requires this) */

proc power;
twosamplefreq test = pchi
groupproportions = (0.3 0.15)
nullproportiondiff = 0
power = 0.8
npergroup = .;
run;

/* LRT Chi Square */
proc power;
twosamplefreq test = lrchi
groupproportions = (0.3 0.15)
power = 0.8
npergroup = .;
run;

/* Fisher's Exact Test */
/* Because we are not interested in increasing lesions we can change to 1 sided. 1 Sided is more powerful than a 2 sided because we know the direction. */
proc power;
twosamplefreq test = fisher
groupproportions = (0.3 0.15)
power = 0.8
sides = 1
npergroup = .;
run;

/* Fisher's Exact Test - Unbalanced */
proc power;
twosamplefreq test = fisher
groupproportions = (0.3 0.15)
power = 0.8
groupweights = (1 2)
sides = 1
ntotal=.;
run;


