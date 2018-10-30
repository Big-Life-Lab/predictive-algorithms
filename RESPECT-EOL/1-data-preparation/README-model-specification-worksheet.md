# RESPECT - End-of-life (RESPECT-EOL) Model Specification Worksheets

There are three worksheets:

1. [EOL varliables](/1-data-preparation/MSW-RESPECT-Master-Variables.csv). All the variables used in the RESPECT-EOL algorithm. This files contains the instructions for common tasks for data cleaning snf variable transformation. Also included is infomation for algorith deployment.
2. [Master variables](1-data-preparation/MSW-RESPECT-Master-Variables.csv). All the variables for the RESPECT family of algorithms. Use this file for variable labels, categories, original data, categories, etc.
3. [Master categories](1-data-preparation/MSW-RESPECT-Master-Categories.csv). All the categories for all the variables in the RESPECT family of algorithms. Use this file for category names (for dummy variables, names, etc.

## `RESPECT-EOL-variables`

`validCat` Valid categories. For categorical variables only.

- _masterCats_ use the same categories from the master variable sheet, `variableCategoryNames`.
- _inf_ is ...

`invalidDevelopment` Data cleaning method if there is invalid (dirty) variable data in the development cohort. The most comomon cleaning methods are:
`missing` = assign to missing value.
`delete` = delete the entire respondent (row) from the data.

`missingDevelopment` Missing data method.

- _AregImpute_ = imputation method described by Harrell in HMisc package.
- _delete_ = delete the entire respondent (row) from the data.

`developmentMinMale` Minimum value in the development cohort. Delete the entire respondent (row) from the data if entry is less than minimum value.

- _number_ Assigned value. e.g. less than age 20 years.
- _XXXpercentile_ XX.X percentile from Table 2.

`developmentMinFemale` Same as for `developmentMinMale`.

`developmentMaxMale` See `developmentMinMale`.

`developmentMaxFemale` See `developmentMinMale`.

`outlierMethodDevelopment` Method when development data is outside max/min.

`missingDeployment` Recommended method when missing data when deploying the algorithm.
`mean` assign missing value to the variable.
`error` do not perform a calculation, return an error.

`outlierMethodDeployment` For continuous variables only. Method if entry is outside allowable range.

- _developmentMin_ Assign to `developmentMin` if value lower `developmentMin`.
- _developmentMax_ See above.
- _XXXPercentile_ xx.x percentile from Table 2.

## `Master Variables`

`variableStart` The variable names for all predictors that were used to derive the predictor.

`dataStart` The dataset used to derive the predictor.

`variableStartCategories` The number of categories (for categorical predictors) or variable type.
`Num`: integer

`variableName` The name of the predictive variable. Keep the same as `dataHoldingStart` if possible.

`labelLong` The variable label. Keep the same label as in `dataHolding` if possible.

`label` Short label - for manuscript and web tables where space is a premium.

`units` Predictie variable units, if applicable. e.g. Unit for age = `years`.

`type` Predictor variable grouping.

`variableType` Predictor variable type. - Categorical - Continuous

`variableCategories` The suffix used for categorical variable names. (0,4) indicated suffix from 1 to 4.

`algorithm` Algorithms that include the variable.

`displayOrder` Display order for visualizations (e.g. Table 1). Displayed from top to bottom in order of number (e.g. 1 is displayed at top of the table).

`labelOrder` Display order for visualizations. Order is the same as for `type_Order

## `Master categories`

variableName dummy labelLong label reference.
