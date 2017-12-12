# Predictive algorithm reference documents

## Two documents describe the algorithms

**1) Questionnaire file**. This file describes questions for the predictors. The questions are the same as those questions in the surveys  or assessment instruments used to create the predictive algorithms. Also included are the allowed responses and response skip patterns.

The question file is a LimeSurvey survey template (.lss and .csv).  [https://www.limesurvey.org](https://www.limesurvey.org/)

**2) Algorithm file**. This file describes the method to calculate the risk of the outcome, based on the predictors from the questionnaire file.

The algorithm files are Predictive Modelling Markup Language (PMML 4.1) documents (.xml). [http://dmg.org](http://dmg.org/)

## Additional reference files

Individual algorithms may have additional reference files. These files are described in the README within each algorithm folder.

Examples of additional files include:

**1) Re-calibration data** - These data ensure algorithms provide well-calibrated estimates in different settings.[[1]](#ref1)

There are two types of calibration data:

* **Population distribution of the predictors** - All algorithms within this repository are developed by centring predictive risks within the development data. Following, the algorithms are calibrated by centring all predictors in the new application data. Centring is performed using data that describes the distribution of the predictors in the application population. This means that a a person with the average (mean) predictor exposure has a hazard of 1 for that predictor. A theorectical person with the average (mean) exposure for all predictors would have a predictive risk that is equal to the observed (mean) risk for the entire population.

  Population distribution data include predictive risks for percentile of risk exposure. Calibration data may also include distibution of predictors across age, sex or other subgroups.

  Population distribution data are stored as CSV or JSON files and can be identified by the term "distribution" in the title of the data file.

* **Population outcome** - Algorithms are calibrated to the population outcome, stratifyied by age and sex. Calibration ensures that the predictive risk is equal to the observed risk in the application setting. To perform calibration, the risk algorithm is applied to a population-based sample to generate predictive estimates of population risk. The predicted population risk is compared to the observed population risk, with a corresponding adjustment made to the baseline hazard (for example see H<sub>Adj</sub> in [Table S7](http://journals.plos.org/plosmedicine/article/asset?unique&id=info:doi/10.1371/journal.pmed.1002082.s012) of reference [[1]](#ref1)).

  Population outcome data include age and sex-stratefied risk of outcome, but may also include additional subgroups.

  Please feel free to add calibration tables for different settings, or contact the algorithm development teams if you are interested in calibrating algorithms for your setting.

**2) Algorithm development files** - The files contain code that was used to develop the algorithm or reference documents. For example, algorithms may contain the R databox code used to derive predictive risks from the original development data. This R code can facilitate development, validation or calibration studies.

**3) Algorithm testing data** - These data can be use to test whether a scoring engine is performing correct calculations.  Each row in a CSV file contains values for each predictor in an algorithm, along with the score or algorithm outcome. The data can be used for other purposes, such as creating or testing new algorithm development. Unless specifically identifyied, the algorthim testing data should not be used for calbiration because these data are not representitive of an actual application population.

Testing data are stored as CSV or JSON files and can be identified by the term "test" in the title of the data file.

## How to calculate risk using the reference documents

There several approaches to calculate risk using the provided documents:

**1)** The predictive algorithm parameters within the PMML files can be transcribed into all common programming languages or even used within spreadsheet programs such as MS Excel or Google Sheets.

**2)** PMML can also be used within specifically-designed calculation or scoring engines such as [http://openscoring.io](http://openscoring.io/) or  [https://zementis.com](https://zementis.com).

**3)** We have an API to perform calculations based on the PMML files within this repository. [API documentation.](https://ottawa-mhealth.github.io/pbl-calculator-engine-docs/) For example, see Heart and Stroke Foundation’s [eHealth Risk Assessment](https://ehealth.heartandstroke.ca). APIs provide additional outcome measures and features. For example, the MPoRT algorithm main outcome is 1-year risk, but also provided are:

* life expectancy;
* survival to specified age ("Will you live to see it?);
* health age (users age compared to a reference population).

All health outcome measures can be estimated considering the effect of:

* health behaviours (smoking, alcohol, diet and exercise);
* health interventions; and,
* external risks not included in the original algorithm (e.g. the effect of air pollution on life expectancy (see [ProjectBigLife.ca](https://projectbiglife.ca)).

Please contact dmanuel@ohri.ca for more information about connecting to our API.

**4)** Individual risk calculations can be performed at [https://projectbiglife.ca](https://projectbiglife.ca).

## Suggestions and collaboration

We welcome suggestions to improve algorithm documentation or implementation of the risk tools. Feel free to open a new issue, pull request or fork.

We also welcome collaborations for future development, validation, calibration or application of the risk tools. Contact Doug Manuel at [dmanuel@ohri.ca](mailto:dmanuel@ohri.ca)

## Algorithms

**Mortality Population Risk Tool (MPoRT).** A predictive algorithm for the calculation of 5-year risk of dying from all-causes. Developed and validated using the 2001 to 2008 Canadian Community Health Surveys (CCHS) with approximately 1 million person-years of follow-up and 9,900 deaths. Focus on health behaviours (smoking, diet, physical inactivity and alcohol consumption). The model is currently calibrated for Canada, 2013, with provisions to calibrate to other countries.[[1]](#ref1)

**Stroke Population Risk Tool (SPoRT).** A predictive algorithm for the calculation of 5-year incident risk of major stroke (hospitalization or death). Developed and validated using the 2001 to 2008 Canadian Community Health Surveys (CCHS) with approximately 1 million person-years and 3 236 incident stroke events. Focus on health behaviours (smoking, diet, physical inactivity and alcohol consumption).[[2]](#ref2)

**Cardiovascular Population Risk Tool (CVDPoRT).** CVDPoRT is currently under development. The protocol has been published: trial registration number NCT02267447 at [ClinicalTrials.gov](https://clinicaltrials.gov/show/NCT02267447) or reference.[[3]](#ref3)

**Dementia Population Risk Tool (DemPoRT).** DemPoRT is currently under development. The protocol has been published: trial registration number NCT03155815 at [ClinicalTrials.gov](https://clinicaltrials.gov/show/NCT03155815) or reference.[[4]](#ref4)

**Predictions for Elder-life in the Community Tool - End-of-life(RESPECT-EOL).** RESPECT-EOL is currently under development. The protocol has been published: trial registration number NCT02779309 at [ClinicalTrials.gov](https://clinicaltrials.gov/show/NCT02779309) or reference.[[5]](#ref5)

## References

1. <a name="ref1"></a> Manuel DG, Perez R, Sanmartin C, Taljaard M, Hennessy D, Wilson K, et al. (2016) **Measuring Burden of Unhealthy Behaviours Using a Multivariable Predictive Approach: Life Expectancy Lost in Canada Attributable to Smoking, Alcohol, Physical Inactivity, and Diet**. PLoS Med 13(8): e1002082. [doi:10.1371/journal.pmed.1002082](http://journals.plos.org/plosmedicine/article?id=10.1371/journal.pmed.1002082)

1. <a name="ref2"></a> Manuel DG, Tuna M, Perez R, Tanuseputro P, Hennessy D, Bennett C, Rosella R, Sanmartin C, van Walraven C, Tu JV. **Predicting Stroke Risk Based on Health Behaviours: Development of the Stroke Population Risk Tool (SPoRT)**. PloS One. 2015 Dec 4;10(12):e0143342. [http://journals.plos.org/plosone/article?id=10.1371/journal.pone.0143342](http://journals.plos.org/plosone/article?id=10.1371/journal.pone.0143342)

1. <a name="ref3"></a> Taljaard M, Tuna M, Bennett C, Perez R, Rosella L, Tu JV, et al. **Cardiovascular Disease Population Risk Tool (CVDPoRT): predictive algorithm for assessing CVD risk in the community setting. A study protocol.** [BMJ open. 2014;4(10):e006701.](http://bmjopen.bmj.com/content/4/10/e006701.full)

1. <a name="ref4"></a> Fisher S, Hsu A, Mojaverian N, Taljaard M, Huyer G, Manuel DG, et al. **Dementia Population Risk Tool (DemPoRT): study protocol for a predictive algorithm assessing dementia risk in the community.** [BMJ open. 2017;7(10).](http://bmjopen.bmj.com/content/7/10/e018018)

1. <a name="ref5"></a> Hsu AT, Manuel DG, Taljaard M, Chalifoux M, Bennett C, Costa AP, et al. Algorithm for predicting death among older adults in the home care setting: study protocol for the Risk Evaluation for Support: Predictions for Elder-life in the Community Tool (RESPECT). [BMJ open. 2016;6(12).](http://bmjopen.bmj.com/content/6/12/e013666).

## Glossary of terms

***Input***

`inputName`: The name of the (Lime) web questionnaire for each exposure. For example, a Lime web questionnaire asks questions (inputs) for different types of physical activity (e.g. walking, running, biking).

***Transformation***

Transformation are steps between **input** and **predictor**.  For example, different types of physical activity inputs (walking, running) are added together and summarized as weekly METS.  The result of the transformation are values for the corresponding `predictorName`. For example, the different physical activity `inputNames` are summarized into `activity_cont`, the `predictorName` for physical activity within MPoRT and other risk algorithms.

`inputName`: The input for the transformation. The transformation `inputName` is the same as the input `imputName`.

`newFeildName`: Intermediate steps for the transformation. `newFeildName` provide values for `predictorName`, if transformation is required. (Example of mets..)

`equation`: The equation that transforms the values from the `inputName` to the values for the `variableName`.

***Predictor***

`predictorName`: The name of the beta coefficent in a risk algorithm. e.g. `activity_cont` is the `predictorName` for physical activity. The suffix `_cont` indicates that this predictor is a continous variable (e.g. METS or metabolic equivalents).

`beta`: the beta coeffecient for each `predictorName`.

`referencePoint`: The reference for the beta coefficient. The typical `referencePoint` for predictive algorithms in this repository is the population average for a `predictorName` within the development population. Using a 'centred' mean `referencePoint` facilitates recalibration in different populations. Alternative `referencePoint`s may be available in the calibration tables. For example, the MPoRT algorithm was developed using Ontario, Canada, 2001 to 2007. The population average (mean) physical activity for males was 0.432 log METS. Of note, 10e0.432 = 2.7 METS, the averate weekly METS in the development cohort. The recommended physical activity in Canada and many other countries is 15 METs per week. Calibration to a new population should include `referencePoint` values that correspond to that new population.
