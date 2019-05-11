source(here::here("load.R"))

### Load CV-Functions
source(here::here("2_Forecast_ML/cv_dt.R"))
source(here::here("2_Forecast_ML/cv_rnn.R"))
source(here::here("2_Forecast_ML/cv_svm.R"))


### Test Models

backtesting_data <- list(backtest_d, backtest_dr, backtest_h, backtest_hr)

ml_res <- lapply(backtesting_data, function(bt_data) {
  
  ## DT
  dt_res <- lapply(bt_data, function(current_split) {
    cv_dt(current_split,
          run_parallel = TRUE,
          no_cores = 3)
  })
  
  ## SVM
  svm_res <- lapply(bt_data, function(current_split) {
    cv_svm(current_split,
           run_parallel = TRUE,
           no_cores = 3)
  })
  
  ## RNN
  rnn_res <- lapply(bt_data, function(current_split) {
    cv_rnn(current_split)
  })
  
  return (list(dt_res, svm_res, rnn_res))
})

### Persist Results
saveRDS(ml_res, paste0(models_path,"/ml_models.rds"))