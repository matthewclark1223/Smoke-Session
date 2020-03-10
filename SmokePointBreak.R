library(tidyverse)
library(rstan)
dat<-read_csv("~/Smoke_Proj/Data/MergedDataComplete.csv")
#dat<-dat%>% filter(UnitCode %in% c("YOSE","YELL","GRTE"))
dat<-dat%>% filter(UnitCode %in% c("YELL","GRTE"))
#dat$id<-as.numeric(as.factor(dat$UnitCode )) for no seasonal intercept
dat$id<-as.numeric(as.factor(dat$UnitCode ))

data_list <- list(
  N = nrow(dat),
  Nprk = length(unique(dat$UnitCode)),
  count = dat$RecreationVisits,
  smoke = dat$stdsmoke,
  pcode = dat$id)
options(mc.cores=3)
l<- stan( file="IndividualPointBreakIndSlopes.stan" , data=data_list,chains=3 )

print( l , probs=c( (1-0.89)/2 , 1-(1-0.89)/2 ) )
summary(l)





#now do with full ds
dat<-read_csv("~/Smoke_Proj/Data/MergedDataComplete.csv")

stdize<-function(x) {return((x-mean(x)/(2*sd(x))))}

dat<-dat%>%group_by(UnitCode)%>%
  mutate(stdsmokepark=stdize(stdsmoke))

dat$id<-as.numeric(as.factor(dat$UnitCode ))
data_list <- list(
  N = nrow(dat),
  Nprk = length(unique(dat$UnitCode)),
  count = dat$RecreationVisits,
  smoke = dat$stdsmokepark,
  pcode = dat$id)

l<- stan( file="IndividualPointBreak.stan" , data=data_list,chains=3 )

print( l , probs=c( (1-0.89)/2 , 1-(1-0.89)/2 ) )


ggplot(data=dat,aes(x=stdsmoke,y=RecreationVisits,by=UnitCode))+
  geom_point(alpha=0.2)+
  geom_smooth(aes(color=UnitCode),se=FALSE,alpha=0.1)+
  theme_classic()+ggtitle("max")

