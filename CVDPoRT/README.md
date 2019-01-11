# CVDPoRT - Cardiovascular Population Risk Tool

See [projectbiglife.ca](https://www.projectbiglife.ca) for an example of indivudal calculations of 5-year risk and 'heart age', as well as additional infomation about the algorithm and API.  

**Cardiovascular Disease Population Risk Tool (CVDPoRT).** A predictive algorithm for the calculation of 5-year risk of cardiovascular disease. Developed and validated using the 2001 to 2008 Canadian Community Health Surveys (CCHS).  Focus is on health behaviours (smoking, diet, physical inactivity and alcohol consumption). The model is currently calibrated for Canada, 2013, with provisions to calibrate to other countries.

There were 104  219 respondents aged 20 to 105 years, 3709 cardiovascular events, and 818  478 person-years follow-up in the combined derivation and validation cohorts.

*5-year cumulative incidence function.*
Men: 0.026, 95% confidence interval [CI] 0.025–0.028; women: 0.018, 95% 0.017–0.019).

*Discrimination.* Men: C statistic 0.82, 95% CI 0.81–0.83; women: 0.86, 95% CI 0.85–0.87).

*Calibration.* Overall population (5-year observed cumulative incidence function v. predicted risk, men: 0.28%; women: 0.38%). Calibration slope for women: 0.9734, SE 0.0698; for men: 0.9295, SE 0.0731. Observed versus predicted < 20% difference in predefined policy-relevant subgroups (206 of 208 groups) at P<0.05.

Trial registration: ClinicalTrials.gov, no. NCT02267447

## Algorithm viewer

[algorithm-viewer.projectbiglife.ca](http://algorithm-viewer.projectbiglife.ca)

Generated using CVDPoRT PMML files and ProjectBigLife scoring engine.

## Reduced algorithm (CVDPoRT-R)

The recommend algorithm for use in the clinical or population setting.

### Files include

*model.xml* - The model specified as a PMML file.

*score-data.csv* - Examples of risk calculations. These examples are fictious. Included are calculations for intermidiate steps of the algorithm calculations.

*500betaCoeff.csv* - Bootstrap file containing a series of 500 betacoefficients. This file can be used to generate statistical uncertainity for either indivudal or population estimates.

*age-reference.json* - Exposure of predictors for indivdual ages in the combined development and validation data. Mean exposure using a five-year age moving average.

*percentile.

*health-age.json* - to be added. Mean 5-year risk of the full data (combined development and validation data), using a 3-year moving average.

## References

1. Manuel DG, Tuna M, Bennett C,  Hennessy D, Rosella L, Sanmartin C, Tu JV, Perez R, Fisher S, Taljaard M (2018) **Development and validation of a cardiovascular disease risk-prediction model using population health surveys: the Cardiovascular Disease Population Risk Tool (CVDPoRT)**. [CMAJ 2018 Month X;190:E871-E882; DOI: 10.1503/cmaj.170914](http://www.cmaj.ca/content/190/29/E871)

Algorithm viewer [https://ottawa-mhealth.github.io/PBL-algorithm-viewer/](https://ottawa-mhealth.github.io/PBL-algorithm-viewer/)
