
source(here::here("load.R"))

### Load CV-Functions
source(here::here("2_Forecast_ML/cv_dt.R"))
source(here::here("2_Forecast_ML/cv_rnn.R"))
source(here::here("2_Forecast_ML/cv_svm.R"))

### Load TS-Functions
source(here::here("3_Forecast_TS/ts_prophet.R"))
source(here::here("3_Forecast_TS/ts_arima.R"))

### Load Ensemble Function
source(here::here("4_Forecast_Ensemble/ensemble_level_1.R"))

### Run Ensemble
backtesting_data <- list(backtest_d, backtest_dr, backtest_h, backtest_hr)
file_no <- 1

ensemble_res <- lapply(backtesting_data, function(bt_data) {
  print(paste0("Ensemble-Train/Test-Run File ", file_no))
  file_no <<- file_no + 1
  ensemble_level_1(bt_data)
})

names(ensemble_res) <- c("backtest_daily", "backtest_daily_reduced", "backtest_hourly", "backtest_hourly_reduced")


### Persist Results
saveRDS(ensemble_res, paste0(results_path,"/all_results.rds"))