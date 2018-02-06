library(survival)
T = c(1.5, 2.5, 1.4, 6.2, 2.8, 5.3, 4.5)
ind = c(1, 0, 0, 1, 1, 1, 0)
fit1 = survfit(Surv(T,ind)~1, type = "kaplan-meier", 
               error = "greenwood", conf.int = 0.95, conf.type = "log")
summary(fit1)
