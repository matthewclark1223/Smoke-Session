library(tidyverse)
library(lme4)
library(rstanarm)
dat<-read_csv("~/Smoke_Proj/Data/MergedDataComplete.csv")
fit<-glmer(RecreationVisits~Smoke+(Smoke|UnitCode), 
           family="poisson", data=dat)

#singular fir try bayes
options(mc.cores = 4)
fit<-stan_glmer(RecreationVisits~Smoke+(Smoke|UnitCode), 
           family="poisson", data=dat)


#fit is singular ^^
#standardize the variables?
stdize<-function(x) {return((x-mean(x)/(2*sd(x))))}

dat$stdSmoke<-stdize(dat$Smoke)

fit<-glmer(RecreationVisits~stdSmoke+(stdSmoke|UnitCode), 
           family="poisson", data=dat)
