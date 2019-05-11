if(!require("here")) install.packages("here")

source(here::here("setup.R"))


## Run Preparation Scripts

source(here::here("1_Prepare/read_all_pairs.R"))

source(here::here("1_Prepare/check_correlation.R"))

source(here::here("1_Prepare/technical_indicators.R"))



## Add Target-Variable
prepared_data_hourly <- selected_pairs_hourly_indicators %>%
  mutate(Target = ifelse(.[,paste0(target_pair,"_Close")] < lead(.[,paste0(target_pair,"_Close")]), 1, 0)) %>%
  drop_na()

prepared_data_daily <- data.frame(selected_pairs_daily_indicators) %>%
  mutate(Target = ifelse(.[,paste0(target_pair,"_Close")] < lead(.[,paste0(target_pair,"_Close")]), 1, 0)) %>%
  drop_na()



## Reduce Dimensions
source(here::here("1_Prepare/dimensionality_reduction.R"))

prepared_data_hourly_reduced <- dimensionality_reduction(prepared_data_hourly)
prepared_data_daily_reduced <- dimensionality_reduction(prepared_data_daily)



## Run Backtesting Setup
source(here::here("1_Prepare/backtesting_setup.R"))

backtest_hourly <- generate_backtesting_data(prepared_data_hourly, prepared_data_hourly_reduced)
backtest_daily <- generate_backtesting_data(prepared_data_daily, prepared_data_daily_reduced)

## Persist
saveRDS(backtest_hourly[[1]], paste0(prepared_data_path, "/backtest_h.rds"))
saveRDS(backtest_hourly[[2]], paste0(prepared_data_path, "/backtest_hr.rds"))

saveRDS(backtest_daily[[1]], paste0(prepared_data_path, "/backtest_d.rds"))
saveRDS(backtest_daily[[2]], paste0(prepared_data_path, "/backtest_dr.rds"))