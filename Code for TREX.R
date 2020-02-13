library(rstanarm)
library(tidyverse)
options(mc.cores = parallel::detectCores())
dat<-read_csv("~/Smoke_Proj/Data/MergedDataComplete.csv")