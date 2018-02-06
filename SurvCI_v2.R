library(survival)

#the sample size the large than 30, CI can be good, censor rate also less the better
T = c(1.5, 2.5, 1.4, 6.2, 2.8, 5.3, 4.5)
ind = c(1, 0, 0, 1, 1, 1, 0)
fit1 = survfit(Surv(T,ind)~1, type = "kaplan-meier", 
               error = "greenwood", conf.int = 0.95) #defalt is the log tranformationm, less recommendated
summary(fit1)
# upper level is 1, last observation is a death

fit2 = survfit(Surv(T,ind)~1, type = "kaplan-meier", 
               error = "greenwood", conf.int = 0.95, conf.type = "log-log") #log-log transform, no arcsinc
summary(fit2)
#log log won't bring the upper level to 1

fit3 = survfit(Surv(T,ind)~1, type = "kaplan-meier", 
               error = "greenwood", conf.int = 0.95, conf.type = "plain")
summary(fit3)

library(KMsurv)
data = data(bmt)

