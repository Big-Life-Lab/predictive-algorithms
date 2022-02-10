# DemPoRT - Dementia Population Risk Tool

**Dementia Population Risk Tool (DemPoRT).** A predictive algorithm for the calculation of 5-year risk of dementia. Developed and validated using the 2001 to 2011/12 Canadian Community Health Surveys (CCHS). Includes variables of improtance to population health planning including health behaviours and sociodemographic information.

There were 78 097 respondents aged 55+ years, 8 448 dementia events, and 630328 person-years follow-up in the combined derivation and validation cohorts.

*5-year cumulative incidence*
Men: 0.044, 95% confidence interval [CI] 0.042–0.047; women: 0.057, 95% 0.055–0.060).

*Discrimination*
Men: C statistic 0.83, 95% CI 0.81–0.84; women: 0.83, 95% CI 0.81–0.85).

*Calibration*
Overall population (5-year observed cumulative incidence function v. predicted risk, men: -0.61%; women: -0.78%). Calibration slope for men: 0.8240; for women: 0.8320. Observed versus predicted < 20% difference in predefined policy-relevant subgroups where at least 5% of individuals developed dementia(men: 68 of 88 groups; women: 86 of 98 groups) at P<0.05.

Trial registration: ClinicalTrials.gov, no. NCT03155815

## Reduced algorithm (DemPoRT-R)

The recommend algorithm for use in the clinical or population setting.

### Files include:

*DemPoRT-survey-structure.lss* - Lime Survey file of the survey questions, including skip patterns

*predictive-betas.csv* - Model beta coefficients

*variables.csv* - Variable information including labels

*local-transformations.xml* - Describes how the answers to the survey questions are transformed in to the final model variables

*score-data.csv* - Examples of risk calculations. These examples are fictious. Included are calculations for intermediate steps of the algorithm calculations - to be added

*100betaCoeff.csv* - Bootstrap file containing a series of 100 betacoefficients. This file can be used to generate statistical uncertainity for either indivudal or population estimates - to be added

*age-reference.json* - Exposure of predictors for indivdual ages in the combined development and validation data. Mean exposure using a five-year age moving average - to be added

*percentile-reference.json* -  to be added



## References

1. Fisher S, Hsu H, Mojaverian N, Taljaard M, Huyer G, Manuel DG, Tanuseputro P (2018) **Dementia Population Risk Tool (DemPoRT): Study protocol for a predictive algorithm assessing dementia risk in the community**. [BMJ Open 2017;7(10):e01801](https://bmjopen.bmj.com/content/7/10/e018018)

