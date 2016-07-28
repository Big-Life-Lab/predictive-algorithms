# Predictive algorithms reference documents

## Two documents describe the algorithms

**1) Questionnaire file**. This file describes questions for the predictors. The questions are the same as those questions in the surveys  or assessment instruments used to create the predictive algorithms. Also included are the allowed responses and response skip patterns.

The question file is a LimeSurvey survey template (.lss and .csv).  [https://www.limesurvey.org](https://www.limesurvey.org/)

**2) Algorithm file**. This file describes the method to calculate the risk of the outcome, based on the predictors from the questionnaire file.

The algorithm files are Predictive Modelling Markup Language (PMML 4.1) documents (.xml). [http://dmg.org](http://dmg.org/)

## Additional reference files

Individual algorithms may have additional reference files. These files are described in the README within each algorithm folder.

Examples of additional files include:

**1) Calibration data** - These data ensure algorithms provide well-calibrated estimates in different settings.[see reference 1 and 2] For the most part, calibration adjusts age and sex-specific risk estimates based on the population distribution of predictors in different settings (i.e. countries) and rate of the risk outcome in a population. Calibration data are tables stored as CSV or JSON files.

Please feel free to add calibration tables for different settings, or contact the algorithm development teams if you have an interested in calibrating algorithms for your setting.

**2) Algorithm development files** - The files contain code that was used to develop the algorithm or reference documents. For example, algorithms may contain the R databox code used to derive predictive risks from the original development data. This R code can facilitate development, validation or calibration studies.

**3) Algorithm testing data** - These data can be use to test whether a scoring engine is performing correct calculations. Testing data are store as CSV or JSON files. Each row in a CSV file contains values for each predictor in an algorithm, along with the score or algorithm outcome. The data can be used for other purposes, such as creating or testing new algorithm development.

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

**Mortality Population Risk Tool (MPoRT).** A predictive algorithm for the calculation of 5-year risk of dying from all-causes. Developed and validated using the 2001 to 2008 Canadian Community Health Surveys (CCHS) with approximately 1 million person-years of follow-up and 9,900 deaths. Focus on health behaviours (smoking, diet, physical inactivity and alcohol consumption). The model is currently calibrated for Canada, 2013, with provisions to calibrate to other countries.

Reference: In process.

**Cardiovascular Population Risk Tool (CVDPoRT).** CVDPoRT is currently under development. The protocol has been published: trial registration number NCT02267447 at ClinicalTrials.gov see:

[http://bmjopen.bmj.com/content/4/10/e006701.full] (http://bmjopen.bmj.com/content/4/10/e006701.full)

or,

[https://clinicaltrials.gov/show/NCT02267447] (https://clinicaltrials.gov/show/NCT02267447)
