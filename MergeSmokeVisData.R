library(tidyverse)
SmokeDat<-read_csv("~/Smoke_Proj/interm_data/final_max.csv")
View(SmokeDat)
VisDat<-read_csv("~/Smoke_Proj/Data/VisitationDataClean.csv")
View(VisDat)

library(tidyr)

#Make a "long" version of the smoke data
sml<-gather(SmokeDat, Date, Smoke, X198001:X201910, factor_key = F)
View(sml)

#Change the format of the dates to match the vis data
sml$Year<-substr(sml$Date, 2,5)
sml$Month<-substr(sml$Date, 6,7)

#create a Jan-Sept vector
x<-1:9
#Make it a character so it's a btit easier
VisDat$Month<-as.character(VisDat$Month)
#add a 0 to the front of the single diget months to match the smoke data
VisDat$Month<-ifelse(VisDat$Month %in% x,
       paste0("0", VisDat$Month),paste0("", VisDat$Month)) 
VisDat$Year<-as.character(VisDat$Year)

#Match the names of the parks
names(sml)[1]<-"UnitCode"

#merge the datasets by park, and month
mdat<-merge(x=VisDat,y=sml,by=c("UnitCode", "Year","Month"))
#remove columns we dont need            
mdat<-mdat[,-c(4,7)]
#create the csv
write.csv(mdat, file="MergedDataComplete.csv")
