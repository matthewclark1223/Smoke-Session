library(rstanarm)
library(tidyverse)
options(mc.cores = parallel::detectCores())
dat<-read_csv("~/Smoke_Proj/Data/MergedDataComplete.csv")

fit<-stan_glmer.nb(RecreationVisits~
                    (1|CatColM)+
                    (stdsmoke|UnitCode)+
                     Year, 
                  data=dat)




