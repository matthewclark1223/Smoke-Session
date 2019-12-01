library(tidyverse)
SmokeDat<-read_csv("~/Smoke_Proj/interm_data/final_max.csv")
View(SmokeDat)
VisDat<-read_csv("~/Smoke_Proj/Data/VisitationDataClean.csv")
View(VisDat)

library(tidyr)
sml<-gather(SmokeDat, Date, Smoke, X198001:X201910, factor_key = F)
View(sml)
sml$Year<-substr(sml$Date, 2,5)
sml$Month<-substr(sml$Date, 6,7)
x<-1:9
VisDat$Month<-as.character(VisDat$Month)
VisDat$Month<-ifelse(VisDat$Month %in% x,
       paste0("0", VisDat$Month),paste0("", VisDat$Month)) 
