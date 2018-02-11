educationdatastg1 <- read.csv(file.choose())
aov(Income2005 ~ Educ, data = educationdatastg1)