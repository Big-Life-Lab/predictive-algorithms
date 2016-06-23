### MPoRTv0.3
#install.packages(c("survival", "pmml", "pmmlTransformations"))
library(survival)
library(XML)
library(pmml)
library(pmmlTransformations)


### Create dataset
set.seed(5000)

time <- rnorm(5000, 180, 15)
bdate <- sample(seq(as.Date("1910/1/1"), as.Date("1977/1/1"), "day"), 5000, replace=TRUE)
a1 <- sample(seq(as.Date("2007/1/1"), as.Date("2014/1/1"), "day"), 5000, replace=TRUE)
sex <- sample(c("fem", "male"), 5000, replace=TRUE, prob=c(.645, .355))
heightin_hft <- sample(2:7, 5000, replace=TRUE)
heightin_hin <- sample(0:11, 5000, replace =TRUE)
weightlb <- sample(15:300, 5000, replace=TRUE)
hs <- sample(c('hs1', 'hs2'), 5000, replace=TRUE, prob=c(0.8, 0.2))
ed <- sample(c('ed1', 'ed2'), 5000, replace=TRUE, prob=c(0.7, 0.3))
hdg <- sample(c('hdg1', 'hdg2', 'hdg3', 'hdg4', 'hdg5', 'hdg6'), 5000, replace=TRUE, prob=c(0.2, 0.2, 0.1, 0.15, 0.2, 0.15))
data <- data.frame(cbind(sex, heightin_hft, heightin_hin, weightlb, hs, ed, hdg, time, bdate, a1))

data$heightin_hft <- as.numeric(heightin_hft)
data$heightin_hin <- as.numeric(heightin_hin)
data$weightlb <- as.numeric(weightlb)
data$a1 <- as.numeric(a1)
data$bdate <- as.numeric(bdate)
data$female <- as.numeric(sample(c("1", "0"), 5000, replace=TRUE, prob=c(.645, .355)))
data$death <- 0.01221054*exp(0.0203*((data$a1-data$bdate)/365))
data$death <- replace(data$death, data$death>0.07, 1)
data$death <- replace(data$death, data$death<=0.07, 0)
data$time <- as.numeric(time)
data$age <- as.numeric((Sys.Date() - bdate)/365.25)

data$s100 <- as.factor(sample(c('s1001', 's1002'), 5000, replace=TRUE, prob=c(0.6, 0.4)))
data$smk <- as.factor(sample(c('smk1', 'smk2', 'smk3'), 5000, replace=TRUE, prob=c(0.2, 0.2, 0.4)))
data$cigdayd <- sample(1:100, 5000, replace=TRUE)
data$cigdayd[data$smk=='smk2' | data$smk=='smk3'] <- NA
data$evdn <- as.factor(sample(c('evdn1', 'evdn2'), 5000, replace=TRUE, prob=c(0.7, 0.3)))
data$evdn[data$smk=='smk1' | data$smk=='smk2'] <- NA
data$cigdayf <- sample(1:100, 5000, replace=TRUE)
data$cigdayf[data$smk=='smk2' | data$smk=='smk1'] <- NA
data$cigdayf[data$evdn=='evdn2'] <- NA
data$stpn <- as.factor(sample(c('stpn1', 'stpn2', 'stpn3', 'stpn4'), 5000, replace=TRUE, prob=c(0.1, 0.2, 0.3, 0.4)))
data$stpn[data$smk=='smk1' | data$smk=='smk2'] <- NA
data$stpn[data$evdn=='evdn2'] <- NA
data$stpny <- sample(3:50, 5000, replace=TRUE)
data$stpny[data$smk=='smk1' | data$smk=='smk2'] <- NA
data$stpny[data$evdn=='evdn2'] <- NA
data$stpny[data$stpn=='stpn1' | data$stpn=='stpn2' | data$stpn=='stpn3'] <- NA

data$imm <- sample(c('imm1', 'imm2'), 5000, replace=TRUE, prob=c(0.88, 0.12))
data$imm <- as.factor(data$imm)
data$imyr <- sample(c("1", "2", "3", "5", "10", "12", "15", "17", "19", "20", "22", "25", "27", "29", "32", "36", "40", "41", "45", "60"), 5000, replace=TRUE, prob=c(.05, .05, .05, .05, .05, .05, .05, .05, .05, .05, .05, .05, .05, .05, .05, .05, .05, .05, .05, .05))
data$imyr[data$imm=='imm1'] <- NA
data$imyr <- as.numeric(data$imyr)

data$dev <- as.factor(sample(c('dev1', 'dev2'), 5000, replace=TRUE, prob=c(0.8, 0.2)))
data$da12 <- as.factor(sample(c('da121', 'da122', 'da123', 'da124', 'da125', 'da126', 'da127'), 5000, replace=TRUE, prob=c(0.03, 0.12, 0.27, 0.26, 0.25, 0.4, 0.3)))
data$da12[data$dev=='dev2'] <- NA
data$db <- as.factor(sample(c('db1', 'db2', 'db3', 'db4', 'db5', 'db6'), 5000, replace=TRUE, prob=c(0.36, 0.3, 0.2, 0.08, 0.04, 0.02)))
data$db[data$dev=='dev2'] <- NA
data$dany <- as.factor(sample(c('dany1', 'dany2'), 5000, replace=TRUE, prob=c(0.7, 0.3)))
data$dany[data$dev=='dev2'] <- NA
data$drk_drkm <- as.numeric(sample(c('0', '1', '2', '3', '4', '5', '6', '7', '8'), 5000, replace=TRUE, prob=c(0.624, 0.2, 0.1, 0.04, 0.015, 0.015, 0.004, 0.0015, 0.0005)))
data$drk_drkm[data$dany=='dany2']<-NA 
data$drk_drkt <- as.numeric(sample(c('0', '1', '2', '3', '4', '5', '6', '7', '8'), 5000, replace=TRUE, prob=c(0.624, 0.2, 0.1, 0.04, 0.015, 0.015, 0.004, 0.0015, 0.0005)))
data$drk_drkt[data$dany=='dany2']<- NA
data$drk_drkw <- as.numeric(sample(c('0', '1', '2', '3', '4', '5', '6', '7', '8'), 5000, replace=TRUE, prob=c(0.624, 0.2, 0.1, 0.04, 0.015, 0.015, 0.004, 0.0015, 0.0005)))
data$drk_drkw[data$dany=='dany2'] <- NA
data$drk_drkr <- as.numeric(sample(c('0', '1', '2', '3', '4', '5', '6', '7', '8'), 5000, replace=TRUE, prob=c(0.624, 0.2, 0.1, 0.04, 0.015, 0.015, 0.004, 0.0015, 0.0005)))
data$drk_drkr[data$dany=='dany2'] <- NA 
data$drk_drkf <- as.numeric(sample(c('0', '1', '2', '3', '4', '5', '6', '7', '8'), 5000, replace=TRUE, prob=c(0.5, 0.26, 0.15, 0.038, 0.026, 0.018, 0.005, 0.0025, 0.0005)))
data$drk_drkf[data$dany=='dany2'] <- NA
data$drk_drksa <- as.numeric(sample(c('0', '1', '2', '3', '4', '5', '6', '7', '8'), 5000, replace=TRUE, prob=c(0.5, 0.26, 0.15, 0.038, 0.026, 0.018, 0.005, 0.0025, 0.0005)))
data$drk_drksa[data$dany=='dany2'] <- NA
data$drk_drksu <- as.numeric(sample(c('0', '1', '2', '3', '4', '5', '6', '7', '8'), 5000, replace=TRUE, prob=c(0.64, 0.2, 0.1, 0.04, 0.015, 0.015, 0.004, 0.0015, 0.0005)))
data$drk_drksu[data$dany=='dany2'] <- NA

data$juiu <- as.factor(sample(c('juid', 'juiw', 'juim', 'juiy'), 5000, replace=TRUE, prob=c(0.3, 0.5, 0.2, 0.1)))
data$jui <- as.numeric(sample(c('0', '1', '2', '3', '4', '5', '6', '7', '8'), 5000, replace=TRUE, prob=c(0.64, 0.2, 0.1, 0.04, 0.015, 0.015, 0.004, 0.0015, 0.0005)))
data$frtu <- as.factor(sample(c('frtd', 'frtw', 'frtm', 'frty'), 5000, replace=TRUE, prob=c(0.3, 0.5, 0.2, 0.1)))
data$frt <- as.numeric(sample(c('0', '1', '2', '3', '4', '5', '6', '7', '8'), 5000, replace=TRUE, prob=c(0.0005, 0.0015, 0.1, 0.04, 0.015, 0.015, 0.004, 0.2, 0.64)))
data$salu <- as.factor(sample(c('sald', 'salw', 'salm', 'saly'), 5000, replace=TRUE, prob=c(0.3, 0.5, 0.2, 0.1)))
data$sal <- as.numeric(sample(c('0', '1', '2', '3', '4', '5', '6', '7', '8'), 5000, replace=TRUE, prob=c(0.64, 0.2, 0.1, 0.04, 0.015, 0.015, 0.004, 0.0015, 0.0005)))
data$potu <- as.factor(sample(c('potd', 'potw', 'potm', 'poty'), 5000, replace=TRUE, prob=c(0.3, 0.5, 0.2, 0.1)))
data$pot <- as.numeric(sample(c('0', '1', '2', '3', '4', '5', '6', '7', '8'), 5000, replace=TRUE, prob=c(0.64, 0.2, 0.1, 0.04, 0.015, 0.015, 0.004, 0.0015, 0.0005)))
data$caru <- as.factor(sample(c('card', 'carw', 'carm', 'cary'), 5000, replace=TRUE, prob=c(0.3, 0.5, 0.2, 0.1)))
data$car <- as.numeric(sample(c('0', '1', '2', '3', '4', '5', '6', '7', '8'), 5000, replace=TRUE, prob=c(0.64, 0.2, 0.1, 0.04, 0.015, 0.015, 0.004, 0.0015, 0.0005)))
data$vegu <- as.factor(sample(c('vegd', 'vegw', 'vegm', 'vegy'), 5000, replace=TRUE, prob=c(0.3, 0.5, 0.2, 0.1)))
data$veg <- as.numeric(sample(c('0', '1', '2', '3', '4', '5', '6', '7', '8'), 5000, replace=TRUE, prob=c(0.64, 0.2, 0.1, 0.04, 0.015, 0.015, 0.004, 0.0015, 0.0005)))

data$diab <- as.factor(sample(c('diab1', 'diab2'), 5000, replace=TRUE, prob=c(0.1, 0.9)))
data$stk <- as.factor(sample(c('stk1', 'stk2'), 5000, replace=TRUE, prob=c(0.05, 0.95)))
data$can <- as.factor(sample(c('can1', 'can2'), 5000, replace=TRUE, prob=c(0.04, 0.96)))
data$hd <- as.factor(sample(c('hd1', 'hd2'), 5000, replace=TRUE, prob=c(0.2, 0.8)))

data$lpa_lpa1 <-as.factor(sample(c('Yes', 'No'), 5000, replace=TRUE, prob=c(0.2, 0.8)))
data$lpa_lpa2 <- as.factor(sample(c('Yes', 'No'), 5000, replace=TRUE, prob=c(0.1, 0.9)))
data$lpa_lpa3 <- as.factor(sample(c('Yes', 'No'), 5000, replace=TRUE, prob=c(0.05, 0.95)))
data$lpa_lpa4 <- as.factor(sample(c('Yes', 'No'), 5000, replace=TRUE, prob=c(0.05, 0.95)))
data$lpa_lpa5 <- as.factor(sample(c('Yes', 'No'), 5000, replace=TRUE, prob=c(0.05, 0.95)))
data$lpa_lpa6 <- as.factor(sample(c('Yes', 'No'), 5000, replace=TRUE, prob=c(0.05, 0.95)))
data$lpa_lpa7 <- as.factor(sample(c('Yes', 'No'), 5000, replace=TRUE, prob=c(0.05, 0.95)))
data$lpa_lpa8 <- as.factor(sample(c('Yes', 'No'), 5000, replace=TRUE, prob=c(0.05, 0.95)))
data$lpa_lpa9 <- as.factor(sample(c('Yes', 'No'), 5000, replace=TRUE, prob=c(0.05, 0.95)))
data$lpa_lpa10 <- as.factor(sample(c('Yes', 'No'), 5000, replace=TRUE, prob=c(0.05, 0.95)))
data$lpa_lpa11 <- as.factor(sample(c('Yes', 'No'), 5000, replace=TRUE, prob=c(0.05, 0.95)))
data$lpa_lpa12 <- as.factor(sample(c('Yes', 'No'), 5000, replace=TRUE, prob=c(0.05, 0.95)))
data$lpa_lpa13 <- as.factor(sample(c('Yes', 'No'), 5000, replace=TRUE, prob=c(0.05, 0.95)))
data$lpa_lpa14 <- as.factor(sample(c('Yes', 'No'), 5000, replace=TRUE, prob=c(0.05, 0.95)))
data$lpa_lpa15 <- as.factor(sample(c('Yes', 'No'), 5000, replace=TRUE, prob=c(0.05, 0.95)))
data$lpa_lpa16 <- as.factor(sample(c('Yes', 'No'), 5000, replace=TRUE, prob=c(0.05, 0.95)))
data$lpa_lpa17 <- as.factor(sample(c('Yes', 'No'), 5000, replace=TRUE, prob=c(0.05, 0.95)))
data$lpa_lpa18 <-as.factor(sample(c('Yes', 'No'), 5000, replace=TRUE, prob=c(0.05, 0.95)))
data$lpa_lpa19 <-  as.factor(sample(c('Yes', 'No'), 5000, replace=TRUE, prob=c(0.05, 0.95)))
data$lpa_lpa20 <- as.factor(sample(c('Yes', 'No'), 5000, replace=TRUE, prob=c(0.05, 0.95)))
data$lpa_lpa21 <- as.factor(sample(c('Yes', 'No'), 5000, replace=TRUE, prob=c(0.05, 0.95)))
data$lpa_lpa22 <- as.factor(sample(c('Yes', 'No'), 5000, replace=TRUE, prob=c(0.02, 0.98)))

data$lpat_lpa1 <- as.numeric(sample(c('1', '2', '3', '5', '8', '10', '25'), 5000, replace=TRUE, prob=c(0.4, 0.25, 0.14, 0.1, 0.05, 0.05, 0.01)))
data$lpat_lpa1[data$lpa_lpa1=='No'] <- NA
data$lpat_lpa2 <-as.numeric(sample(c('1', '2', '3', '5', '8', '10', '25'), 5000, replace=TRUE, prob=c(0.4, 0.25, 0.14, 0.1, 0.05, 0.05, 0.01)))
data$lpat_lpa2[data$lpa_lpa2=='No'] <- NA
data$lpat_lpa3 <-as.numeric(sample(c('1', '2', '3', '5', '8', '10', '25'), 5000, replace=TRUE, prob=c(0.4, 0.25, 0.14, 0.1, 0.05, 0.05, 0.01)))
data$lpat_lpa3[data$lpa_lpa3=='No'] <- NA
data$lpat_lpa4 <-as.numeric(sample(c('1', '2', '3', '5', '8', '10', '25'), 5000, replace=TRUE, prob=c(0.4, 0.25, 0.14, 0.1, 0.05, 0.05, 0.01)))
data$lpat_lpa4[data$lpa_lpa4=='No'] <- NA
data$lpat_lpa5 <-as.numeric(sample(c('1', '2', '3', '5', '8', '10', '25'), 5000, replace=TRUE, prob=c(0.4, 0.25, 0.14, 0.1, 0.05, 0.05, 0.01)))
data$lpat_lpa5[data$lpa_lpa5=='No'] <- NA
data$lpat_lpa6 <-as.numeric(sample(c('1', '2', '3', '5', '8', '10', '25'), 5000, replace=TRUE, prob=c(0.4, 0.25, 0.14, 0.1, 0.05, 0.05, 0.01)))
data$lpat_lpa6[data$lpa_lpa6=='No'] <- NA
data$lpat_lpa7 <-as.numeric(sample(c('1', '2', '3', '5', '8', '10', '25'), 5000, replace=TRUE, prob=c(0.4, 0.25, 0.14, 0.1, 0.05, 0.05, 0.01)))
data$lpat_lpa7[data$lpa_lpa7=='No'] <- NA
data$lpat_lpa8 <-as.numeric(sample(c('1', '2', '3', '5', '8', '10', '25'), 5000, replace=TRUE, prob=c(0.4, 0.25, 0.14, 0.1, 0.05, 0.05, 0.01)))
data$lpat_lpa8[data$lpa_lpa8=='No'] <- NA
data$lpat_lpa9 <-as.numeric(sample(c('1', '2', '3', '5', '8', '10', '25'), 5000, replace=TRUE, prob=c(0.4, 0.25, 0.14, 0.1, 0.05, 0.05, 0.01)))
data$lpat_lpa9[data$lpa_lpa9=='No'] <- NA
data$lpat_lpa10 <-as.numeric(sample(c('1', '2', '3', '5', '8', '10', '25'), 5000, replace=TRUE, prob=c(0.4, 0.25, 0.14, 0.1, 0.05, 0.05, 0.01)))
data$lpat_lpa10[data$lpa_lpa10=='No'] <- NA
data$lpat_lpa11 <-as.numeric(sample(c('1', '2', '3', '5', '8', '10', '25'), 5000, replace=TRUE, prob=c(0.4, 0.25, 0.14, 0.1, 0.05, 0.05, 0.01)))
data$lpat_lpa11[data$lpa_lpa11=='No'] <- NA
data$lpat_lpa12 <-as.numeric(sample(c('1', '2', '3', '5', '8', '10', '25'), 5000, replace=TRUE, prob=c(0.4, 0.25, 0.14, 0.1, 0.05, 0.05, 0.01)))
data$lpat_lpa12[data$lpa_lpa12=='No'] <- NA
data$lpat_lpa13 <-as.numeric(sample(c('1', '2', '3', '5', '8', '10', '25'), 5000, replace=TRUE, prob=c(0.4, 0.25, 0.14, 0.1, 0.05, 0.05, 0.01)))
data$lpat_lpa13[data$lpa_lpa13=='No'] <- NA
data$lpat_lpa14 <-as.numeric(sample(c('1', '2', '3', '5', '8', '10', '25'), 5000, replace=TRUE, prob=c(0.4, 0.25, 0.14, 0.1, 0.05, 0.05, 0.01)))
data$lpat_lpa14[data$lpa_lpa14=='No'] <- NA
data$lpat_lpa15 <-as.numeric(sample(c('1', '2', '3', '5', '8', '10', '25'), 5000, replace=TRUE, prob=c(0.4, 0.25, 0.14, 0.1, 0.05, 0.05, 0.01)))
data$lpat_lpa15[data$lpa_lpa15=='No'] <- NA
data$lpat_lpa16 <-as.numeric(sample(c('1', '2', '3', '5', '8', '10', '25'), 5000, replace=TRUE, prob=c(0.4, 0.25, 0.14, 0.1, 0.05, 0.05, 0.01)))
data$lpat_lpa16[data$lpa_lpa16=='No'] <- NA
data$lpat_lpa17 <-as.numeric(sample(c('1', '2', '3', '5', '8', '10', '25'), 5000, replace=TRUE, prob=c(0.4, 0.25, 0.14, 0.1, 0.05, 0.05, 0.01)))
data$lpat_lpa17[data$lpa_lpa17=='No'] <- NA
data$lpat_lpa18 <-as.numeric(sample(c('1', '2', '3', '5', '8', '10', '25'), 5000, replace=TRUE, prob=c(0.4, 0.25, 0.14, 0.1, 0.05, 0.05, 0.01)))
data$lpat_lpa18[data$lpa_lpa18=='No'] <- NA
data$lpat_lpa19 <-as.numeric(sample(c('1', '2', '3', '5', '8', '10', '25'), 5000, replace=TRUE, prob=c(0.4, 0.25, 0.14, 0.1, 0.05, 0.05, 0.01)))
data$lpat_lpa19[data$lpa_lpa19=='No'] <- NA
data$lpat_lpa20 <-as.numeric(sample(c('1', '2', '3', '5', '8', '10', '25'), 5000, replace=TRUE, prob=c(0.4, 0.25, 0.14, 0.1, 0.05, 0.05, 0.01)))
data$lpat_lpa20[data$lpa_lpa20=='No'] <- NA
data$lpat_lpa21 <-as.numeric(sample(c('1', '2', '3', '5', '8', '10', '25'), 5000, replace=TRUE, prob=c(0.4, 0.25, 0.14, 0.1, 0.05, 0.05, 0.01)))
data$lpat_lpa21[data$lpa_lpa21=='No'] <- NA
data$lpat_lpa22 <-as.numeric(sample(c('1', '2', '3', '5', '8', '10', '25'), 5000, replace=TRUE, prob=c(0.4, 0.25, 0.14, 0.1, 0.05, 0.05, 0.01)))
data$lpat_lpa22[data$lpa_lpa22=='No'] <- NA

data$lpam_lpa1 <-as.factor(sample(c('lpa15', 'lpa30', "lpa60", "lpa61"), 5000, replace=TRUE, prob=c(0.2, 0.40, 0.2, 0.2)))
data$lpam_lpa1[data$lpa_lpa1=='No'] <- NA
data$lpam_lpa2 <-as.factor(sample(c('lpa15', 'lpa30', "lpa60", "lpa61"), 5000, replace=TRUE, prob=c(0.2, 0.40, 0.2, 0.2)))
data$lpam_lpa2[data$lpa_lpa2=='No'] <- NA
data$lpam_lpa3 <-as.factor(sample(c('lpa15', 'lpa30', "lpa60", "lpa61"), 5000, replace=TRUE, prob=c(0.2, 0.40, 0.2, 0.2)))
data$lpam_lpa3[data$lpa_lpa3=='No'] <- NA
data$lpam_lpa4 <-as.factor(sample(c('lpa15', 'lpa30', "lpa60", "lpa61"), 5000, replace=TRUE, prob=c(0.2, 0.40, 0.2, 0.2)))
data$lpam_lpa4[data$lpa_lpa4=='No'] <- NA
data$lpam_lpa5 <-as.factor(sample(c('lpa15', 'lpa30', "lpa60", "lpa61"), 5000, replace=TRUE, prob=c(0.2, 0.40, 0.2, 0.2)))
data$lpam_lpa5[data$lpa_lpa5=='No'] <- NA
data$lpam_lpa6 <-as.factor(sample(c('lpa15', 'lpa30', "lpa60", "lpa61"), 5000, replace=TRUE, prob=c(0.2, 0.40, 0.2, 0.2)))
data$lpam_lpa6[data$lpa_lpa6=='No'] <- NA
data$lpam_lpa7 <-as.factor(sample(c('lpa15', 'lpa30', "lpa60", "lpa61"), 5000, replace=TRUE, prob=c(0.2, 0.40, 0.2, 0.2)))
data$lpam_lpa7[data$lpa_lpa7=='No'] <- NA
data$lpam_lpa8 <-as.factor(sample(c('lpa15', 'lpa30', "lpa60", "lpa61"), 5000, replace=TRUE, prob=c(0.2, 0.40, 0.2, 0.2)))
data$lpam_lpa8[data$lpa_lpa8=='No'] <- NA
data$lpam_lpa9 <-as.factor(sample(c('lpa15', 'lpa30', "lpa60", "lpa61"), 5000, replace=TRUE, prob=c(0.2, 0.40, 0.2, 0.2)))
data$lpam_lpa9[data$lpa_lpa9=='No'] <- NA
data$lpam_lpa10 <-as.factor(sample(c('lpa15', 'lpa30', "lpa60", "lpa61"), 5000, replace=TRUE, prob=c(0.2, 0.40, 0.2, 0.2)))
data$lpam_lpa10[data$lpa_lpa10=='No'] <- NA
data$lpam_lpa11 <-as.factor(sample(c('lpa15', 'lpa30', "lpa60", "lpa61"), 5000, replace=TRUE, prob=c(0.2, 0.40, 0.2, 0.2)))
data$lpam_lpa11[data$lpa_lpa11=='No'] <- NA
data$lpam_lpa12 <-as.factor(sample(c('lpa15', 'lpa30', "lpa60", "lpa61"), 5000, replace=TRUE, prob=c(0.2, 0.40, 0.2, 0.2)))
data$lpam_lpa12[data$lpa_lpa12=='No'] <- NA
data$lpam_lpa13 <-as.factor(sample(c('lpa15', 'lpa30', "lpa60", "lpa61"), 5000, replace=TRUE, prob=c(0.2, 0.40, 0.2, 0.2)))
data$lpam_lpa13[data$lpa_lpa13=='No'] <- NA
data$lpam_lpa14 <-as.factor(sample(c('lpa15', 'lpa30', "lpa60", "lpa61"), 5000, replace=TRUE, prob=c(0.2, 0.40, 0.2, 0.2)))
data$lpam_lpa14[data$lpa_lpa14=='No'] <- NA
data$lpam_lpa15 <-as.factor(sample(c('lpa15', 'lpa30', "lpa60", "lpa61"), 5000, replace=TRUE, prob=c(0.2, 0.40, 0.2, 0.2)))
data$lpam_lpa15[data$lpa_lpa15=='No'] <- NA
data$lpam_lpa16 <-as.factor(sample(c('lpa15', 'lpa30', "lpa60", "lpa61"), 5000, replace=TRUE, prob=c(0.2, 0.40, 0.2, 0.2)))
data$lpam_lpa16[data$lpa_lpa16=='No'] <- NA
data$lpam_lpa17 <-as.factor(sample(c('lpa15', 'lpa30', "lpa60", "lpa61"), 5000, replace=TRUE, prob=c(0.2, 0.40, 0.2, 0.2)))
data$lpam_lpa17[data$lpa_lpa17=='No'] <- NA
data$lpam_lpa18 <-as.factor(sample(c('lpa15', 'lpa30', "lpa60", "lpa61"), 5000, replace=TRUE, prob=c(0.2, 0.40, 0.2, 0.2)))
data$lpam_lpa18[data$lpa_lpa18=='No'] <- NA
data$lpam_lpa19 <-as.factor(sample(c('lpa15', 'lpa30', "lpa60", "lpa61"), 5000, replace=TRUE, prob=c(0.2, 0.40, 0.2, 0.2)))
data$lpam_lpa19[data$lpa_lpa19=='No'] <- NA
data$lpam_lpa20 <-as.factor(sample(c('lpa15', 'lpa30', "lpa60", "lpa61"), 5000, replace=TRUE, prob=c(0.2, 0.40, 0.2, 0.2)))
data$lpam_lpa20[data$lpa_lpa20=='No'] <- NA
data$lpam_lpa21 <-as.factor(sample(c('lpa15', 'lpa30', "lpa60", "lpa61"), 5000, replace=TRUE, prob=c(0.2, 0.40, 0.2, 0.2)))
data$lpam_lpa21[data$lpa_lpa21=='No'] <- NA
data$lpam_lpa22 <-as.factor(sample(c('lpa15', 'lpa30', "lpa60", "lpa61"), 5000, replace=TRUE, prob=c(0.2, 0.40, 0.2, 0.2)))
data$lpam_lpa22[data$lpa_lpa22=='No'] <- NA

str(data)


## Data Pre-processing
# No Response: 99
databox <- WrapData(data)

##Demographics##
#Sex
databox <- FunctionXform(databox, origFieldName= "sex", newFieldName= "Demographics.sex", formulaText= "if(sex=='fem'){1} else if(sex=='male'){0}")

#Age
databox <- RenameVar(databox, "age->Demographics.age")

#Age Spline
databox <- FunctionXform(databox, origFieldName= c("sex", "Demographics.age"), newFieldName= "Demographics.agespline", formulaText= "if(sex=='fem' && Demographics.age>80){Demographics.age-80} else if(sex=='fem'){0} else if(sex=='male' && Demographics.age>65){Demographics.age-65} else {0}")

#Education
databox <- FunctionXform(databox, origFieldName= c("hs", "ed"), newFieldName= "Demographics.edu_nograd", formulaText= "if(hs=='hs2' && ed=='ed2'){1} else {0}")
databox <- FunctionXform(databox, origFieldName= c("hs", "ed", "hdg"), newFieldName= "Demographics.edu_hsgrad", formulaText= "if((hs=='hs1' && ed=='ed2') | (hs=='hs1' && ed=='ed1' && hdg=='hdg1')){1} else {0}")

#Deprivation

#databox <-FunctionXform(databox, origFieldName= c(), newFieldName= "Demographics.dep_high", formulaText="")
#databox <-FunctionXform(databox, origFieldName= c(), newFieldName= "Demographics.dep_low", formulaText="")

#Immigration
databox <- FunctionXform(databox, origFieldName= c("immm", "imyr"), newFieldName= "Demographics.immig_015", formulaText= "if(imm=='imm2' && imyr>=1 && imyr<=15){1} else if(imm=='imm1'|imyr>15){0} else {0}")
databox <- FunctionXform(databox, origFieldName= c("immm", "imyr"), newFieldName= "Demographics.immig_1630", formulaText= "if(imm=='imm2' && imyr>15 && imyr<=30){1} else if(imm=='imm1' | imyr<=15 | imyr>30){0} else {0}")
databox <- FunctionXform(databox, origFieldName= c("immm", "imyr"), newFieldName= "Demographics.immig_3145", formulaText= "if(imm=='imm2' && imyr>30 && imyr<=45){1} else if(imm=='imm1'|imyr<=30|imyr>45){0} else {0}")

##Health Behaviours##
#Smoking
databox <- FunctionXform(databox, origFieldName= c("smk", "s100", "evdn", "cigdayd", "cigdayf"), newFieldName= "formerlightflag", formulaText= "if(smk=='smk3' && evdn=='evdn1' && cigdayf<20){1} else if(smk=='smk3' && evdn=='evdn2' && s100=='s1001'){1} else {0}")
databox <- FunctionXform(databox, origFieldName= c("s100", "smk", "cigdayd", "evdn", "cigdayf"), newFieldName= "formerheavyflag", formulaText= "if(smk=='smk3' && evdn=='evdn1' && cigdayf>=20){1} else {0}")
databox <- FunctionXform(databox, origFieldName= c("formerlightflag", "formerheavyflag", "stpn", "stpny"), newFieldName= "quittime", formulaText= "if(formerlightflag==0 | formerheavyflag==0) {0} else if(smk=='smk1' | (smk=='smk3' && evdn=='evdn2' && s100='s1002')){0} else if(stpn=='stpn1'){0} else if(stpn=='stpn2'){1} else if(stpn=='stpn3'){2} else if(stpn=='stpn4'){stpny} else {NA}")
databox <- FunctionXform(databox, origFieldName= c("s100", "smk", "cigdayd", "evdn", "cigdayf"), newFieldName= "smk_lightraw", formulaText= "if(smk=='smk1' && cigdayd<20){1} else if(smk=='smk2'){1} else if(smk=='smk3' && evdn=='evdn1' && cigdayf<20){1} else if (smk=='smk3' && evdn=='evdn2' && s100=='s1001'){1} else {0}")
databox <- FunctionXform(databox, origFieldName= c("s100", "smk", "cigdayd", "evdn", "cigdayf"), newFieldName= "smk_heavyraw", formulaText= "if(smk=='smk1' && cigdayd>=20){1} else if(smk=='smk3' && evdn=='evdn1' && cigdayf>=20){1} else {0}")
databox <- FunctionXform(databox, origFieldName= c("smk_lightraw", "sex", "quittime"), newFieldName= "Behaviours.smk_light", formulaText= "if(formerlightflag==1 && sex=='fem'){exp(quittime/26)} else if(formerlightflag==1 && sex=='male'){exp(quittime/15)} else {smk_lightraw}")
databox <- FunctionXform(databox, origFieldName= c("smk_heavyraw", "sex", "quittime"), newFieldName= "Behaviours.smk_heavy", formulaText= "if(formerheavyflag==1 && sex=='fem'){exp(quittime/26)} else if(formerheavyflag==1 && sex=='male'){exp(quittime/15)} else {smk_heavyraw}")

#Activity
databox <- FunctionXform(databox, origFieldName= "lpa_lpa1", newFieldName= "walking", formulaText= "if(lpa_lpa1=='Yes'){1} else {0}")
databox <- FunctionXform(databox, origFieldName= "lpat_lpa1", newFieldName= "walking_t", formulaText= "if(is.na(lpat_lpa1)){0} else {lpat_lpa1}")
databox <- FunctionXform(databox, origFieldName= "lpam_lpa1", newFieldName= "walking_h", formulaText= "if(is.na(lpam_lpa1)){0} else if(lpam_lpa1=='lpa1'){0.2167} else if(lpam_lpa1=='lpa2'){0.3833} else if(lpam_lpa1=='lpa3'){0.75} else if(lpam_lpa1=='lpa4'){1} else {0}")
databox <- FunctionXform(databox, origFieldName= "lpa_lpa2", newFieldName= "garden", formulaText= "if(lpa_lpa2=='Yes'){1} else {0}")
databox <- FunctionXform(databox, origFieldName= "lpat_lpa2", newFieldName= "garden_t", formulaText= "if(is.na(lpat_lpa2)){0} else {lpat_lpa2}")
databox <- FunctionXform(databox, origFieldName= "lpam_lpa2", newFieldName= "garden_h", formulaText= "if(is.na(lpam_lpa2)){0} else if(lpam_lpa2=='lpa15'){0.2167} else if(lpam_lpa2=='lpa30'){0.3833} else if(lpam_lpa2=='lpa60'){0.75} else if(lpam_lpa2=='lpa61'){1} else {0}")
databox <- FunctionXform(databox, origFieldName= "lpa_lpa3", newFieldName= "swim", formulaText= "if(lpa_lpa3=='Yes'){1} else {0}")
databox <- FunctionXform(databox, origFieldName= "lpat_lpa3", newFieldName= "swim_t", formulaText= "if(is.na(lpat_lpa3)){0} else {lpat_lpa3}")
databox <- FunctionXform(databox, origFieldName= "lpam_lpa3", newFieldName= "swim_h", formulaText= "if(is.na(lpam_lpa3)){0} else if(lpam_lpa3=='lpa15'){0.2167} else if(lpam_lpa3=='lpa30'){0.3833} else if(lpam_lpa3=='lpa60'){0.75} else if(lpam_lpa3=='lpa61'){1} else {0}")
databox <- FunctionXform(databox, origFieldName= "lpa_lpa4", newFieldName= "bike", formulaText= "if(lpa_lpa4=='Yes'){1} else {0}")
databox <- FunctionXform(databox, origFieldName= "lpat_lpa4", newFieldName= "bike_t", formulaText= "if(is.na(lpat_lpa4)){0} else {lpat_lpa4}")
databox <- FunctionXform(databox, origFieldName= "lpam_lpa4", newFieldName= "bike_h", formulaText= "if(is.na(lpam_lpa4)){0} else if(lpam_lpa4=='lpa15'){0.2167} else if(lpam_lpa4=='lpa30'){0.3833} else if(lpam_lpa4=='lpa60'){0.75} else if(lpam_lpa4=='lpa61'){1} else {0}")
databox <- FunctionXform(databox, origFieldName= "lpa_lpa5", newFieldName= "dance", formulaText= "if(lpa_lpa5=='Yes'){1} else {0}")
databox <- FunctionXform(databox, origFieldName= "lpat_lpa5", newFieldName= "dance_t", formulaText= "if(is.na(lpat_lpa5)){0} else {lpat_lpa5}")
databox <- FunctionXform(databox, origFieldName= "lpam_lpa5", newFieldName= "dance_h", formulaText= "if(is.na(lpam_lpa5)){0} else if(lpam_lpa5=='lpa15'){0.2167} else if(lpam_lpa5=='lpa30'){0.3833} else if(lpam_lpa5=='lpa60'){0.75} else if(lpam_lpa5=='lpa61'){1} else {0}")
databox <- FunctionXform(databox, origFieldName= "lpa_lpa6", newFieldName= "hexercises", formulaText= "if(lpa_lpa6=='Yes'){1} else {0}")
databox <- FunctionXform(databox, origFieldName= "lpat_lpa6", newFieldName= "hexercises_t", formulaText= "if(is.na(lpat_lpa6)){0} else {lpat_lpa6}")
databox <- FunctionXform(databox, origFieldName= "lpam_lpa6", newFieldName= "hexercises_h", formulaText= "if(is.na(lpam_lpa6)){0} else if(lpam_lpa6=='lpa15'){0.2167} else if(lpam_lpa6=='lpa30'){0.3833} else if(lpam_lpa6=='lpa60'){0.75} else if(lpam_lpa6=='lpa61'){1} else {0}")
databox <- FunctionXform(databox, origFieldName= "lpa_lpa7", newFieldName= "hockey", formulaText= "if(lpa_lpa7=='Yes'){1} else {0}")
databox <- FunctionXform(databox, origFieldName= "lpat_lpa7", newFieldName= "hockey_t", formulaText= "if(is.na(lpat_lpa7)){0} else {lpat_lpa7}")
databox <- FunctionXform(databox, origFieldName= "lpam_lpa7", newFieldName= "hockey_h", formulaText= "if(is.na(lpam_lpa7)){0} else if(lpam_lpa7=='lpa15'){0.2167} else if(lpam_lpa7=='lpa30'){0.3833} else if(lpam_lpa7=='lpa60'){0.75} else if(lpam_lpa7=='lpa61'){1} else {0}")
databox <- FunctionXform(databox, origFieldName= "lpa_lpa8", newFieldName= "skate", formulaText= "if(lpa_lpa8=='Yes'){1} else {0}")
databox <- FunctionXform(databox, origFieldName= "lpat_lpa8", newFieldName= "skate_t", formulaText= "if(is.na(lpat_lpa8)){0} else {lpat_lpa8}")
databox <- FunctionXform(databox, origFieldName= "lpam_lpa8", newFieldName= "skate_h", formulaText= "if(is.na(lpam_lpa8)){0} else if(lpam_lpa8=='lpa15'){0.2167} else if(lpam_lpa8=='lpa30'){0.3833} else if(lpam_lpa8=='lpa60'){0.75} else if(lpam_lpa8=='lpa61'){1} else {0}")
databox <- FunctionXform(databox, origFieldName= "lpa_lpa9", newFieldName= "inline", formulaText= "if(lpa_lpa9=='Yes'){1} else {0}")
databox <- FunctionXform(databox, origFieldName= "lpat_lpa9", newFieldName= "inline_t", formulaText= "if(is.na(lpat_lpa9)){0} else {lpat_lpa9}")
databox <- FunctionXform(databox, origFieldName= "lpam_lpa9", newFieldName= "inline_h", formulaText= "if(is.na(lpam_lpa9)){0} else if(lpam_lpa9=='lpa15'){0.2167} else if(lpam_lpa9=='lpa30'){0.3833} else if(lpam_lpa9=='lpa60'){0.75} else if(lpat_lpa9=='lpa61'){1} else {0}")
databox <- FunctionXform(databox, origFieldName= "lpa_lpa10", newFieldName= "jogrun", formulaText= "if(lpa_lpa10=='Yes'){1} else {0}")
databox <- FunctionXform(databox, origFieldName= "lpat_lpa10", newFieldName= "jogrun_t", formulaText= "if(is.na(lpat_lpa10)){0} else {lpat_lpa10}")
databox <- FunctionXform(databox, origFieldName= "lpat_lpa10", newFieldName= "jogrun_h", formulaText= "if(is.na(lpat_lpa10)){0} else if(lpat_lpa10=='lpa15'){0.2167} else if(lpat_lpa10=='lpa30'){0.3833} else if(lpat_lpa10=='lpa60'){0.75} else if(lpat_lpa10=='lpa61'){1} else {0}")
databox <- FunctionXform(databox, origFieldName= "lpa_lpa11", newFieldName= "golf", formulaText= "if(lpa_lpa11=='Yes'){1} else {0}")
databox <- FunctionXform(databox, origFieldName= "lpat_lpa11", newFieldName= "golf_t", formulaText= "if(is.na(lpat_lpa11)){0} else {lpat_lpa11}")
databox <- FunctionXform(databox, origFieldName= "lpam_lpa11", newFieldName= "golf_h", formulaText= "if(is.na(lpam_lpa11)){0} else if(lpam_lpa11=='lpa15'){0.2167} else if(lpam_lpa11=='lpa30'){0.3833} else if(lpam_lpa11=='lpa60'){0.75} else if(lpam_lpa11=='lpa61'){1} else {0}")
databox <- FunctionXform(databox, origFieldName= "lpa_lpa12", newFieldName= "aerobics", formulaText= "if(lpa_lpa12=='Yes'){1} else {0}")
databox <- FunctionXform(databox, origFieldName= "lpat_lpa12", newFieldName= "aerobics_t", formulaText= "if(is.na(lpat_lpa12)){0} else {lpat_lpa12}")
databox <- FunctionXform(databox, origFieldName= "lpam_lpa12", newFieldName= "aerobics_h", formulaText= "if(is.na(lpam_lpa12)){0} else if(lpam_lpa12=='lpa15'){0.2167} else if(lpam_lpa12=='lpa30'){0.3833} else if(lpam_lpa12=='lpa60'){0.75} else if(lpam_lpa12=='lpa61'){1} else {0}")
databox <- FunctionXform(databox, origFieldName= "lpa_lpa13", newFieldName= "ski", formulaText= "if(lpa_lpa13=='Yes'){1} else {0}")
databox <- FunctionXform(databox, origFieldName= "lpat_lpa13", newFieldName= "ski_t", formulaText= "if(is.na(lpat_lpa13)){0} else {lpat_lpa13}")
databox <- FunctionXform(databox, origFieldName= "lpam_lpa13", newFieldName= "ski_h", formulaText= "if(is.na(lpam_lpa13)){0} else if(lpam_lpa13=='lpa15'){0.2167} else if(lpam_lpa13=='lpa30'){0.3833} else if(lpam_lpa13=='lpa60'){0.75} else if(lpam_lpa13=='lpa61'){1} else {0}")
databox <- FunctionXform(databox, origFieldName= "lpa_lpa14", newFieldName= "bowl", formulaText= "if(lpa_lpa14=='Yes'){1} else {0}")
databox <- FunctionXform(databox, origFieldName= "lpat_lpa14", newFieldName= "bowl_t", formulaText= "if(is.na(lpat_lpa14)){0} else {lpat_lpa14}")
databox <- FunctionXform(databox, origFieldName= "lpam_lpa14", newFieldName= "bowl_h", formulaText= "if(is.na(lpam_lpa14)){0} else if(lpam_lpa14=='lpa15'){0.2167} else if(lpam_lpa14=='lpa30'){0.3833} else if(lpam_lpa14=='lpa60'){0.75} else if(lpam_lpa14=='lpa61'){1} else {0}")
databox <- FunctionXform(databox, origFieldName= "lpa_lpa15", newFieldName= "baseball", formulaText= "if(lpa_lpa15=='Yes'){1} else {0}")
databox <- FunctionXform(databox, origFieldName= "lpat_lpa15", newFieldName= "baseball_t", formulaText= "if(is.na(lpat_lpa15)){0} else {lpat_lpa15}")
databox <- FunctionXform(databox, origFieldName= "lpam_lpa15", newFieldName= "baseball_h", formulaText= "if(is.na(lpam_lpa15)){0} else if(lpam_lpa15=='lpa15'){0.2167} else if(lpam_lpa15=='lpa30'){0.3833} else if(lpam_lpa15=='lpa60'){0.75} else if(lpam_lpa15=='lpa61'){1} else {0}")
databox <- FunctionXform(databox, origFieldName= "lpa_lpa16", newFieldName= "tennis", formulaText= "if(lpa_lpa16=='Yes'){1} else {0}")
databox <- FunctionXform(databox, origFieldName= "lpat_lpa16", newFieldName= "tennis_t", formulaText= "if(is.na(lpat_lpa16)){0} else {lpat_lpa16}")
databox <- FunctionXform(databox, origFieldName= "lpam_lpa16", newFieldName= "tennis_h", formulaText= "if(is.na(lpam_lpa16)){0} else if(lpam_lpa16=='lpa15'){0.2167} else if(lpam_lpa16=='lpa30'){0.3833} else if(lpam_lpa16=='lpa60'){0.75} else if(lpam_lpa16=='lpa61'){1} else {0}")
databox <- FunctionXform(databox, origFieldName= "lpa_lpa17", newFieldName= "weights", formulaText= "if(lpa_lpa17=='Yes'){1} else {0}")
databox <- FunctionXform(databox, origFieldName= "lpat_lpa17", newFieldName= "weights_t", formulaText= "if(is.na(lpat_lpa17)){0} else {lpat_lpa17}")
databox <- FunctionXform(databox, origFieldName= "lpam_lpa17", newFieldName= "weights_h", formulaText= "if(is.na(lpam_lpa17)){0} else if(lpam_lpa17=='lpa15'){0.2167} else if(lpam_lpa17=='lpa30'){0.3833} else if(lpam_lpa17=='lpa60'){0.75} else if(lpam_lpa17=='lpa61'){1} else {0}")
databox <- FunctionXform(databox, origFieldName= "lpa_lpa18", newFieldName= "fishing", formulaText= "if(lpa_lpa18=='Yes'){1} else {0}")
databox <- FunctionXform(databox, origFieldName= "lpat_lpa18", newFieldName= "fishing_t", formulaText= "if(is.na(lpat_lpa18)){0} else {lpat_lpa18}")
databox <- FunctionXform(databox, origFieldName= "lpam_lpa18", newFieldName= "fishing_h", formulaText= "if(is.na(lpam_lpa18)){0} else if(lpam_lpa18=='lpa15'){0.2167} else if(lpam_lpa18=='lpa30'){0.3833} else if(lpam_lpa18=='lpa60'){0.75} else if(lpam_lpa18=='lpa61'){1} else {0}")
databox <- FunctionXform(databox, origFieldName= "lpa_lpa19", newFieldName= "volleyball", formulaText= "if(lpa_lpa19=='Yes'){1} else {0}")
databox <- FunctionXform(databox, origFieldName= "lpat_lpa19", newFieldName= "volleyball_t", formulaText= "if(is.na(lpat_lpa19)){0} else {lpat_lpa19}")
databox <- FunctionXform(databox, origFieldName= "lpam_lpa19", newFieldName= "volleyball_h", formulaText= "if(is.na(lpam_lpa19)){0} else if(lpam_lpa19=='lpa15'){0.2167} else if(lpam_lpa19=='lpa30'){0.3833} else if(lpam_lpa19=='lpa60'){0.75} else if(lpam_lpa19=='lpa61'){1} else {0}")
databox <- FunctionXform(databox, origFieldName= "lpa_lpa20", newFieldName= "basketball", formulaText= "if(lpa_lpa20=='Yes'){1} else {0}")
databox <- FunctionXform(databox, origFieldName= "lpat_lpa20", newFieldName= "basketball_t", formulaText= "if(is.na(lpat_lpa20)){0} else {lpat_lpa20}")
databox <- FunctionXform(databox, origFieldName= "lpam_lpa20", newFieldName= "basketball_h", formulaText= "if(is.na(lpam_lpa20)){0} else if(lpam_lpa20=='lpa15'){0.2167} else if(lpam_lpa20=='lpa30'){0.3833} else if(lpam_lpa20=='lpa60'){0.75} else if(lpam_lpa20=='lpa61'){1} else {0}")
databox <- FunctionXform(databox, origFieldName= "lpa_lpa21", newFieldName= "soccer", formulaText= "if(lpa_lpa21=='Yes'){1} else {0}")
databox <- FunctionXform(databox, origFieldName= "lpat_lpa21", newFieldName= "soccer_t", formulaText= "if(is.na(lpat_lpa21)){0} else {lpat_lpa21}")
databox <- FunctionXform(databox, origFieldName= "lpam_lpa21", newFieldName= "soccer_h", formulaText= "if(is.na(lpam_lpa21)){0} else if(lpam_lpa21=='lpa15'){0.2167} else if(lpam_lpa21=='lpa30'){0.3833} else if(lpam_lpa21=='lpa60'){0.75} else if(lpam_lpa21=='lpa61'){1} else {0}")
databox <- FunctionXform(databox, origFieldName= "lpa_lpa22", newFieldName= "other", formulaText= "if(lpa_lpa22=='Yes'){1} else {0}")
databox <- FunctionXform(databox, origFieldName= "lpat_lpa22", newFieldName= "other_t", formulaText= "if(is.na(lpat_lpa22)){0} else {lpat_lpa22}")
databox <- FunctionXform(databox, origFieldName= "lpam_lpa22", newFieldName= "other_h", formulaText= "if(is.na(lpam_lpa22)){0} else if(lpam_lpa22=='lpa15'){0.2167} else if(lpat_lpa22=='lpa30'){0.3833} else if(lpam_lpa22=='lpa60'){0.75} else if(lpam_lpa22=='lpa61'){1} else {0}")
databox <- FunctionXform(databox, origFieldName= c("walking", "walking_t", "walking_h", "garden", "garden_t", "garden_h", "swim", "swim_t", "swim_h", "bike", "bike_t", "bike_h", "dance", "dance_t", "dance_h", "hexercises", "hexercises_t","hexercises_h", "hockey", "hockey_t", "hockey_h", "skate", "skate_t", "skate_h", "inline", "inline_t", "inline_h", "jogrun", "jogrun_t", "jogrun_h", "golf", "golf_t", "golf_h", "aerobics", "aerobics_t", "aerobics_h", "ski", "ski_t", "ski_h", "bowl", "bowl_t", "bowl_h", "baseball", "baseball_t", "baseball_h", "tennis", "tennis_t", "tennis_h", "weights", "weights_t", "weights_h", "fishing", "fishing_t", "fishing_h", "volleyball", "volleyball_t", "volleyball_h", "basketball", "basketball_t", "baseketball_h", "soccer", "soccer_t", "soccer_h", "other", "other_t", "other_h"), newFieldName= "Behaviours.activity", formulaText="{(walking*walking_h*3*walking_t)/90 + (garden*garden_h*3*garden_t)/90 + (swim*swim_h*3*swim_t)/90 + (bike*bike_h*4*bike_t)/90 + (dance*dance_h*3*dance_t)/90 + (hexercises*hexercises_h*3*hexercises_t)/90 + (hockey*hockey_h*6*hockey_t)/90 + (skate*skate_h*4*skate_t)/90 + (inline*inline_h*5*inline_t)/90 + (jogrun*jogrun_h*9.5*jogrun_t)/90 + (golf*golf_h*4*golf_t)/90 + (aerobics*aerobics_h*4*aerobics_t)/90 + (ski*ski_h*4*ski_t)/90 + (bowl*bowl_h*2*bowl_t)/90 + (baseball*baseball_h*3*baseball_t)/90 + (tennis*tennis_h*4*tennis_t)/90 + (weights*weights_h*3*weights_t)/90 + (fishing*fishing_h*3*fishing_t)/90 + (volleyball*volleyball_h*5*volleyball_t)/90 + (basketball*basketball_h*6*basketball_t)/90 + (soccer*soccer_h*5*soccer_t)/90 + (other*other_h*4*other_t)/90}")

#Alcohol
databox <- FunctionXform(databox, origFieldName=c("dev", "dany", "drk_drkm", "drk_drkt", "drk_drkw", "drk_drkr", "drk_drksa", "drk_drksu"), newFieldName= "weeklyalc", formulaText="if(dev=='dev2'){NA} else if(dev=='dev1' && dany=='dany1'){drk_drkm + drk_drkt + drk_drkw + drk_drkr + drk_drkf + drk_drksa + drk_drksu} else {0}")
databox <- FunctionXform(databox, origFieldName=c("db", "drk_drkm", "drk_drkt", "drk_drkw", "drk_drkr", "drk_drkf", "drk_drksa", "drk_drksu"), newFieldName= "bingeflag", formulaText= "if(dev=='dev2'){NA} else if(!is.na(db) && (db=='db5' | db=='db6')){1} else if(!is.na(drk_drkm) && drk_drkm>=5){1} else if(!is.na(drk_drkt) && drk_drkt){1} else if(!is.na(drk_drkw) && drk_drkw>=5){1} else if(!is.na(drk_drkr) && drk_drkr>=5){1} else if(!is.na(drk_drkf) && drk_drkf>=5){1} else if(!is.na(drk_drksa) && drk_drksa>=5){1} else if(!is.na(drk_drksu) && drk_drksu>=5){1} else {NA}")
databox <- FunctionXform(databox, origFieldName= c("dev", "bingeflag", "dany", "weeklyalc", "db", "Demographics.sex"), newFieldName= "Behaviours.alc_mod", formulaText= "if(!is.na(bingeflag) && bingeflag==1){0} else if(Demographics.sex==0 && dev=='dev1' && dany=='dany1' && weeklyalc>3 && weeklyalc <=21){1} else if(Demographics.sex==1 && dev=='dev1' && dany=='dany1' && weeklyalc>2 && weeklyalc <=14){1} else if(Demographics.sex==0 && dev=='dev1' && dany=='dany1' && weeklyalc<=3){0} else if(Demographics.sex==1 && dev=='dev1' && dany=='dany1' && weeklyalc<=2){0} else if(Demographics.sex==0 && dev=='dev1' && dany=='dany1' && weeklyalc>21){0} else if(Demographics.sex==1 && dev=='dev1' && dany=='dany1' && weeklyalc>14){0} else if(dev=='dev2' | dany=='dany2'){0} else {NA}")
databox <- FunctionXform(databox, origFieldName= c("dev", "devf", "dany", "weeklyalc", "bingeflag", "Demographics.sex"), newFieldName= "Behaviours.alc_heavy", formulaText= "if((!is.na(bingeflag) && bingeflag==1) | (Demographics.sex==0 && dev=='dev1' && dany=='dany1' && weeklyalc>21)){1} else if(Demographics.sex==1 && dev=='dev1' && dany=='dany1' && weeklyalc>14){1} else if(Demographics.sex==0 && dev=='dev1' && dany=='dany1' && weeklyalc<=21){0} else if(Demographics.sex==1 && dev=='dev1' && dany=='dany1' && weeklyalc<=14){0} else if(dev=='dev2' | dany=='dany2'){0} else {NA}")

#Diet
databox <- FunctionXform(databox, origFieldName=c('juiu', 'jui'), newFieldName= "djuice", formulaText= "if(juiu=='juid'){jui} else if(juiu=='juiw'){jui/7} else if(juiu=='juim'){jui/30} else if(juiu=='juiy'){jui/365} else {0}")
databox <- FunctionXform(databox, origFieldName=c('frtu', 'frt'), newFieldName= "dfruit", formulaText= "if(frtu=='frtd'){frt} else if(frtu=='frtw'){frt/7} else if(frtu=='frtm'){frt/30} else if(frtu=='frty'){frt/365} else {0}")
databox <- FunctionXform(databox, origFieldName=c('salu', 'sal'), newFieldName= "dsalad", formulaText= "if(salu=='sald'){sal} else if(salu=='salw'){sal/7} else if(salu=='salm'){sal/30} else if(salu=='saly'){sal/365} else {0}")
databox <- FunctionXform(databox, origFieldName=c('potu', 'pot'), newFieldName= "dpotato", formulaText= "if(potu=='potd'){pot} else if(potu=='potw'){pot/7} else if(potu=='potm'){pot/30} else if(potu=='poty'){pot/365} else {0}")
databox <- FunctionXform(databox, origFieldName=c('caru', 'car'), newFieldName= "dcarrot", formulaText= "if(caru=='card'){car} else if(caru=='carw'){car/7} else if(caru=='carm'){car/30} else if(caru=='cary'){car/365} else {0}")
databox <- FunctionXform(databox, origFieldName=c('vegu', 'veg'), newFieldName= "dveg", formulaText= "if(vegu=='vegd'){veg} else if(vegu=='vegw'){veg/7} else if(vegu=='vegm'){veg/30} else if(vegu=='vegy'){veg/365} else {0}")
databox <- FunctionXform(databox, origFieldName=c('djuice', 'dfruit', 'dsalad', 'dpotato', 'dcarrot', 'dveg'), newFieldName= "fruitnvegraw", formulaText= "{dfruit + dsalad + dpotato + dcarrot + dveg}")
databox <- FunctionXform(databox, origFieldName='fruitnvegraw', newFieldName= "fruitnveg", formulaText= "if(fruitnvegraw>8 && fruitnvegraw<98){8} else {fruitnvegraw}")
databox <- FunctionXform(databox, origFieldName=c('dcarrot'), newFieldName= "nocarrotflag", formulaText= "if((dcarrot*7)==0){1} else if((dcarrot*7)>=1){0} else {0}")
databox <- FunctionXform(databox, origFieldName=c('dpotato'), newFieldName= "highpotatoflag", formulaText= "if(Demographics.sex==0 && (dpotato*7)>=7){1} else if(Demographics.sex==0 && (dpotato*7)>=5){1} else {0}")
databox <- FunctionXform(databox, origFieldName=c('djuice'), newFieldName= "highjuice", formulaText= "if(djuice==2){1} else if(djuice==3){2} else if(djuice==4){3} else if(djuice==5){4} else if(djuice==5){4} else if(djuice==6){5} else if(djuice== 1){0} else if(djuice==0){0} else {0}")
databox <- FunctionXform(databox, origFieldName=c('fruitnveg', 'highpotatoflag', 'nocarrotflag', 'highjuiceflag'), newFieldName= "dietraw", formulaText= "{fruitnveg - (2*highpotatoflag) - (2*nocarrotflag) - (2*highjuice)}")
databox <- FunctionXform(databox, origFieldName="dietraw", newFieldName= "Behaviours.diet", formulaText= "if(dietraw<0){0} else if(dietraw>10){10} else {dietraw}")

##Chronic Conditions##
#Heart Disease
databox <- FunctionXform(databox, origFieldName= "hd", newFieldName= "Disease.heartDisease", formulaText= "if(hd=='hd1'){1} else if(hd=='hd2'){0} else {NA}")
#Diabetes
databox <- FunctionXform(databox, origFieldName= "diab", newFieldName= "Disease.diabetes", formulaText= "if(diab=='diab1'){1} else if(diab=='diab2'){0} else {NA}")
#Stroke
databox <- FunctionXform(databox, origFieldName= "stk", newFieldName= "Disease.stroke", formulaText= "if(stk=='stk1'){1} else if(stk=='stk2'){0} else {NA}")
#Cancer
databox <- FunctionXform(databox, origFieldName= "can", newFieldName= "Disease.cancer", formulaText= "if(can=='can1'){1} else if(can=='can2'){0} else {NA}")

#MObese
databox <- FunctionXform(databox, origFieldName= "weightlb", newFieldName= "weightkg", formulaText= "{(weightlb/2.2046226218)}")
databox <- FunctionXform(databox, origFieldName="heightin_hft, heightin_hin", newFieldName= "heightm", formulaText= "{((heightin_hft*12)+heightin_hin)/39.3701}")
databox <- FunctionXform(databox, origFieldName="weightkg, heightm", newFieldName= "Disease.mobese", formulaText= "if((weightkg/(heightm*heightm)-35)<=0){0} else if((weightkg/(heightm*heightm)-35)>0){(weightkg/(heightm*heightm))-35}")

save(databox, file="MPoRTdatabox.rda")


#load(file="MPoRTdatabox.rda")
#load(file="C:\\Users\\stfisher\\Desktop\\Stacey MPoRT PMML Trans\\MPoRTdatabox.rda")


#Model
model <- coxph(Surv(time, death) ~ Demographics.age + Demographics.agespline + Demographics.edu_hsgrad + Demographics.edu_nograd + Demographics.immig_015 + Demographics.immig_1630 + Demographics.immig_3145 
	+ Behaviours.smk_light + Behaviours.smk_heavy + Behaviours.activity + Behaviours.diet + Disease.heartDisease + Disease.stroke + Disease.mobese + Disease.cancer 
	+ Disease.diabetes + Disease.cancer*Demographics.age + Disease.diabetes*Demographics.age , data=databox$data, robust=TRUE)

#+ Demographics.dep_high + Demographics.dep_low


#save(model, file="MPoRTmodel1.rda")

#PMML
sink('output1.txt')
output1 <- pmml(model, transform=databox)
print(output1)
sink()
file.show("output1.txt")

#Transformations
sink('output1.txt')
output1 <- pmml(, transform=databox)
print(output1)
sink()
file.show("output1.txt")



