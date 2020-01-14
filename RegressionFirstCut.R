library(tidyverse)
library(lme4)
library(rstanarm)
stdize<-function(x) {return((x-mean(x)/(2*sd(x))))}
dat<-read_csv("~/Smoke_Proj/Data/MergedDataComplete.csv")
dat$CatCol<-paste0(dat$UnitCode,dat$Month)
dat$Month<-as.character(dat$Month)
subdat<-dat[1:468,]

##standardization function doing some weird rounding thing
## Doing it in 2 steps doesn't yeild the same problem
dat$intSmoke<-dat$Smoke-mean(dat$Smoke)
dat$stdsmoke<-intSmoke/(2*sd(dat$Smoke))
##

dat$Season<-ifelse(dat$Month %in% c("03","04","05"),"Spring",
                   ifelse(dat$Month %in% c("06","07","08"),"Summer",
                          ifelse(dat$Month %in% c("09","10","11"),"Fall","Winter")))

dat$CatColS<-paste0(dat$UnitCode,dat$Season)



options(mc.cores = parallel::detectCores())
fit<-glmer.nb(RecreationVisits~stdsmoke+CatColS+(1|CatColS),data=dat)



fit<-glmer.nb(RecreationVisits~Smoke+(Smoke|UnitCode)+
             (1|Month:UnitCode), 
            data=dat)

fit3<-glmer.nb(RecreationVisits ~ Smoke + UnitCode + 
              (Smoke | UnitCode) + (1 |UnitCode) + (1 | Month),
            data=dat)



ggplot(dat, aes(x=Year, y=RecreationVisits, color=UnitCode))+
  geom_smooth(alpha=0.5, method="lm", se=F)+
  theme(legend.position = "none")


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
