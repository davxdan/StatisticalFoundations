proc power;
onewayanova test=overall
alpha=.05
groupmeans = 3|7|8
stddev = 4
power = .8
ntotal = .;
run;
