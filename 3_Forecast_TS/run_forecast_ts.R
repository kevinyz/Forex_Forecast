source(here::here("load.R"))

### Load TS-Functions
source(here::here("3_Forecast_TS/ts_prophet.R"))
source(here::here("3_Forecast_TS/ts_arima.R"))


### Test Models

backtesting_data <- list(backtest_d, backtest_dr, backtest_h, backtest_hr)

ts_res <- lapply(backtesting_data, function(bt_data) {
  ## Prophet
  prophet_res <- lapply(bt_data, function(current_split) {
    ts_prophet(current_split)
  })
  
  ## ARIMA
  arima_res <- lapply(bt_data, function(current_split) {
    ts_arima(current_split)
  })
  
  return (list(prophet_res, arima_res))
})


### Persist Results
saveRDS(ts_res, paste0(models_path,"/ts_models.rds"))