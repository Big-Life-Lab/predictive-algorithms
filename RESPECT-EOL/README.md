# RESPECT-EOL - Predictions for Elder-life in the Community Tool - End-of-life(RESPECT-EOL)

**Risk Evaluation for Support: Predictions for Elder-life in the Community Tool: for End-of-life (RESPECT)**. 

This algorithm is currently under development.

RESPECT-EOL is algorithm to predict survival time for older adults in the home care setting. Developed and validated using Resident Assessment Instrument for Home Care (RAI-HC) data in Ontario, Canada, from 1 January 2007 to 31 December 2013. There were 488,636 participants with 836,012 assessments and 298,657 deaths in the combined derivation and calibration cohort. The primary outcome was median survival time with 25th to 75th survival percentiles.

Survival time is generated in a two-step process by rank ordering participants into 61 groups based on six-month probability of death (from a Cox-proportional hazard model) and generating Kaplan-Meier five-year survival curves for each group. The median predicted six-month probability of death is 0.1095% (0.1093 to 0.1097, 95% CI). Risk varies among the 61 groups from 0.0158 (0.0158-0.0159) to 0.9820 (0.9810-0.9830). Median observed survival time varies from 27 days (10 to 81 days, 25th and 75%ile) in the highest risk group to 10 years (3655 days (2111 to > 3655 days)) in the lowest risk group.

## Files ##
**Algorithm testing data**  

_RESPECT-EOL_validation.csv_ 

60 533 rows respresenting valid examples of input data with all predictors required for algorithm scoring. Also included is centred input variables, dummy variables and algorithm output includig X-beta for each coefficient, sum of betas, and bin values.


**References**

1. Hsu AT, Manuel DG, Taljaard M, Chalifoux M, Bennett C, Costa AP, et al. Algorithm for predicting death among older adults in the home care setting: study protocol for the Risk Evaluation for Support: Predictions for Elder-life in the Community Tool (RESPECT). [BMJ open. 2016;6(12)](http://bmjopen.bmj.com/content/6/12/e013666)