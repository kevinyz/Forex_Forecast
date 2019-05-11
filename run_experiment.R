### Setup

if(!require("here")) install.packages("here")

source(here::here("setup.R"))

### Prepare Data

source(here::here("1_Prepare/run_prepare.R"))

### Run Ensemble

source(here::here("4_Forecast_Ensemble/run_forecast_ensemble.R"))