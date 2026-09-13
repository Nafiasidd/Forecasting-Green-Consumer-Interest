# Forecasting Green Consumer Interest: An ARIMA Analysis of Google Search Behavior

## Overview

This project examines patterns in public interest in electric cars using Google search behavior as a proxy for consumer interest. Time-series analysis was used to explore historical trends, identify an appropriate ARIMA model, and generate forecasts of future search interest.

The analysis focuses on the search interest term **"electric car"** and applies exploratory time-series techniques, model comparison, diagnostic checks, forecasting, and forecast evaluation.

---

## Research objective

The objective of this project was to:

- Examine historical trends in Google search interest for electric cars.
- Explore the time-series properties of the data.
- Identify suitable ARIMA models using AIC and BIC criteria.
- Assess model diagnostics and residual behavior.
- Generate forecasts of future search interest.
- Evaluate forecasting accuracy using error measures.

---

## Project structure

```text
green-interest-forecast/
│
├── data/
│   ├── raw/
│   │   └── Original data obtained from the online source
│   │
│   └── processed/
│       └── Electric car search interest data used for analysis
│
├── Eviews Outputs/
│   └── Output figures and screenshots generated during the EViews analysis
│
├── figures/
│   └── Selected figures and visualizations used in the analysis
│
├── output/
│   ├── aic_results.csv
│   ├── bic_results.csv
│   └── forecast_accuracy_results.csv
│
├── r/
│   └── 02_explore.R
│
├── report/
│   └── Green Interest Forecast Report.docx
│
└── green interest forecast.Rproj
```
Data

The project uses Google search interest data related to the search term "electric car."

The raw data was obtained directly from the online source and imported into the analysis workflow. The processed dataset contains the electric car search-interest data used for the time-series analysis.

Data folders
raw/: Contains the original data obtained from the source.
processed/: Contains the dataset prepared and used for the analysis.
Analysis

The analysis was conducted using time-series methods and included the following steps:

Exploratory analysis of the time series.
Examination of trends and time-series patterns.
Assessment of stationarity and differencing requirements.
Identification and comparison of ARIMA model specifications.
Model selection using information criteria, including AIC and BIC.
Residual and diagnostic checks.
Generation of forecasts.
Evaluation of forecasting performance using forecast error measures.
Model selection

Multiple ARIMA model specifications were examined and compared.

Model selection was supported using:

Akaike Information Criterion (AIC)
Bayesian Information Criterion (BIC)

The results of these comparisons are available in the output/ folder.

Outputs

The project includes several types of outputs:

EViews Outputs

The Eviews Outputs/ folder contains screenshots and figures generated during the EViews analysis, including:

Original time-series visualization
Autocorrelation and partial autocorrelation plots
Trend analysis
Correlogram output
AR model output
MA model output
ARMA model output
Residual diagnostic checks
Forecast visualizations
Forecast evaluation results
Figures

The figures/ folder contains selected visualizations used in the project.

Analysis results

The output/ folder contains:

aic_results.csv — Model comparison results using AIC.
bic_results.csv — Model comparison results using BIC.
forecast_accuracy_results.csv — Forecast accuracy and evaluation results.
Software

The project was developed using:

R for data exploration and analysis.
EViews for time-series modelling, diagnostics, and forecasting.

The project can be opened in RStudio using the included .Rproj file.

Reproducibility

The R code used for exploratory analysis is available in the r/ folder.

The project files, data, analysis outputs, figures, and report are organized into separate folders to make the workflow easier to review and reproduce.

Report

A complete written report describing the analysis, modelling process, findings, and forecasting results is available in:

report/Green Interest Forecast Report.docx

Author

Nafia Siddiqui
