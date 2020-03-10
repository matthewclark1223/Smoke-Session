library(tidyverse)
library(rstan)
dat<-read_csv("~/Smoke_Proj/Data/MergedDataComplete.csv")
dat<-dat[1:7895,]
dat$id<-as.numeric(as.factor(dat$UnitCode ))
data_list <- list(
  N = nrow(dat),
  Nprk = length(unique(dat$UnitCode)),
  count = dat$RecreationVisits,
  smoke = dat$stdsmoke,
  pcode = dat$id)

l<- stan( file="SmokePointBreak.stan" , data=data_list,chains=1 )

print( l , probs=c( (1-0.89)/2 , 1-(1-0.89)/2 ) )
summary(l)

 