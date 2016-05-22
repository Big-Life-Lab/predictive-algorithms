# Predictive algorithms reference documents

## Two documents describe the algorithms

**1) Questionnaire file**. This file describes questions for the predictors. The questions are the same as those questions in the surveys  or assessment instruments used to create the predictive algorithms. Also included are the allowed responses and response skip patterns.

The question file is a LimeSurvey survey template (.lss and .csv).  [https://www.limesurvey.org](https://www.limesurvey.org/)

**2) Algorithm file**. This file describes the method to calculate the risk of the outcome, based on the predictors from the questionnaire file.

The algorithm file is a Predictive Modelling Markup Language (PMML 4.1) document. [http://dmg.org](http://dmg.org/)

## How to calculate risk using the reference documents
There several approaches to calculate risk using the provided documents:

1. The predictive algorithm parameters within the PMML files can be transcribed into all common programming languages or even used within spreadsheet programs such as MS Excel or Google Sheets.

2. PMML can also be used within specifically-designed calculation or scoring engines such as [http://openscoring.io](http://openscoring.io/) or  [https://zementis.com](https://zementis.com).

3. We have an API to perform calculations, based on the PMML files within this repository. For example, see Heart and Stroke Foundation’s eHealth Risk Assessment. [https://ehealth.heartandstroke.ca](https://ehealth.heartandstroke.ca) Please contact dmanuel@ohri.ca for more information about connecting to our API.

4. Individual risk calculations can be performed at [https://projectbiglife.ca](https://projectbiglife.ca)

## Suggestions and collaboration
We welcome suggestions to improve algorithm documentation or implementation of the risk tools. Feel free to open a new issue, pull request or fork.

We also welcome collaborations for future development, validation, calibration or application of the risk tools. Contact Doug Manuel at [dmanuel@ohri.ca](mailto:dmanuel@ohri.ca)

## Algorithms

**Mortality Population Risk Tool (MPoRT).** A predictive algorithm for the calculation of 5-year risk of dying from all-causes. Developed and validated using the 2001 to 2008 Canadian Community Health Surveys (CCHS) with approximately 1 million person-years of follow-up and 9,900 deaths. Focus on health behaviours (smoking, diet, physical inactivity and alcohol consumption). The model is currently calibrated for Canada, 2013, with provisions to calibrate to other countries. …
[Link to the manuscript]


Reference: .....
