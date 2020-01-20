library(tidyverse)
library(lme4)
library(rstanarm)
options(mc.cores = parallel::detectCores())

#models below increase in complexity..Currently, non of  them are converging using 
#the lme4 package or with rstanarm
#this may be a computational problem on my end though, rather than a model specification problem

#glm with independent intercept for each park for each season
fit<-glmer.nb(RecreationVisits~stdsmoke+CatColS+(1|CatColS),data=dat)

#glm with independent intercept for each park for each Month
fit2<-glmer.nb(RecreationVisits~stdsmoke+CatColM+(1|CatColM),data=dat)


#glm with independent intercept for each park for each Season and
# random slope for smoke for each park
fit3<-glmer.nb(RecreationVisits~stdsmoke+CatColS+(stdsmoke|CatColS),data=dat)

#glm with independent intercept for each park for each Month and
# random slope for smoke for each park
#this is the preferred model
fit4<-glmer.nb(RecreationVisits~stdsmoke+CatColM+(stdsmoke|CatColM),data=dat)


#any of these models can be run using stan by specifying 
#stan_glmer.nb instead of the glmer.nb function from lme4
