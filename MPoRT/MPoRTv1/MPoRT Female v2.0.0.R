### MPoRT-Male
#install.packages(c("survival", "pmml", "pmmlTransformations", "knitr"))
library(survival)
library(XML)
library(pmml)
library(pmmlTransformations)
library(knitr)

### Create a fake dataset
set.seed(5000)

time <- rnorm(1000, 180, 15)
StartYear <- 2017
bdate <- sample(seq(as.Date("1910/1/1"), as.Date("1977/1/1"), "day"), 1000, replace=TRUE)
a1 <- sample(seq(as.Date("2007/1/1"), as.Date("2014/1/1"), "day"), 1000, replace=TRUE)
heightin_hft <- sample(2:7, 1000, replace=TRUE)
heightin_hin <- sample(0:11, 1000, replace =TRUE)
weightlb <- sample(15:300, 1000, replace=TRUE)
hs <- sample(c('hs1', 'hs2'), 1000, replace=TRUE, prob=c(0.8, 0.2))
ed <- sample(c('ed1', 'ed2'), 1000, replace=TRUE, prob=c(0.7, 0.3))
hdg <- sample(c('hdg1', 'hdg2', 'hdg3', 'hdg4', 'hdg5', 'hdg6'), 1000, replace=TRUE, prob=c(0.2, 0.2, 0.1, 0.15, 0.2, 0.15))
data <- data.frame(cbind(time, StartYear, bdate, a1, heightin_hft, heightin_hin, weightlb, hs, ed, hdg, time, bdate, a1))

data$heightin_hft <- as.numeric(heightin_hft)
data$heightin_hin <- as.numeric(heightin_hin)
data$weightlb <- as.numeric(weightlb)
data$a1 <- as.numeric(a1)
data$StartYear <- as.numeric(StartYear)
data$bdate <- as.numeric(bdate)
data$death <- 0.01221054*exp(0.0203*((data$a1-data$bdate)/365))
data$death <- replace(data$death, data$death>0.07, 1)
data$death <- replace(data$death, data$death<=0.07, 0)
data$time <- as.numeric(time)
data$age <- as.numeric((Sys.Date() - bdate)/365.25)
data$ed[data$hs!='hs1'] <- NA
data$hdg[data$ed!='ed1'] <- NA
data$dep <- as.factor(sample(c('dep1', 'dep2', 'dep3'), 1000, replace=TRUE, prob=c(0.3, 0.4, 0.3)))

data$imm <- sample(c('imm1', 'imm2'), 1000, replace=TRUE, prob=c(0.88, 0.12))
data$imm <- as.factor(data$imm)
data$imyr <- sample(c("1", "2", "3", "5", "10", "12", "15", "17", "19", "20", "22", "25", "27", "29", "32", "36", "40", "41", "45", "60"), 1000, replace=TRUE, prob=c(.05, .05, .05, .05, .05, .05, .05, .05, .05, .05, .05, .05, .05, .05, .05, .05, .05, .05, .05, .05))
data$imyr[data$imm=='imm1'] <- NA
data$imyr <- as.numeric(data$imyr)

data$s100 <- as.factor(sample(c('s1001', 's1002'), 1000, replace=TRUE, prob=c(0.6, 0.4)))
data$smk <- as.factor(sample(c('smk1', 'smk2', 'smk3'), 1000, replace=TRUE, prob=c(0.2, 0.2, 0.4)))
data$cigdayd <- sample(1:100, 1000, replace=TRUE)
data$cigdayd[data$smk=='smk2' | data$smk=='smk3'] <- NA
data$evdn <- as.factor(sample(c('evdn1', 'evdn2'), 1000, replace=TRUE, prob=c(0.7, 0.3)))
data$evdn[data$smk=='smk1'] <- NA
data$cigdayf <- sample(1:100, 1000, replace=TRUE)
data$cigdayf[data$smk=='smk1'] <- NA
data$cigdayf[data$evdn=='evdn2'] <- NA
data$stpn <- as.factor(sample(c('stpn1', 'stpn2', 'stpn3', 'stpn4'), 1000, replace=TRUE, prob=c(0.1, 0.2, 0.3, 0.4)))
data$stpn[data$smk=='smk1' | data$smk=='smk2'] <- NA
data$stpn[data$evdn=='evdn2'] <- NA
data$stpny <- sample(3:50, 1000, replace=TRUE)
data$stpny[data$smk=='smk1' | data$smk=='smk2'] <- NA
data$stpny[data$evdn=='evdn2'] <- NA
data$stpny[data$stpn=='stpn1' | data$stpn=='stpn2' | data$stpn=='stpn3'] <- NA

data$dev <- as.factor(sample(c('dev1', 'dev2'), 1000, replace=TRUE, prob=c(0.8, 0.2)))
data$da12 <- as.factor(sample(c('da121', 'da122', 'da123', 'da124', 'da125', 'da126', 'da127'), 1000, replace=TRUE, prob=c(0.03, 0.12, 0.27, 0.26, 0.25, 0.4, 0.3)))
data$da12[data$dev=='dev2'] <- NA
data$db <- as.factor(sample(c('db1', 'db2', 'db3', 'db4', 'db5', 'db6'), 1000, replace=TRUE, prob=c(0.36, 0.3, 0.2, 0.08, 0.04, 0.02)))
data$db[data$dev=='dev2'] <- NA
data$dany <- as.factor(sample(c('dany1', 'dany2'), 1000, replace=TRUE, prob=c(0.7, 0.3)))
data$dany[data$dev=='dev2'] <- NA
data$drk_drkm <- as.numeric(sample(c(NA, '1', '2', '3', '4', '5', '6', '7', '8'), 1000, replace=TRUE, prob=c(0.624, 0.2, 0.1, 0.04, 0.015, 0.015, 0.004, 0.0015, 0.0005)))
data$drk_drkm[data$dany=='dany2']<-NA
data$drk_drkt <- as.numeric(sample(c(NA, '1', '2', '3', '4', '5', '6', '7', '8'), 1000, replace=TRUE, prob=c(0.624, 0.2, 0.1, 0.04, 0.015, 0.015, 0.004, 0.0015, 0.0005)))
data$drk_drkt[data$dany=='dany2']<- NA
data$drk_drkw <- as.numeric(sample(c(NA, '1', '2', '3', '4', '5', '6', '7', '8'), 1000, replace=TRUE, prob=c(0.624, 0.2, 0.1, 0.04, 0.015, 0.015, 0.004, 0.0015, 0.0005)))
data$drk_drkw[data$dany=='dany2'] <- NA
data$drk_drkr <- as.numeric(sample(c(NA, '1', '2', '3', '4', '5', '6', '7', '8'), 1000, replace=TRUE, prob=c(0.624, 0.2, 0.1, 0.04, 0.015, 0.015, 0.004, 0.0015, 0.0005)))
data$drk_drkr[data$dany=='dany2'] <- NA 
data$drk_drkf <- as.numeric(sample(c(NA, '1', '2', '3', '4', '5', '6', '7', '8'), 1000, replace=TRUE, prob=c(0.1, 0.2, 0.1, 0.1, 0.1, 0.1, 0.1, 0.1, 0.1)))
data$drk_drkf[data$dany=='dany2'] <- NA
data$drk_drksa <- as.numeric(sample(c(NA, '1', '2', '3', '4', '5', '6', '7', '8'), 1000, replace=TRUE, prob=c(0.1, 0.2, 0.1, 0.1, 0.1, 0.1, 0.1, 0.1, 0.1)))
data$drk_drksa[data$dany=='dany2'] <- NA
data$drk_drksu <- as.numeric(sample(c(NA, '1', '2', '3', '4', '5', '6', '7', '8'), 1000, replace=TRUE, prob=c(0.64, 0.2, 0.1, 0.04, 0.015, 0.015, 0.004, 0.0015, 0.0005)))
data$drk_drksu[data$dany=='dany2'] <- NA

data$juiu <- as.factor(sample(c('juid', 'juiw', 'juim', 'juiy'), 1000, replace=TRUE, prob=c(0.3, 0.5, 0.2, 0.1)))
data$jui <- as.numeric(sample(c('0', '1', '2', '3', '4', '5', '6', '7', '8'), 1000, replace=TRUE, prob=c(0.64, 0.2, 0.1, 0.04, 0.015, 0.015, 0.004, 0.0015, 0.0005)))
data$frtu <- as.factor(sample(c('frtd', 'frtw', 'frtm', 'frty'), 1000, replace=TRUE, prob=c(0.3, 0.5, 0.2, 0.1)))
data$frt <- as.numeric(sample(c('0', '1', '2', '3', '4', '5', '6', '7', '8'), 1000, replace=TRUE, prob=c(0.0005, 0.0015, 0.1, 0.04, 0.015, 0.015, 0.004, 0.2, 0.64)))
data$salu <- as.factor(sample(c('sald', 'salw', 'salm', 'saly'), 1000, replace=TRUE, prob=c(0.3, 0.5, 0.2, 0.1)))
data$sal <- as.numeric(sample(c('0', '1', '2', '3', '4', '5', '6', '7', '8'), 1000, replace=TRUE, prob=c(0.64, 0.2, 0.1, 0.04, 0.015, 0.015, 0.004, 0.0015, 0.0005)))
data$potu <- as.factor(sample(c('potd', 'potw', 'potm', 'poty'), 1000, replace=TRUE, prob=c(0.3, 0.5, 0.2, 0.1)))
data$pot <- as.numeric(sample(c('0', '1', '2', '3', '4', '5', '6', '7', '8'), 1000, replace=TRUE, prob=c(0.64, 0.2, 0.1, 0.04, 0.015, 0.015, 0.004, 0.0015, 0.0005)))
data$caru <- as.factor(sample(c('card', 'carw', 'carm', 'cary'), 1000, replace=TRUE, prob=c(0.3, 0.5, 0.2, 0.1)))
data$car <- as.numeric(sample(c('0', '1', '2', '3', '4', '5', '6', '7', '8'), 1000, replace=TRUE, prob=c(0.64, 0.2, 0.1, 0.04, 0.015, 0.015, 0.004, 0.0015, 0.0005)))
data$vegu <- as.factor(sample(c('vegd', 'vegw', 'vegm', 'vegy'), 1000, replace=TRUE, prob=c(0.3, 0.5, 0.2, 0.1)))
data$veg <- as.numeric(sample(c('0', '1', '2', '3', '4', '5', '6', '7', '8'), 1000, replace=TRUE, prob=c(0.64, 0.2, 0.1, 0.04, 0.015, 0.015, 0.004, 0.0015, 0.0005)))

data$lpa_lpa0 <-as.factor(sample(c('Yes', 'No'), 1000, replace=TRUE, prob=c(0.05, 0.95)))
data$lpa_lpa1 <-as.factor(sample(c('Yes', 'No'), 1000, replace=TRUE, prob=c(0.2, 0.8)))
data$lpa_lpa2 <- as.factor(sample(c('Yes', 'No'), 1000, replace=TRUE, prob=c(0.1, 0.9)))
data$lpa_lpa3 <- as.factor(sample(c('Yes', 'No'), 1000, replace=TRUE, prob=c(0.05, 0.95)))
data$lpa_lpa4 <- as.factor(sample(c('Yes', 'No'), 1000, replace=TRUE, prob=c(0.05, 0.95)))
data$lpa_lpa5 <- as.factor(sample(c('Yes', 'No'), 1000, replace=TRUE, prob=c(0.05, 0.95)))
data$lpa_lpa6 <- as.factor(sample(c('Yes', 'No'), 1000, replace=TRUE, prob=c(0.05, 0.95)))
data$lpa_lpa7 <- as.factor(sample(c('Yes', 'No'), 1000, replace=TRUE, prob=c(0.05, 0.95)))
data$lpa_lpa8 <- as.factor(sample(c('Yes', 'No'), 1000, replace=TRUE, prob=c(0.05, 0.95)))
data$lpa_lpa9 <- as.factor(sample(c('Yes', 'No'), 1000, replace=TRUE, prob=c(0.05, 0.95)))
data$lpa_lpa10 <- as.factor(sample(c('Yes', 'No'), 1000, replace=TRUE, prob=c(0.05, 0.95)))
data$lpa_lpa11 <- as.factor(sample(c('Yes', 'No'), 1000, replace=TRUE, prob=c(0.05, 0.95)))
data$lpa_lpa12 <- as.factor(sample(c('Yes', 'No'), 1000, replace=TRUE, prob=c(0.05, 0.95)))
data$lpa_lpa13 <- as.factor(sample(c('Yes', 'No'), 1000, replace=TRUE, prob=c(0.05, 0.95)))
data$lpa_lpa14 <- as.factor(sample(c('Yes', 'No'), 1000, replace=TRUE, prob=c(0.05, 0.95)))
data$lpa_lpa15 <- as.factor(sample(c('Yes', 'No'), 1000, replace=TRUE, prob=c(0.05, 0.95)))
data$lpa_lpa16 <- as.factor(sample(c('Yes', 'No'), 1000, replace=TRUE, prob=c(0.05, 0.95)))
data$lpa_lpa17 <- as.factor(sample(c('Yes', 'No'), 1000, replace=TRUE, prob=c(0.05, 0.95)))
data$lpa_lpa18 <-as.factor(sample(c('Yes', 'No'), 1000, replace=TRUE, prob=c(0.05, 0.95)))
data$lpa_lpa19 <-  as.factor(sample(c('Yes', 'No'), 1000, replace=TRUE, prob=c(0.05, 0.95)))
data$lpa_lpa20 <- as.factor(sample(c('Yes', 'No'), 1000, replace=TRUE, prob=c(0.05, 0.95)))
data$lpa_lpa21 <- as.factor(sample(c('Yes', 'No'), 1000, replace=TRUE, prob=c(0.05, 0.95)))
data$lpa_lpa22 <- as.factor(sample(c('Yes', 'No'), 1000, replace=TRUE, prob=c(0.02, 0.98)))

data$lpat_lpa1 <- as.numeric(sample(c('1', '2', '3', '5', '8', '10', '25'), 1000, replace=TRUE, prob=c(0.4, 0.25, 0.14, 0.1, 0.05, 0.05, 0.01)))
data$lpat_lpa1[data$lpa_lpa1=='No'] <- NA
data$lpat_lpa2 <-as.numeric(sample(c('1', '2', '3', '5', '8', '10', '25'), 1000, replace=TRUE, prob=c(0.4, 0.25, 0.14, 0.1, 0.05, 0.05, 0.01)))
data$lpat_lpa2[data$lpa_lpa2=='No'] <- NA
data$lpat_lpa3 <-as.numeric(sample(c('1', '2', '3', '5', '8', '10', '25'), 1000, replace=TRUE, prob=c(0.4, 0.25, 0.14, 0.1, 0.05, 0.05, 0.01)))
data$lpat_lpa3[data$lpa_lpa3=='No'] <- NA
data$lpat_lpa4 <-as.numeric(sample(c('1', '2', '3', '5', '8', '10', '25'), 1000, replace=TRUE, prob=c(0.4, 0.25, 0.14, 0.1, 0.05, 0.05, 0.01)))
data$lpat_lpa4[data$lpa_lpa4=='No'] <- NA
data$lpat_lpa5 <-as.numeric(sample(c('1', '2', '3', '5', '8', '10', '25'), 1000, replace=TRUE, prob=c(0.4, 0.25, 0.14, 0.1, 0.05, 0.05, 0.01)))
data$lpat_lpa5[data$lpa_lpa5=='No'] <- NA
data$lpat_lpa6 <-as.numeric(sample(c('1', '2', '3', '5', '8', '10', '25'), 1000, replace=TRUE, prob=c(0.4, 0.25, 0.14, 0.1, 0.05, 0.05, 0.01)))
data$lpat_lpa6[data$lpa_lpa6=='No'] <- NA
data$lpat_lpa7 <-as.numeric(sample(c('1', '2', '3', '5', '8', '10', '25'), 1000, replace=TRUE, prob=c(0.4, 0.25, 0.14, 0.1, 0.05, 0.05, 0.01)))
data$lpat_lpa7[data$lpa_lpa7=='No'] <- NA
data$lpat_lpa8 <-as.numeric(sample(c('1', '2', '3', '5', '8', '10', '25'), 1000, replace=TRUE, prob=c(0.4, 0.25, 0.14, 0.1, 0.05, 0.05, 0.01)))
data$lpat_lpa8[data$lpa_lpa8=='No'] <- NA
data$lpat_lpa9 <-as.numeric(sample(c('1', '2', '3', '5', '8', '10', '25'), 1000, replace=TRUE, prob=c(0.4, 0.25, 0.14, 0.1, 0.05, 0.05, 0.01)))
data$lpat_lpa9[data$lpa_lpa9=='No'] <- NA
data$lpat_lpa10 <-as.numeric(sample(c('1', '2', '3', '5', '8', '10', '25'), 1000, replace=TRUE, prob=c(0.4, 0.25, 0.14, 0.1, 0.05, 0.05, 0.01)))
data$lpat_lpa10[data$lpa_lpa10=='No'] <- NA
data$lpat_lpa11 <-as.numeric(sample(c('1', '2', '3', '5', '8', '10', '25'), 1000, replace=TRUE, prob=c(0.4, 0.25, 0.14, 0.1, 0.05, 0.05, 0.01)))
data$lpat_lpa11[data$lpa_lpa11=='No'] <- NA
data$lpat_lpa12 <-as.numeric(sample(c('1', '2', '3', '5', '8', '10', '25'), 1000, replace=TRUE, prob=c(0.4, 0.25, 0.14, 0.1, 0.05, 0.05, 0.01)))
data$lpat_lpa12[data$lpa_lpa12=='No'] <- NA
data$lpat_lpa13 <-as.numeric(sample(c('1', '2', '3', '5', '8', '10', '25'), 1000, replace=TRUE, prob=c(0.4, 0.25, 0.14, 0.1, 0.05, 0.05, 0.01)))
data$lpat_lpa13[data$lpa_lpa13=='No'] <- NA
data$lpat_lpa14 <-as.numeric(sample(c('1', '2', '3', '5', '8', '10', '25'), 1000, replace=TRUE, prob=c(0.4, 0.25, 0.14, 0.1, 0.05, 0.05, 0.01)))
data$lpat_lpa14[data$lpa_lpa14=='No'] <- NA
data$lpat_lpa15 <-as.numeric(sample(c('1', '2', '3', '5', '8', '10', '25'), 1000, replace=TRUE, prob=c(0.4, 0.25, 0.14, 0.1, 0.05, 0.05, 0.01)))
data$lpat_lpa15[data$lpa_lpa15=='No'] <- NA
data$lpat_lpa16 <-as.numeric(sample(c('1', '2', '3', '5', '8', '10', '25'), 1000, replace=TRUE, prob=c(0.4, 0.25, 0.14, 0.1, 0.05, 0.05, 0.01)))
data$lpat_lpa16[data$lpa_lpa16=='No'] <- NA
data$lpat_lpa17 <-as.numeric(sample(c('1', '2', '3', '5', '8', '10', '25'), 1000, replace=TRUE, prob=c(0.4, 0.25, 0.14, 0.1, 0.05, 0.05, 0.01)))
data$lpat_lpa17[data$lpa_lpa17=='No'] <- NA
data$lpat_lpa18 <-as.numeric(sample(c('1', '2', '3', '5', '8', '10', '25'), 1000, replace=TRUE, prob=c(0.4, 0.25, 0.14, 0.1, 0.05, 0.05, 0.01)))
data$lpat_lpa18[data$lpa_lpa18=='No'] <- NA
data$lpat_lpa19 <-as.numeric(sample(c('1', '2', '3', '5', '8', '10', '25'), 1000, replace=TRUE, prob=c(0.4, 0.25, 0.14, 0.1, 0.05, 0.05, 0.01)))
data$lpat_lpa19[data$lpa_lpa19=='No'] <- NA
data$lpat_lpa20 <-as.numeric(sample(c('1', '2', '3', '5', '8', '10', '25'), 1000, replace=TRUE, prob=c(0.4, 0.25, 0.14, 0.1, 0.05, 0.05, 0.01)))
data$lpat_lpa20[data$lpa_lpa20=='No'] <- NA
data$lpat_lpa21 <-as.numeric(sample(c('1', '2', '3', '5', '8', '10', '25'), 1000, replace=TRUE, prob=c(0.4, 0.25, 0.14, 0.1, 0.05, 0.05, 0.01)))
data$lpat_lpa21[data$lpa_lpa21=='No'] <- NA
data$lpat_lpa22 <-as.numeric(sample(c('1', '2', '3', '5', '8', '10', '25'), 1000, replace=TRUE, prob=c(0.4, 0.25, 0.14, 0.1, 0.05, 0.05, 0.01)))
data$lpat_lpa22[data$lpa_lpa22=='No'] <- NA

data$lpam_lpa1 <-as.factor(sample(c('lpa15', 'lpa30', "lpa60", "lpa61"), 1000, replace=TRUE, prob=c(0.2, 0.40, 0.2, 0.2)))
data$lpam_lpa1[data$lpa_lpa1=='No'] <- NA
data$lpam_lpa2 <-as.factor(sample(c('lpa15', 'lpa30', "lpa60", "lpa61"), 1000, replace=TRUE, prob=c(0.2, 0.40, 0.2, 0.2)))
data$lpam_lpa2[data$lpa_lpa2=='No'] <- NA
data$lpam_lpa3 <-as.factor(sample(c('lpa15', 'lpa30', "lpa60", "lpa61"), 1000, replace=TRUE, prob=c(0.2, 0.40, 0.2, 0.2)))
data$lpam_lpa3[data$lpa_lpa3=='No'] <- NA
data$lpam_lpa4 <-as.factor(sample(c('lpa15', 'lpa30', "lpa60", "lpa61"), 1000, replace=TRUE, prob=c(0.2, 0.40, 0.2, 0.2)))
data$lpam_lpa4[data$lpa_lpa4=='No'] <- NA
data$lpam_lpa5 <-as.factor(sample(c('lpa15', 'lpa30', "lpa60", "lpa61"), 1000, replace=TRUE, prob=c(0.2, 0.40, 0.2, 0.2)))
data$lpam_lpa5[data$lpa_lpa5=='No'] <- NA
data$lpam_lpa6 <-as.factor(sample(c('lpa15', 'lpa30', "lpa60", "lpa61"), 1000, replace=TRUE, prob=c(0.2, 0.40, 0.2, 0.2)))
data$lpam_lpa6[data$lpa_lpa6=='No'] <- NA
data$lpam_lpa7 <-as.factor(sample(c('lpa15', 'lpa30', "lpa60", "lpa61"), 1000, replace=TRUE, prob=c(0.2, 0.40, 0.2, 0.2)))
data$lpam_lpa7[data$lpa_lpa7=='No'] <- NA
data$lpam_lpa8 <-as.factor(sample(c('lpa15', 'lpa30', "lpa60", "lpa61"), 1000, replace=TRUE, prob=c(0.2, 0.40, 0.2, 0.2)))
data$lpam_lpa8[data$lpa_lpa8=='No'] <- NA
data$lpam_lpa9 <-as.factor(sample(c('lpa15', 'lpa30', "lpa60", "lpa61"), 1000, replace=TRUE, prob=c(0.2, 0.40, 0.2, 0.2)))
data$lpam_lpa9[data$lpa_lpa9=='No'] <- NA
data$lpam_lpa10 <-as.factor(sample(c('lpa15', 'lpa30', "lpa60", "lpa61"), 1000, replace=TRUE, prob=c(0.2, 0.40, 0.2, 0.2)))
data$lpam_lpa10[data$lpa_lpa10=='No'] <- NA
data$lpam_lpa11 <-as.factor(sample(c('lpa15', 'lpa30', "lpa60", "lpa61"), 1000, replace=TRUE, prob=c(0.2, 0.40, 0.2, 0.2)))
data$lpam_lpa11[data$lpa_lpa11=='No'] <- NA
data$lpam_lpa12 <-as.factor(sample(c('lpa15', 'lpa30', "lpa60", "lpa61"), 1000, replace=TRUE, prob=c(0.2, 0.40, 0.2, 0.2)))
data$lpam_lpa12[data$lpa_lpa12=='No'] <- NA
data$lpam_lpa13 <-as.factor(sample(c('lpa15', 'lpa30', "lpa60", "lpa61"), 1000, replace=TRUE, prob=c(0.2, 0.40, 0.2, 0.2)))
data$lpam_lpa13[data$lpa_lpa13=='No'] <- NA
data$lpam_lpa14 <-as.factor(sample(c('lpa15', 'lpa30', "lpa60", "lpa61"), 1000, replace=TRUE, prob=c(0.2, 0.40, 0.2, 0.2)))
data$lpam_lpa14[data$lpa_lpa14=='No'] <- NA
data$lpam_lpa15 <-as.factor(sample(c('lpa15', 'lpa30', "lpa60", "lpa61"), 1000, replace=TRUE, prob=c(0.2, 0.40, 0.2, 0.2)))
data$lpam_lpa15[data$lpa_lpa15=='No'] <- NA
data$lpam_lpa16 <-as.factor(sample(c('lpa15', 'lpa30', "lpa60", "lpa61"), 1000, replace=TRUE, prob=c(0.2, 0.40, 0.2, 0.2)))
data$lpam_lpa16[data$lpa_lpa16=='No'] <- NA
data$lpam_lpa17 <-as.factor(sample(c('lpa15', 'lpa30', "lpa60", "lpa61"), 1000, replace=TRUE, prob=c(0.2, 0.40, 0.2, 0.2)))
data$lpam_lpa17[data$lpa_lpa17=='No'] <- NA
data$lpam_lpa18 <-as.factor(sample(c('lpa15', 'lpa30', "lpa60", "lpa61"), 1000, replace=TRUE, prob=c(0.2, 0.40, 0.2, 0.2)))
data$lpam_lpa18[data$lpa_lpa18=='No'] <- NA
data$lpam_lpa19 <-as.factor(sample(c('lpa15', 'lpa30', "lpa60", "lpa61"), 1000, replace=TRUE, prob=c(0.2, 0.40, 0.2, 0.2)))
data$lpam_lpa19[data$lpa_lpa19=='No'] <- NA
data$lpam_lpa20 <-as.factor(sample(c('lpa15', 'lpa30', "lpa60", "lpa61"), 1000, replace=TRUE, prob=c(0.2, 0.40, 0.2, 0.2)))
data$lpam_lpa20[data$lpa_lpa20=='No'] <- NA
data$lpam_lpa21 <-as.factor(sample(c('lpa15', 'lpa30', "lpa60", "lpa61"), 1000, replace=TRUE, prob=c(0.2, 0.40, 0.2, 0.2)))
data$lpam_lpa21[data$lpa_lpa21=='No'] <- NA
data$lpam_lpa22 <-as.factor(sample(c('lpa15', 'lpa30', "lpa60", "lpa61"), 1000, replace=TRUE, prob=c(0.2, 0.40, 0.2, 0.2)))
data$lpam_lpa22[data$lpa_lpa22=='No'] <- NA

data$diab <- as.factor(sample(c('diab1', 'diab2'), 1000, replace=TRUE, prob=c(0.1, 0.9)))
data$stk <- as.factor(sample(c('stk1', 'stk2'), 1000, replace=TRUE, prob=c(0.05, 0.95)))
data$can <- as.factor(sample(c('can1', 'can2'), 1000, replace=TRUE, prob=c(0.04, 0.96)))
data$hd <- as.factor(sample(c('hd1', 'hd2'), 1000, replace=TRUE, prob=c(0.2, 0.8)))

###Data Pre-processing###
databox <- WrapData(data)

#Age#
databox <- FunctionXform(databox, origFieldName= "age",
                         newFieldName= "Age_cont",
                         formulaText= "if(is.na(age)) {NA} else {age}",
                         mapMissingTo= NA)

#Age Spline#
databox <- FunctionXform(databox, origFieldName= c("sex", "Age_cont"),
                         newFieldName= "Age_spline",
                         formulaText= "if(is.na(Age_cont)) {NA} else if(Age_cont>80){Age_cont-80} else {0}",
                         mapMissingTo= NA)

#Education#
databox <- FunctionXform(databox, origFieldName= c("hs", "ed"),
                         newFieldName= "edumissing",
                         formulaText= "if(is.na(hs) || (hs=='hs1' && is.na(ed)) || (hs=='hs1' && ed=='ed1' && is.na(hdg))) {1} else {0}",
                         mapMissingTo= NA)
databox <- FunctionXform(databox, origFieldName= c("hs", "ed"),
                         newFieldName= "EduNoGrad_cat",
                         formulaText= "if(edumissing==1) {NA} else if(hs=='hs2'){1} else {0}",
                         mapMissingTo= NA)
databox <- FunctionXform(databox, origFieldName= c("hs", "ed", "hdg"),
                         newFieldName= "EduHSGrad_cat",
                         formulaText= "if(edumissing==1) {NA} else if((hs=='hs1' && ed=='ed2') | (hs=='hs1' && ed=='ed1' && hdg=='hdg1')) {1} else {0}",
                         mapMissingTo= NA)

#Deprivation#
databox <-FunctionXform(databox, origFieldName= "dep",
                        newFieldName= "DepIndHigh_cat",
                        formulaText= "if(is.na(dep)) {NA} else if(dep=='dep1'){1} else {0}",
                        mapMissingTo= NA)
databox <-FunctionXform(databox, origFieldName= "dep",
                        newFieldName= "DepIndMod_cat",
                        formulaText= "if(is.na(dep)) {NA} else if(dep=='dep2'){1} else {0}",
                        mapMissingTo= NA)

#StartYear created as first step in PMML Local Transformations: 
#<DerivedField name="StartYear" dataType="string" optype="categorical">
#  <Apply function="formatDatetime">
#  <FieldRef field="StartDate"/>
#  <Constant>%Y</Constant>
#  </Apply>
#  </DerivedField>#

#Immigration#
databox <- FunctionXform(databox, origFieldName= c("imm", "imyr"),
                         newFieldName= "imyrago",
                         formulaText= "if(is.na(imm) || (imm=='imm2' && is.na(imyr)) || (imm=='imm1')) {NA} else {StartYear-imyr}",
                         mapMissingTo= NA)
databox <- FunctionXform(databox, origFieldName= c("imm", "imyrago", "imyr"),
                         newFieldName= "ImEth0To15_cat",
                         formulaText= "if(is.na(imm) || (imm=='imm2' && is.na(imyr))) {NA} else if(imm=='imm2' && imyrago>=1 && imyrago<=15){1} else if(imm=='imm1'| imyrago>15){0} else {0}",
                         mapMissingTo= NA)
databox <- FunctionXform(databox, origFieldName= c("imm", "imyrago", "imyr"),
                         newFieldName= "ImEth16To30_cat",
                         formulaText= "if(is.na(imm) || (imm=='imm2' && is.na(imyr))) {NA} else if(imm=='imm2' && imyrago>15 && imyrago<=30){1} else if(imm=='imm1' | imyrago<=15 | imyrago>30){0} else {0}",
                         mapMissingTo= NA)
databox <- FunctionXform(databox, origFieldName= c("imm", "imyrago", "imyr"),
                         newFieldName= "ImEth31To45_cat",
                         formulaText= "if(is.na(imm) || (imm=='imm2' && is.na(imyr))) {NA} else if(imm=='imm2' && imyrago>30 && imyrago<=45){1} else if(imm=='imm1'|imyrago<=30|imyrago>45){0} else {0}",
                         mapMissingTo= NA)

##Health Behaviours##
#Smoking#
databox <- FunctionXform(databox, origFieldName= c("s100", "smk", "cigdayd", "cigdayf", "evdn"),
                         newFieldName= "missingsmoking",
                         formulaText= "if(is.na(smk) || (smk=='smk1' && is.na(cigdayd)) || ((smk=='smk2' || smk=='smk3') && is.na(evdn))) {1} else if((smk=='smk2' || smk=='smk3') && evdn=='evdn1' && is.na(cigdayf)) {1} else {0}",
                         mapMissingTo= NA)
databox <- FunctionXform(databox, origFieldName= c("s100", "smk", "cigdayf", "missingsmoking"),
                         newFieldName= "formerlight",
                         formulaText= "if(missingsmoking==1) {NA} else if((smk=='smk3' && evdn=='evdn1' && cigdayf<20) || (smk=='smk3' && evdn=='evdn2' && s100=='s1001')){1} else {0}",
                         mapMissingTo = NA)
databox <- FunctionXform(databox, origFieldName= c("smk", "evdn", "cigdayf", "missingsmoking"),
                         newFieldName= "formerheavy",
                         formulaText= "if(missingsmoking==1) {NA} else if(smk=='smk3' && evdn=='evdn1' && cigdayf>=20){1} else {0}",
                         mapMissingTo = NA)
databox <- FunctionXform(databox, origFieldName= c("smk", "cigdayd", "missingsmoking"),
                         newFieldName= "smklight",
                         formulaText= "if(missingsmoking==1) {NA} else if((smk=='smk1' && cigdayd<20) || smk=='smk2'){1} else {0}",
                         mapMissingTo = NA)
databox <- FunctionXform(databox, origFieldName= c("smk", "cigdayd", "missingsmoking"),
                         newFieldName= "smkheavy",
                         formulaText= "if(missingsmoking==1) {NA} else if(smk=='smk1' && cigdayd>=20){1} else {0}",
                         mapMissingTo = NA)
databox <- FunctionXform(databox, origFieldName= c("stpn", "stpny", "missingsmoking"),
                         newFieldName= "quittime",
                         formulaText= "if(missingsmoking==1 || is.na(stpn)) {NA} else if(stpn=='stpn1'){0} else if(stpn=='stpn2'){1} else if(stpn=='stpn3'){2} else if(stpn=='stpn4'){stpny} else {0}",
                         mapMissingTo= NA)
databox <- FunctionXform(databox, origFieldName= c("smklight", "formerlight", "quittime"),
                         newFieldName= "QSLight_df",
                         formulaText= "if(missingsmoking==1) {NA} else if(smklight==1) {1} else if(formerlight==1) {exp(-quittime/26)} else {0}",
                         mapMissingTo = NA)
databox <- FunctionXform(databox, origFieldName= c("smkheavy", "formerheavy", "quittime"),
                         newFieldName= "QSHeavy_df",
                         formulaText= "if(missingsmoking==1) {NA} else if(smkheavy==1) {1} else if(formerheavy==1) {exp(-quittime/26)} else {0}",
                         mapMissingTo = NA)

##Alcohol##
databox <- FunctionXform(databox,
                         origFieldName=c("dev", "dany", "drk_drkm", "drk_drkt", "drk_drkw", "drk_drkr", "drk_drksa", "drk_drksu"),
                         newFieldName= "missingalcohol",
                         formulaText="if(is.na(dev) || (dev=='dev1' && (is.na(da12) || is.na(db) || is.na(dany)))) {1} else {0}",
                         mapMissingTo = NA)

#Convert daily drinks last week from (0 1 NA) to (0 1)
databox <- FunctionXform(databox,
                         origFieldName=c("missingalcohol", "drk_drkm"),
                         newFieldName= "drk_drkm2",
                         formulaText="if(missingalcohol==1){NA} else if(is.na(drk_drkm)) {0} else {drk_drkm}",
                         mapMissingTo = NA)
databox <- FunctionXform(databox,
                         origFieldName=c("missingalcohol", "drk_drkt"),
                         newFieldName= "drk_drkt2",
                         formulaText="if(missingalcohol==1){NA} else if(is.na(drk_drkt)) {0} else {drk_drkt}",
                         mapMissingTo = NA)
databox <- FunctionXform(databox,
                         origFieldName=c("missingalcohol", "drk_drkw"),
                         newFieldName= "drk_drkw2",
                         formulaText="if(missingalcohol==1){NA} else if(is.na(drk_drkw)) {0} else {drk_drkw}",
                         mapMissingTo = NA)
databox <- FunctionXform(databox,
                         origFieldName=c("missingalcohol", "drk_drkr"),
                         newFieldName= "drk_drkr2",
                         formulaText="if(missingalcohol==1){NA} else if(is.na(drk_drkr)) {0} else {drk_drkr}",
                         mapMissingTo = NA)
databox <- FunctionXform(databox,
                         origFieldName=c("missingalcohol", "drk_drkf"),
                         newFieldName= "drk_drkf2",
                         formulaText="if(missingalcohol==1){NA} else if(is.na(drk_drkf)) {0} else {drk_drkf}",
                         mapMissingTo = NA)
databox <- FunctionXform(databox,
                         origFieldName=c("missingalcohol", "drk_drksa"),
                         newFieldName= "drk_drksa2",
                         formulaText="if(missingalcohol==1){NA} else if(is.na(drk_drksa)) {0} else {drk_drksa}",
                         mapMissingTo = NA)
databox <- FunctionXform(databox,
                         origFieldName=c("missingalcohol", "drk_drksu"),
                         newFieldName= "drk_drksu2",
                         formulaText="if(missingalcohol==1){NA} else if(is.na(drk_drksu)) {0} else {drk_drksu}",
                         mapMissingTo = NA)

databox <- FunctionXform(databox,
                         origFieldName=c("dev", "dany", "drk_drkm2", "drk_drkt2", "drk_drkw2", "drk_drkr2", "drk_drksa2", "drk_drksu2", "missingalcohol"),
                         newFieldName= "weeklyalc",
                         formulaText="if(missingalcohol==1){NA} else if(dev=='dev1' && dany=='dany1'){drk_drkm2 + drk_drkt2 + drk_drkw2 + drk_drkr2 + drk_drkf2 + drk_drksa2 + drk_drksu2} else {0}",
                         mapMissingTo = NA)
databox <- FunctionXform(databox,
                         origFieldName=c("db", "drk_drkm", "drk_drkt", "drk_drkw", "drk_drkr", "drk_drkf", "drk_drksa", "drk_drksu", "missingalcohol"),
                         newFieldName= "bingeflag",
                         formulaText= "if(missingalcohol==1){NA} else if(!is.na(db) && (db=='db5' | db=='db6')){1} else if(drk_drkm2>=5){1} else if(drk_drkt2>=5){1} else if(drk_drkw2>=5){1} else if(drk_drkr2>=5){1} else if(drk_drkf2>=5){1} else if(drk_drksa2>=5){1} else if(drk_drksu2>=5){1} else {0}",
                         mapMissingTo = NA)
databox <- FunctionXform(databox,
                         origFieldName= c("dev", "bingeflag", "dany", "weeklyalc", "missingalcohol"),
                         newFieldName= "AlcoholMod_cat",
                         formulaText= "if(missingalcohol==1) {NA} else if(bingeflag==1){0} else if(dev=='dev1' && dany=='dany1' && weeklyalc>2 && weeklyalc <=14){1} else {0}",
                         mapMissingTo = NA)
databox <- FunctionXform(databox,
                         origFieldName= c("dev", "dany", "weeklyalc", "bingeflag", "missingalcohol"),
                         newFieldName= "AlcoholHeavy_cat",
                         formulaText= "if(missingalcohol==1) {NA} else if(bingeflag==1){1} else if(dev=='dev1' && dany=='dany1' && weeklyalc>14){1} else {0}",
                         mapMissingTo = NA)

#Diet#
databox <- FunctionXform(databox,
                         origFieldName=c('juiu', 'jui', 'frtu', 'frt', 'salu', 'sal', 'potu', 'pot', 'caru', 'car', 'vegu', 'veg'),
                         newFieldName= "missingdiet",
                         formulaText= "if(is.na(juiu) || is.na(jui) || is.na(frtu) || is.na(frt) || is.na(salu) || is.na(sal) || is.na(potu) || is.na(pot) || is.na(caru) || is.na(car) || is.na(vegu) || is.na(veg)) {1} else {0}",
                         mapMissingTo = NA)
databox <- FunctionXform(databox,
                         origFieldName=c('juiu', 'jui', 'missingdiet'),
                         newFieldName= "djuice",
                         formulaText= "if(missingdiet==1) {NA} else if(juiu=='juid'){jui} else if(juiu=='juiw'){jui/7} else if(juiu=='juim'){jui/30} else if(juiu=='juiy'){jui/365} else {0}",
                         mapMissingTo= NA)
databox <- FunctionXform(databox,
                         origFieldName=c('frtu', 'frt', 'missingdiet'),
                         newFieldName= "dfruit",
                         formulaText= "if(missingdiet==1) {NA} else if(frtu=='frtd'){frt} else if(frtu=='frtw'){frt/7} else if(frtu=='frtm'){frt/30} else if(frtu=='frty'){frt/365} else {0}",
                         mapMissingTo= NA)
databox <- FunctionXform(databox,
                         origFieldName=c('salu', 'sal', 'missingdiet'),
                         newFieldName= "dsalad",
                         formulaText= "if(missingdiet==1) {NA} else if(salu=='sald'){sal} else if(salu=='salw'){sal/7} else if(salu=='salm'){sal/30} else if(salu=='saly'){sal/365} else {0}",
                         mapMissingTo= NA)
databox <- FunctionXform(databox,
                         origFieldName=c('potu', 'pot', 'missingdiet'),
                         newFieldName= "dpotato",
                         formulaText= "if(missingdiet==1) {NA} else if(potu=='potd'){pot} else if(potu=='potw'){pot/7} else if(potu=='potm'){pot/30} else if(potu=='poty'){pot/365} else {0}",
                         mapMissingTo= NA)
databox <- FunctionXform(databox,
                         origFieldName=c('caru', 'car', 'missingdiet'),
                         newFieldName= "dcarrot",
                         formulaText= "if(missingdiet==1) {NA} else if(caru=='card'){car} else if(caru=='carw'){car/7} else if(caru=='carm'){car/30} else if(caru=='cary'){car/365} else {0}",
                         mapMissingTo= NA)
databox <- FunctionXform(databox,
                         origFieldName=c('vegu', 'veg', 'missingdiet'),
                         newFieldName= "dveg",
                         formulaText= "if(missingdiet==1) {NA} else if(vegu=='vegd'){veg} else if(vegu=='vegw'){veg/7} else if(vegu=='vegm'){veg/30} else if(vegu=='vegy'){veg/365} else {0}",
                         mapMissingTo= NA)
databox <- FunctionXform(databox,
                         origFieldName=c('djuice', 'dfruit', 'dsalad', 'dpotato', 'dcarrot', 'dveg', 'missingdiet'),
                         newFieldName= "fruitnveg",
                         formulaText= "if(missingdiet==1) {NA} else if((dfruit + dsalad + dpotato + dcarrot + dveg)>8) {8} else {dfruit + dsalad + dpotato + dcarrot + dveg}",
                         mapMissingTo= NA)
databox <- FunctionXform(databox,
                         origFieldName=c('dcarrot', 'missingdiet'),
                         newFieldName= "nocarrotflag",
                         formulaText= "if(missingdiet==1) {NA} else if((dcarrot*7)==0){1} else if((dcarrot*7)>=1){0} else {0}",
                         mapMissingTo= NA)
databox <- FunctionXform(databox,
                         origFieldName=c('dpotato', 'missingdiet'),
                         newFieldName= "highpotatoflag",
                         formulaText= "if(missingdiet==1) {NA} else if((dpotato*7)>=5){1} else {0}",
                         mapMissingTo= NA)
databox <- FunctionXform(databox,
                         origFieldName=c('djuice', 'missingdiet'),
                         newFieldName= "highjuice",
                         formulaText= "if(missingdiet==1) {NA} else if(djuice==0){0} else if(djuice==1){0}  else if(djuice==2){1} else if(djuice==3){2} else if(djuice==4){3} else if(djuice==5){4} else if(djuice==5){4} else if(djuice==6){5} else {0}",
                         mapMissingTo = NA)

databox <- FunctionXform(databox,
                         origFieldName=c('fruitnveg', 'highpotatoflag', 'nocarrotflag', 'highjuiceflag', 'missingdiet'),
                         newFieldName= "dietraw",
                         formulaText= "if(missingdiet==1) {NA} else {(2+ fruitnveg - (2*highpotatoflag) - (2*nocarrotflag) - (2*highjuice))}",
                         mapMissingTo= NA)
databox <- FunctionXform(databox,
                         origFieldName="dietraw",
                         newFieldName= "DietScore_cont",
                         formulaText= "if(missingdiet==1) {NA} else if(dietraw<0){0} else if(dietraw>10){10} else {dietraw}",
                         mapMissingTo= NA)


#Activity#
databox <- FunctionXform(databox,
                         origFieldName= c("lpa_lpa0", "lpa_lpa1", "lpa_lpa2", "lpa_lpa3", "lpa_lpa4", "lpa_lpa5", "lpa_lpa6", "lpa_lpa7", "lpa_lpa8", "lpa_lpa9", "lpa_lpa10", "lpa_lpa11", "lpa_lpa12",  "lpa_lpa13", "lpa_lpa14", "lpa_lpa15", "lpa_lpa16", "lpa_lpa17", "lpa_lpa18", "lpa_lpa19", "lpa_lpa20", "lpa_lpa21", "lpa_lpa22", "lpat_lpa1", "lpat_lpa2", "lpat_lpa3", "lpat_lpa4", "lpat_lpa5", "lpat_lpa6", "lpat_lpa7", "lpat_lpa8", "lpat_lpa9", "lpat_lpa10", "lpat_lpa11", "lpat_lpa12",  "lpat_lpa13", "lpat_lpa14", "lpat_lpa15", "lpat_lpa16", "lpat_lpa17", "lpat_lpa18", "lpat_lpa19", "lpat_lpa20", "lpat_lpa21", "lpat_lpa22", "lpam_lpa1", "lpam_lpa2", "lpam_lpa3", "lpam_lpa4", "lpam_lpa5", "lpam_lpa6", "lpam_lpa7", "lpam_lpa8", "lpam_lpa9", "lpam_lpa10", "lpam_lpa11", "lpam_lpa12",  "lpam_lpa13", "lpam_lpa14", "lpam_lpa15", "lpam_lpa16", "lpam_lpa17", "lpam_lpa18", "lpam_lpa19", "lpam_lpa20", "lpam_lpa21", "lpam_lpa22"),
                         newFieldName= "missingactivity",
                         formulaText="if(lpa_lpa0=='No' && lpa_lpa1=='No' && lpa_lpa2=='No' && lpa_lpa3=='No' && lpa_lpa4=='No' && lpa_lpa5=='No' && lpa_lpa6=='No' && lpa_lpa7=='No' && lpa_lpa8=='No' && lpa_lpa9=='No' && lpa_lpa10=='No' && lpa_lpa11=='No' && lpa_lpa12=='No' && lpa_lpa13=='No' && lpa_lpa14=='No' && lpa_lpa15=='No' && lpa_lpa16=='No' && lpa_lpa17=='No' && lpa_lpa18=='No' && lpa_lpa19=='No' && lpa_lpa20=='No' && lpa_lpa21=='No' && lpa_lpa22=='No' && is.na(lpat_lpa1) && is.na(lpat_lpa2) && is.na(lpat_lpa3) && is.na(lpat_lpa4) && is.na(lpat_lpa5) && is.na(lpat_lpa6) && is.na(lpat_lpa7) && is.na(lpat_lpa8) && is.na(lpat_lpa9) && is.na(lpat_lpa10) && is.na(lpat_lpa11) && is.na(lpat_lpa12) && is.na(lpat_lpa13) && is.na(lpat_lpa14) && is.na(lpat_lpa15) && is.na(lpat_lpa16) && is.na(lpat_lpa17) && is.na(lpat_lpa18) && is.na(lpat_lpa19) && is.na(lpat_lpa20) && is.na(lpat_lpa21) && is.na(lpat_lpa22) && is.na(lpam_lpa1) && is.na(lpam_lpa2) && is.na(lpam_lpa3) && is.na(lpam_lpa4) && is.na(lpam_lpa5) && is.na(lpam_lpa6) && is.na(lpam_lpa7) && is.na(lpam_lpa8) && is.na(lpam_lpa9) && is.na(lpam_lpa10) && is.na(lpam_lpa11) && is.na(lpam_lpa12) && is.na(lpam_lpa13) && is.na(lpam_lpa14) && is.na(lpam_lpa15) && is.na(lpam_lpa16) && is.na(lpam_lpa17) && is.na(lpam_lpa18) && is.na(lpam_lpa19) && is.na(lpam_lpa20) && is.na(lpam_lpa21) && is.na(lpam_lpa22)) {1} else {0}",
                         mapMissingTo= NA)

databox <- FunctionXform(databox, 
                         origFieldName= c("lpa_lpa1", "lpat_lpa1", "lpam_lpa1"),
                         newFieldName= "walking_miss",
                         formulaText= "if(lpa_lpa1=='Yes' && (is.na(lpat_lpa1) || is.na(lpam_lpa1))){1} else {0}")
databox <- FunctionXform(databox,
                         origFieldName= c("walking_miss","lpa_lpa1", "lpat_lpa1", "lpam_lpa1"),
                         newFieldName= "walking",
                         formulaText= "if(walking_miss==1) {NA} else if(lpa_lpa1=='Yes' && lpam_lpa1=='lpa15'){(lpat_lpa1*0.2167*3)/90}  else if(lpa_lpa1=='Yes' && lpam_lpa1=='lpa30'){(lpat_lpa1*0.3833*3)/90} else if(lpa_lpa1=='Yes' && lpam_lpa1=='lpa60'){(lpat_lpa1*0.75*3)/90} else if(lpa_lpa1=='Yes' && lpam_lpa1=='lpa61'){(lpat_lpa1*1*3)/90} else {0}")
databox <- FunctionXform(databox,
                         origFieldName= c("lpa_lpa2", "lpat_lpa2", "lpam_lpa2"),
                         newFieldName= "garden_miss",
                         formulaText= "if(lpa_lpa2=='Yes' && (is.na(lpat_lpa2) || is.na(lpam_lpa2))){1} else {0}")
databox <- FunctionXform(databox,
                         origFieldName= c("garden_miss","lpa_lpa2", "lpat_lpa2", "lpam_lpa2"),
                         newFieldName= "garden",
                         formulaText= "if(garden_miss==1) {NA} else if(lpa_lpa2=='Yes' && lpam_lpa2=='lpa15'){(lpat_lpa2*0.2167*3)/90} else if(lpa_lpa2=='Yes' && lpam_lpa2=='lpa30'){(lpat_lpa2*0.3833*3)/90} else if(lpa_lpa2=='Yes' && lpam_lpa2=='lpa60'){(lpat_lpa2*0.75*3)/90} else if(lpa_lpa2=='Yes' && lpam_lpa2=='lpa61'){(lpat_lpa2*1*3)/90} else {0}")
databox <- FunctionXform(databox,
                         origFieldName= c("lpa_lpa3", "lpat_lpa3", "lpam_lpa3"),
                         newFieldName= "swim_miss",
                         formulaText= "if(lpa_lpa3=='Yes' && (is.na(lpat_lpa3) || is.na(lpam_lpa3))){1} else {0}")
databox <- FunctionXform(databox,
                         origFieldName= c("swim_miss","lpa_lpa3", "lpat_lpa3", "lpam_lpa3"),
                         newFieldName= "swim",
                         formulaText= "if(swim_miss==1) {NA} else if(lpa_lpa3=='Yes' && lpam_lpa3=='lpa15'){(lpat_lpa3*0.2167*3)/90} else if(lpa_lpa3=='Yes' && lpam_lpa3=='lpa30'){(lpat_lpa3*0.3833*3)/90} else if(lpa_lpa3=='Yes' && lpam_lpa3=='lpa60'){(lpat_lpa3*0.75*3)/90} else if(lpa_lpa3=='Yes' && lpam_lpa3=='lpa61'){(lpat_lpa3*1*3)/90} else {0}")
databox <- FunctionXform(databox,
                         origFieldName= c("lpa_lpa4", "lpat_lpa4", "lpam_lpa4"),
                         newFieldName= "bike_miss",
                         formulaText= "if(lpa_lpa4=='Yes' && (is.na(lpat_lpa4) || is.na(lpam_lpa4))){1} else {0}")
databox <- FunctionXform(databox,
                         origFieldName= c("bike_miss","lpa_lpa4", "lpat_lpa4", "lpam_lpa4"),
                         newFieldName= "bike",
                         formulaText= "if(bike_miss==1) {NA} else if(lpa_lpa4=='Yes' && lpam_lpa4=='lpa15'){(lpat_lpa4*0.2167*4)/90} else if(lpa_lpa4=='Yes' && lpam_lpa4=='lpa30'){(lpat_lpa4*0.3833*4)/90} else if(lpa_lpa4=='Yes' && lpam_lpa4=='lpa60'){(lpat_lpa4*0.75*4)/90} else if(lpa_lpa4=='Yes' && lpam_lpa4=='lpa61'){(lpat_lpa4*1*4)/90} else {0}")
databox <- FunctionXform(databox,
                         origFieldName= c("lpa_lpa5", "lpat_lpa5", "lpam_lpa5"),
                         newFieldName= "dance_miss",
                         formulaText= "if(lpa_lpa5=='Yes' && (is.na(lpat_lpa5) || is.na(lpam_lpa5))){1} else {0}")
databox <- FunctionXform(databox,
                         origFieldName= c("dance_miss","lpa_lpa5", "lpat_lpa5", "lpam_lpa5"),
                         newFieldName= "dance",
                         formulaText= "if(dance_miss==1) {NA} else if(lpa_lpa5=='Yes' && lpam_lpa5=='lpa15'){(lpat_lpa5*0.2167*3)/90} else if(lpa_lpa5=='Yes' && lpam_lpa5=='lpa30'){(lpat_lpa5*0.3833*3)/90} else if(lpa_lpa5=='Yes' && lpam_lpa5=='lpa60'){(lpat_lpa5*0.75*3)/90} else if(lpa_lpa5=='Yes' && lpam_lpa5=='lpa61'){(lpat_lpa5*1*3)/90} else {0}")
databox <- FunctionXform(databox,
                         origFieldName= c("lpa_lpa6", "lpat_lpa6", "lpam_lpa6"),
                         newFieldName= "hexercises_miss",
                         formulaText= "if(lpa_lpa6=='Yes' && (is.na(lpat_lpa6) || is.na(lpam_lpa6))){1} else {0}")
databox <- FunctionXform(databox,
                         origFieldName= c("hexercises_miss","lpa_lpa6", "lpat_lpa6", "lpam_lpa6"),
                         newFieldName= "hexercises",
                         formulaText= "if(hexercises_miss==1) {NA} else if(lpa_lpa6=='Yes' && lpam_lpa6=='lpa15'){(lpat_lpa6*0.2167*3)/90}  else if(lpa_lpa6=='Yes' && lpam_lpa6=='lpa30'){(lpat_lpa6*0.3833*3)/90} else if(lpa_lpa6=='Yes' && lpam_lpa6=='lpa60'){(lpat_lpa6*0.75*3)/90} else if(lpa_lpa6=='Yes' && lpam_lpa6=='lpa61'){(lpat_lpa6*1*3)/90} else {0}")
databox <- FunctionXform(databox,
                         origFieldName= c("lpa_lpa7", "lpat_lpa7", "lpam_lpa7"),
                         newFieldName= "hockey_miss",
                         formulaText= "if(lpa_lpa7=='Yes' && (is.na(lpat_lpa7) || is.na(lpam_lpa7))){1} else {0}")
databox <- FunctionXform(databox,
                         origFieldName= c("hockey_miss","lpa_lpa7", "lpat_lpa7", "lpam_lpa7"),
                         newFieldName= "hockey",
                         formulaText= "if(hockey_miss==1) {NA} else if(lpa_lpa7=='Yes' && lpam_lpa7=='lpa15'){(lpat_lpa7*0.2167*6)/90} else if(lpa_lpa7=='Yes' && lpam_lpa7=='lpa30'){(lpat_lpa7*0.3833*6)/90} else if(lpa_lpa7=='Yes' && lpam_lpa7=='lpa60'){(lpat_lpa7*0.75*6)/90} else if(lpa_lpa7=='Yes' && lpam_lpa7=='lpa61'){(lpat_lpa7*1*6)/90} else {0}")
databox <- FunctionXform(databox,
                         origFieldName= c("lpa_lpa8", "lpat_lpa8", "lpam_lpa8"),
                         newFieldName= "skate_miss",
                         formulaText= "if(lpa_lpa8=='Yes' && (is.na(lpat_lpa8) || is.na(lpam_lpa8))){1} else {0}")
databox <- FunctionXform(databox,
                         origFieldName= c("skate_miss","lpa_lpa8", "lpat_lpa8", "lpam_lpa8"),
                         newFieldName= "skate",
                         formulaText= "if(skate_miss==1) {NA} else if(lpa_lpa8=='Yes' && lpam_lpa8=='lpa15'){(lpat_lpa8*0.2167*4)/90} else if(lpa_lpa8=='Yes' && lpam_lpa8=='lpa30'){(lpat_lpa8*0.3833*4)/90} else if(lpa_lpa8=='Yes' && lpam_lpa8=='lpa60'){(lpat_lpa8*0.75*4)/90} else if(lpa_lpa8=='Yes' && lpam_lpa8=='lpa61'){(lpat_lpa8*1*4)/90} else {0}")
databox <- FunctionXform(databox,
                         origFieldName= c("lpa_lpa9", "lpat_lpa9", "lpam_lpa9"),
                         newFieldName= "inline_miss",
                         formulaText= "if(lpa_lpa9=='Yes' && (is.na(lpat_lpa9) || is.na(lpam_lpa9))){1} else {0}")
databox <- FunctionXform(databox,
                         origFieldName= c("inline_miss","lpa_lpa9", "lpat_lpa9", "lpam_lpa9"),
                         newFieldName= "inline",
                         formulaText= "if(inline_miss==1) {NA} else if(lpa_lpa9=='Yes' && lpam_lpa9=='lpa15'){(lpat_lpa9*0.2167*5)/90} else if(lpa_lpa9=='Yes' && lpam_lpa9=='lpa30'){(lpat_lpa9*0.3833*5)/90} else if(lpa_lpa9=='Yes' && lpam_lpa9=='lpa60'){(lpat_lpa9*0.75*5)/90} else if(lpa_lpa9=='Yes' && lpam_lpa9=='lpa61'){(lpat_lpa9*1*5)/90} else {0}")
databox <- FunctionXform(databox,
                         origFieldName= c("lpa_lpa10", "lpat_lpa10", "lpam_lpa10"),
                         newFieldName= "jogrun_miss",
                         formulaText= "if(lpa_lpa10=='Yes' && (is.na(lpat_lpa10) || is.na(lpam_lpa10))){1} else {0}")
databox <- FunctionXform(databox,
                         origFieldName= c("jogrun_miss","lpa_lpa10", "lpat_lpa10", "lpam_lpa10"),
                         newFieldName= "jogrun",
                         formulaText= "if(jogrun_miss==1) {NA} else if(lpa_lpa10=='Yes' && lpam_lpa10=='lpa15'){(lpat_lpa10*0.2167*9.5)/90} else if(lpa_lpa10=='Yes' && lpam_lpa10=='lpa30'){(lpat_lpa10*0.3833*9.5)/90} else if(lpa_lpa10=='Yes' && lpam_lpa10=='lpa60'){(lpat_lpa10*0.75*9.5)/90} else if(lpa_lpa10=='Yes' && lpam_lpa10=='lpa61'){(lpat_lpa10*1*9.5)/90} else {0}")
databox <- FunctionXform(databox,
                         origFieldName= c("lpa_lpa11", "lpat_lpa11", "lpam_lpa11"),
                         newFieldName= "golf_miss",
                         formulaText= "if(lpa_lpa11=='Yes' && (is.na(lpat_lpa11) || is.na(lpam_lpa11))){1} else {0}")
databox <- FunctionXform(databox,
                         origFieldName= c("golf_miss","lpa_lpa11", "lpat_lpa11", "lpam_lpa11"),
                         newFieldName= "golf",
                         formulaText= "if(golf_miss==1) {NA} else if(lpa_lpa11=='Yes' && lpam_lpa11=='lpa15'){(lpat_lpa11*0.2167*4)/90} else if(lpa_lpa11=='Yes' && lpam_lpa11=='lpa30'){(lpat_lpa11*0.3833*4)/90} else if(lpa_lpa11=='Yes' && lpam_lpa11=='lpa60'){(lpat_lpa11*0.75*4)/90} else if(lpa_lpa11=='Yes' && lpam_lpa11=='lpa61'){(lpat_lpa11*1*4)/90} else {0}")
databox <- FunctionXform(databox,
                         origFieldName= c("lpa_lpa12", "lpat_lpa12", "lpam_lpa12"),
                         newFieldName= "aerobics_miss",
                         formulaText= "if(lpa_lpa12=='Yes' && (is.na(lpat_lpa12) || is.na(lpam_lpa12))){1} else {0}")
databox <- FunctionXform(databox,
                         origFieldName= c("aerobics_miss","lpa_lpa12", "lpat_lpa12", "lpam_lpa12"),
                         newFieldName= "aerobics",
                         formulaText= "if(aerobics_miss==1) {NA} else if(lpa_lpa12=='Yes' && lpam_lpa12=='lpa15'){(lpat_lpa12*0.2167*4)/90} else if(lpa_lpa12=='Yes' && lpam_lpa12=='lpa30'){(lpat_lpa12*0.3833*4)/90} else if(lpa_lpa12=='Yes' && lpam_lpa12=='lpa60'){(lpat_lpa12*0.75*4)/90} else if(lpa_lpa12=='Yes' && lpam_lpa12=='lpa61'){(lpat_lpa12*1*4)/90} else {0}")
databox <- FunctionXform(databox,
                         origFieldName= c("lpa_lpa13", "lpat_lpa13", "lpam_lpa13"),
                         newFieldName= "ski_miss",
                         formulaText= "if(lpa_lpa13=='Yes' && (is.na(lpat_lpa13) || is.na(lpam_lpa13))){1} else {0}")
databox <- FunctionXform(databox,
                         origFieldName= c("ski_miss","lpa_lpa13", "lpat_lpa13", "lpam_lpa13"),
                         newFieldName= "ski",
                         formulaText= "if(ski_miss==1) {NA} else if(lpa_lpa13=='Yes' && lpam_lpa13=='lpa15'){(lpat_lpa13*0.2167*4)/90} else if(lpa_lpa13=='Yes' && lpam_lpa13=='lpa30'){(lpat_lpa13*0.3833*4)/90} else if(lpa_lpa13=='Yes' && lpam_lpa13=='lpa60'){(lpat_lpa13*0.75*4)/90} else if(lpa_lpa13=='Yes' && lpam_lpa13=='lpa61'){(lpat_lpa13*1*4)/90} else {0}")
databox <- FunctionXform(databox,
                         origFieldName= c("lpa_lpa14", "lpat_lpa14", "lpam_lpa14"),
                         newFieldName= "bowl_miss",
                         formulaText= "if(lpa_lpa14=='Yes' && (is.na(lpat_lpa14) || is.na(lpam_lpa14))){1} else {0}")
databox <- FunctionXform(databox,
                         origFieldName= c("bowl_miss","lpa_lpa14", "lpat_lpa14", "lpam_lpa14"),
                         newFieldName= "bowl",
                         formulaText= "if(bowl_miss==1) {NA} else if(lpa_lpa14=='Yes' && lpam_lpa14=='lpa15'){(lpat_lpa14*0.2167*2)/90} else if(lpa_lpa14=='Yes' && lpam_lpa14=='lpa30'){(lpat_lpa14*0.3833*2)/90} else if(lpa_lpa14=='Yes' && lpam_lpa14=='lpa60'){(lpat_lpa14*0.75*2)/90} else if(lpa_lpa14=='Yes' && lpam_lpa14=='lpa61'){(lpat_lpa14*1*2)/90} else {0}")
databox <- FunctionXform(databox,
                         origFieldName= c("lpa_lpa15", "lpat_lpa15", "lpam_lpa15"),
                         newFieldName= "baseball_miss",
                         formulaText= "if(lpa_lpa15=='Yes' && (is.na(lpat_lpa15) || is.na(lpam_lpa15))){1} else {0}")
databox <- FunctionXform(databox,
                         origFieldName= c("baseball_miss","lpa_lpa15", "lpat_lpa15", "lpam_lpa15"),
                         newFieldName= "baseball",
                         formulaText= "if(baseball_miss==1) {NA} else if(lpa_lpa15=='Yes' && lpam_lpa15=='lpa15'){(lpat_lpa15*0.2167*3)/90} else if(lpa_lpa15=='Yes' && lpam_lpa15=='lpa30'){(lpat_lpa15*0.3833*3)/90} else if(lpa_lpa15=='Yes' && lpam_lpa15=='lpa60'){(lpat_lpa15*0.75*3)/90} else if(lpa_lpa15=='Yes' && lpam_lpa15=='lpa61'){(lpat_lpa15*1*3)/90} else {0}")
databox <- FunctionXform(databox,
                         origFieldName= c("lpa_lpa16", "lpat_lpa16", "lpam_lpa16"),
                         newFieldName= "tennis_miss",
                         formulaText= "if(lpa_lpa16=='Yes' && (is.na(lpat_lpa16) || is.na(lpam_lpa16))){1} else {0}")
databox <- FunctionXform(databox,
                         origFieldName= c("tennis_miss","lpa_lpa16", "lpat_lpa16", "lpam_lpa16"),
                         newFieldName= "tennis",
                         formulaText= "if(tennis_miss==1) {NA} else if(lpa_lpa16=='Yes' && lpam_lpa16=='lpa15'){(lpat_lpa16*0.2167*4)/90} else if(lpa_lpa16=='Yes' && lpam_lpa16=='lpa30'){(lpat_lpa16*0.3833*4)/90} else if(lpa_lpa16=='Yes' && lpam_lpa16=='lpa60'){(lpat_lpa16*0.75*4)/90} else if(lpa_lpa16=='Yes' && lpam_lpa16=='lpa61'){(lpat_lpa16*1*4)/90} else {0}")
databox <- FunctionXform(databox,
                         origFieldName= c("lpa_lpa17", "lpat_lpa17", "lpam_lpa17"),
                         newFieldName= "weights_miss",
                         formulaText= "if(lpa_lpa17=='Yes' && (is.na(lpat_lpa17) || is.na(lpam_lpa17))){1} else {0}")
databox <- FunctionXform(databox,
                         origFieldName= c("weights_miss","lpa_lpa17", "lpat_lpa17", "lpam_lpa17"),
                         newFieldName= "weights",
                         formulaText= "if(weights_miss==1) {NA} else if(lpa_lpa17=='Yes' && lpam_lpa17=='lpa15'){(lpat_lpa17*0.2167*3)/90} else if(lpa_lpa17=='Yes' && lpam_lpa17=='lpa30'){(lpat_lpa17*0.3833*3)/90} else if(lpa_lpa17=='Yes' && lpam_lpa17=='lpa60'){(lpat_lpa17*0.75*3)/90} else if(lpa_lpa17=='Yes' && lpam_lpa17=='lpa61'){(lpat_lpa17*1*3)/90} else {0}")
databox <- FunctionXform(databox,
                         origFieldName= c("lpa_lpa18", "lpat_lpa18", "lpam_lpa18"),
                         newFieldName= "fishing_miss",
                         formulaText= "if(lpa_lpa18=='Yes' && (is.na(lpat_lpa18) || is.na(lpam_lpa18))){1} else {0}")
databox <- FunctionXform(databox,
                         origFieldName= c("fishing_miss","lpa_lpa18", "lpat_lpa18", "lpam_lpa18"),
                         newFieldName= "fishing",
                         formulaText= "if(fishing_miss==1) {NA} else if(lpa_lpa18=='Yes' && lpam_lpa18=='lpa15'){(lpat_lpa18*0.2167*3)/90} else if(lpa_lpa18=='Yes' && lpam_lpa18=='lpa30'){(lpat_lpa18*0.3833*3)/90} else if(lpa_lpa18=='Yes' && lpam_lpa18=='lpa60'){(lpat_lpa18*0.75*3)/90} else if(lpa_lpa18=='Yes' && lpam_lpa18=='lpa61'){(lpat_lpa18*1*3)/90} else {0}")
databox <- FunctionXform(databox,
                         origFieldName= c("lpa_lpa19", "lpat_lpa19", "lpam_lpa19"),
                         newFieldName= "volleyball_miss",
                         formulaText= "if(lpa_lpa19=='Yes' && (is.na(lpat_lpa19) || is.na(lpam_lpa19))){1} else {0}")
databox <- FunctionXform(databox,
                         origFieldName= c("volleyball_miss","lpa_lpa19", "lpat_lpa19", "lpam_lpa19"),
                         newFieldName= "volleyball",
                         formulaText= "if(volleyball_miss==1) {NA} else if(lpa_lpa19=='Yes' && lpam_lpa19=='lpa15'){(lpat_lpa19*0.2167*5)/90} else if(lpa_lpa19=='Yes' && lpam_lpa19=='lpa30'){(lpat_lpa19*0.3833*5)/90} else if(lpa_lpa19=='Yes' && lpam_lpa19=='lpa60'){(lpat_lpa19*0.75*5)/90} else if(lpa_lpa19=='Yes' && lpam_lpa19=='lpa61'){(lpat_lpa19*1*5)/90} else {0}")
databox <- FunctionXform(databox,
                         origFieldName= c("lpa_lpa20", "lpat_lpa20", "lpam_lpa20"),
                         newFieldName= "basketball_miss",
                         formulaText= "if(lpa_lpa20=='Yes' && (is.na(lpat_lpa20) || is.na(lpam_lpa20))){1} else {0}")
databox <- FunctionXform(databox,
                         origFieldName= c("basketball_miss","lpa_lpa20", "lpat_lpa20", "lpam_lpa20"),
                         newFieldName= "basketball",
                         formulaText= "if(basketball_miss==1) {NA} else if(lpa_lpa20=='Yes' && lpam_lpa20=='lpa15'){(lpat_lpa20*0.2167*6)/90} else if(lpa_lpa20=='Yes' && lpam_lpa20=='lpa30'){(lpat_lpa20*0.3833*6)/90} else if(lpa_lpa20=='Yes' && lpam_lpa20=='lpa60'){(lpat_lpa20*0.75*6)/90} else if(lpa_lpa20=='Yes' && lpam_lpa20=='lpa61'){(lpat_lpa20*1*6)/90} else {0}")
databox <- FunctionXform(databox,
                         origFieldName= c("lpa_lpa21", "lpat_lpa21", "lpam_lpa21"),
                         newFieldName= "soccer_miss",
                         formulaText= "if(lpa_lpa21=='Yes' && (is.na(lpat_lpa21) || is.na(lpam_lpa21))){1} else {0}")
databox <- FunctionXform(databox,
                         origFieldName= c("soccer_miss","lpa_lpa21", "lpat_lpa21", "lpam_lpa21"),
                         newFieldName= "soccer",
                         formulaText= "if(soccer_miss==1) {NA} else if(lpa_lpa21=='Yes' && lpam_lpa21=='lpa15'){(lpat_lpa21*0.2167*5)/90} else if(lpa_lpa21=='Yes' && lpam_lpa21=='lpa30'){(lpat_lpa21*0.3833*5)/90} else if(lpa_lpa21=='Yes' && lpam_lpa21=='lpa60'){(lpat_lpa21*0.75*5)/90} else if(lpa_lpa21=='Yes' && lpam_lpa21=='lpa61'){(lpat_lpa21*1*5)/90} else {0}")
databox <- FunctionXform(databox,
                         origFieldName= c("lpa_lpa22", "lpat_lpa22", "lpam_lpa22"),
                         newFieldName= "other_miss",
                         formulaText= "if(lpa_lpa22=='Yes' && (is.na(lpat_lpa22) || is.na(lpam_lpa22))){1} else {0}")
databox <- FunctionXform(databox,
                         origFieldName= c("other_miss","lpa_lpa22", "lpat_lpa22", "lpam_lpa22"),
                         newFieldName= "other",
                         formulaText= "if(other_miss==1) {NA} else if(lpa_lpa22=='Yes' && lpam_lpa22=='lpa15'){(lpat_lpa22*0.2167*4)/90} else if(lpa_lpa22=='Yes' && lpam_lpa22=='lpa30'){(lpat_lpa22*0.3833*4)/90} else if(lpa_lpa22=='Yes' && lpam_lpa22=='lpa60'){(lpat_lpa22*0.75*4)/90} else if(lpa_lpa22=='Yes' && lpam_lpa22=='lpa61'){(lpat_lpa22*1*4)/90} else {0}")

databox <- FunctionXform(databox,
                         origFieldName = c("lpa_lpa0", "walking_miss", "garden_miss", "swim_miss", "bike_miss", "dance_miss", "hexercises_miss", "hockey_miss", "skate_miss", "inline_miss", "jogrun_miss", "golf_miss", "aerobics_miss", "ski_miss", "bowl_miss", "baseball_miss", "tennis_miss", "weights_miss", "fishing_miss", "volleyball_miss", "basketball_miss", "soccer_miss", "other_miss"),
                         newFieldName = "noactivity",
                         formulaText = "if(lpa_lpa0=='Yes' && walking_miss==1 && garden_miss==1 && swim_miss==1 && bike_miss==1 && dance_miss==1 && hexercises_miss==1 && hockey_miss==1 && skate_miss==1 && inline_miss==1 && jogrun_miss==1 && golf_miss==1 && aerobics_miss==1 && ski_miss==1 && bowl_miss==1 && baseball_miss==1 && tennis_miss==1 && weights_miss==1 && fishing_miss==1 && volleyball_miss==1 && basketball_miss==1 && soccer_miss==1 && other_miss==1) {1} else {0}",
                         mapMissingTo = NA)
databox <- FunctionXform(databox,
                         origFieldName= c("noactivity", "walking", "garden", "swim", "bike", "dance", "hexercises", "hockey", "skate", "inline", "jogrun", "golf", "aerobics", "ski", "bowl", "baseball", "tennis", "weights", "fishing", "volleyball", "basketball", "soccer", "other", "missingactivity"),
                         newFieldName= "PhysicalActivity_cont",
                         formulaText="if(missingactivity==1) {NA} else if(noactivity==1) {0} else {(log(1+ walking + garden + swim + bike + dance + hexercises + hockey + skate + inline + jogrun + golf + aerobics + ski + bowl + baseball + tennis + weights + fishing + volleyball + basketball + soccer + other))/log(10)}",
                         mapMissingTo = NA)

##Chronic Conditions##
#Heart Disease#
databox <- FunctionXform(databox,
                         origFieldName= c("hd"),
                         newFieldName= "HeartDis_cat",
                         formulaText= "if(is.na(hd)) {NA} else if(hd=='hd1'){1} else {0}",
                         mapMissingTo = NA)
#Diabetes#
databox <- FunctionXform(databox,
                         origFieldName= "diab",
                         newFieldName= "Diabetes_cat",
                         formulaText= "if(is.na(diab)) {NA} else if(diab=='diab1'){1} else {0}",
                         mapMissingTo = NA)
#Stroke#
databox <- FunctionXform(databox,
                         origFieldName= "stk",
                         newFieldName= "Stroke_cat",
                         formulaText= "if(is.na(stk)) {NA} else if(stk=='stk1'){1} else {0}",
                         mapMissingTo = NA)
#Cancer#
databox <- FunctionXform(databox,
                         origFieldName= "can",
                         newFieldName= "Cancer_cat",
                         formulaText= "if(is.na(can)) {NA} else if(can=='can1'){1} else {0}",
                         mapMissingTo = NA)

#Diabetes Age Interaction#
databox <- FunctionXform(databox,
                         origFieldName= c("Diabetes_cat", "Age_cont"),
                         newFieldName= "DiabetesAge_Int",
                         formulaText= "{Diabetes_cat*Age_cont}")

#Cancer Age Interaction#
databox <- FunctionXform(databox,
                         origFieldName= c("Cancer_cat", "Age_cont"),
                         newFieldName= "CancerAge_Int",
                         formulaText= "{Cancer_cat*Age_cont}")

#BMI#
databox <- FunctionXform(databox,
                         origFieldName= "weightlb",
                         newFieldName= "weightkg",
                         formulaText= "{(weightlb/2.2046226218)}")
databox <- FunctionXform(databox,
                         origFieldName="heightin_hft, heightin_hin",
                         newFieldName= "heightm",
                         formulaText= "{((heightin_hft*12)+heightin_hin)/39.3701}")
databox <- FunctionXform(databox,
                         origFieldName="weightkg, heightm",
                         newFieldName= "BMI",
                         formulaText= "{weightkg/(heightm*heightm)}")
databox <- FunctionXform(databox,
                         origFieldName="weightkg, heightm",
                         newFieldName= "BMI_spline", 
                         formulaText= "if((BMI-35)<=0){0} else if((BMI-35)>0){BMI-35} else {NA}")


#kable(head(databox$data,100))

save(databox, file="MPoRTFemaleDatabox.rda")


#load(file="MPoRTdatabox.rda")
#load(file="C:\\Users\\stfisher\\Desktop\\Stacey MPoRT PMML Trans\\MPoRTdatabox.rda")


#Model
#model <- coxph(Surv(time, death) ~ Age_cont + Age_spline + EduHSGrad_cat + EduNoGrad_cat + ImEth0To15_cat + ImEth16To30_cat + ImEth31To45_cat 
#               + DepIndMod_cat + DepIndHigh_cat + QSLight_df + QSHeavy_df + PhysicalActivity_cont + DietScore_cont + HeartDis_cat + Stroke_cat + BMI_spline + Cancer_cat 
#               + Diabetes_cat + CancerAge_Int + DiabetesAge_Int, data=databox$data, robust=TRUE)

#save(model, file="MPoRTmodel1.rda")

#PMML
#sink('output.txt')
#output1 <- pmml(model, transform=databox)
#print(output1)
#sink()
#file.show("output.txt")

#Transformations
sink("MPoRT Female Transformation Output.txt")
output1 <- pmml(, transform=databox)
print(output1)
sink()
file.show("MPoRT Female Transformation Output.txt")
save(output1.txt)

