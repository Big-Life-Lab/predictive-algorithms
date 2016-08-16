# Predictive algorithms reference documents

## Two documents describe the algorithms

**1) Questionnaire file**. This file describes questions for the predictors. The questions are the same as those questions in the surveys  or assessment instruments used to create the predictive algorithms. Also included are the allowed responses and response skip patterns.

The question file is a LimeSurvey survey template (.lss and .csv).  [https://www.limesurvey.org](https://www.limesurvey.org/)

**2) Algorithm file**. This file describes the method to calculate the risk of the outcome, based on the predictors from the questionnaire file.

The algorithm files are Predictive Modelling Markup Language (PMML 4.1) documents (.xml). [http://dmg.org](http://dmg.org/)

## Additional reference files

Individual algorithms may have additional reference files. These files are described in the README within each algorithm folder.

Examples of additional files include:

**1) Calibration data** - These data ensure algorithms provide well-calibrated estimates in different settings.[1](#ref1)

There are two types of calibration data:
* **Population distribution of the predictors** - All algorithms within this repository are developed by centring predictive risks within the development data. Following, the algorithms are calibrated by centring all predictors in the new application data. Centring is performed using data that describes the distribution of the predictors in the application population. This means that a a person with the average (mean) predictor exposure has a hazard of 1 for that predictor. A theorectical person with the average (mean) exposure for all predictors would have a predictive risk that is equal to the observed (mean) risk for the entire population.

  Population distribution data include predictive risks for percentile of risk exposure. Calibration data may also include distibution of predictors across age, sex or other subgroups.

  Population distribution data are stored as CSV or JSON files and can be identified by the term "distribution" in the title of the data file.

* **Population outcome** - Algorithms are calibrated to the population outcome, stratifyied by age and sex. Calibration ensures that the predictive risk is equal to the observed risk in the application setting. To perform calibration, the risk algorithm is applied to a population-based sample to generate predictive estimates of population risk. The predicted population risk is compared to the observed population risk, with a corresponding adjustment made to the baseline hazard (for example see H<sub>Adj</sub> in [Table S7](http://journals.plos.org/plosmedicine/article/asset?unique&id=info:doi/10.1371/journal.pmed.1002082.s012) of reference [1]).

  Population outcome data include age and sex-stratefied risk of outcome, but may also include additional subgroups.

  Please feel free to add calibration tables for different settings, or contact the algorithm development teams if you are interested in calibrating algorithms for your setting.

**2) Algorithm development files** - The files contain code that was used to develop the algorithm or reference documents. For example, algorithms may contain the R databox code used to derive predictive risks from the original development data. This R code can facilitate development, validation or calibration studies.

**3) Algorithm testing data** - These data can be use to test whether a scoring engine is performing correct calculations.  Each row in a CSV file contains values for each predictor in an algorithm, along with the score or algorithm outcome. The data can be used for other purposes, such as creating or testing new algorithm development. Unless specifically identifyied, the algorthim testing data should not be used for calbiration because these data are not representitive of an actual application population.

Testing data are stored as CSV or JSON files and can be identified by the term "test" in the title of the data file.

## How to calculate risk using the reference documents
There several approaches to calculate risk using the provided documents:

**1)** The predictive algorithm parameters within the PMML files can be transcribed into all common programming languages or even used within spreadsheet programs such as MS Excel or Google Sheets.

**2)** PMML can also be used within specifically-designed calculation or scoring engines such as [http://openscoring.io](http://openscoring.io/) or  [https://zementis.com](https://zementis.com).

**3)** We have APIs to perform calculations, based on the PMML files within this repository. For example, see Heart and Stroke Foundation’s eHealth Risk Assessment. [https://ehealth.heartandstroke.ca](https://ehealth.heartandstroke.ca) APIs provide additional outcome measures. For example, the MPoRT algorithm main outcome is 1-year risk, but also provided are life expectancy, survival to specified age, life expectancy lost from health behaviours (smoking, alcohol, diet and exercise).  Please contact dmanuel@ohri.ca for more information about connecting to our API.

**4)** Individual risk calculations can be performed at [https://projectbiglife.ca](https://projectbiglife.ca)

## Suggestions and collaboration
We welcome suggestions to improve algorithm documentation or implementation of the risk tools. Feel free to open a new issue, pull request or fork.

We also welcome collaborations for future development, validation, calibration or application of the risk tools. Contact Doug Manuel at [dmanuel@ohri.ca](mailto:dmanuel@ohri.ca)

## Algorithms

**Mortality Population Risk Tool (MPoRT).** A predictive algorithm for the calculation of 5-year risk of dying from all-causes. Developed and validated using the 2001 to 2008 Canadian Community Health Surveys (CCHS) with approximately 1 million person-years of follow-up and 9,900 deaths. Focus on health behaviours (smoking, diet, physical inactivity and alcohol consumption). The model is currently calibrated for Canada, 2013, with provisions to calibrate to other countries.[[1]](#ref1)


**Cardiovascular Population Risk Tool (CVDPoRT).** CVDPoRT is currently under development. The protocol has been published: trial registration number NCT02267447 at [ClinicalTrials.gov](https://clinicaltrials.gov/show/NCT02267447) or reference [[2]](#ref2).

## References

<a name="ref1">1)</a> Manuel DG, Perez R, Sanmartin C, Taljaard M, Hennessy D, Wilson K, et al. (2016) **Measuring Burden of Unhealthy Behaviours Using a Multivariable Predictive Approach: Life Expectancy Lost in Canada Attributable to Smoking, Alcohol, Physical Inactivity, and Diet**. PLoS Med 13(8): e1002082. [doi:10.1371/journal.pmed.1002082](http://journals.plos.org/plosmedicine/article?id=10.1371/journal.pmed.1002082)

<a name="ref2">2)</a> Taljaard M, Tuna M, Bennett C, Perez R, Rosella L, Tu JV, et al. **Cardiovascular Disease Population Risk Tool (CVDPoRT): predictive algorithm for assessing CVD risk in the community setting. A study protocol.** [BMJ open. 2014;4(10):e006701.](http://bmjopen.bmj.com/content/4/10/e006701.full)

