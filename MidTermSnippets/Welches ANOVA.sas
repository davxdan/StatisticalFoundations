proc glm data = incomedata;
class educ;
model income2005 = educ;
means educ / hovtest = bf welch;
run;