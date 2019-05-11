library(here)
source(here::here("setup.R"))

backtest_h <- readRDS(paste0(prepared_data_path, "/backtest_h.rds"))
backtest_hr <- readRDS(paste0(prepared_data_path, "/backtest_hr.rds"))

backtest_d <- readRDS(paste0(prepared_data_path, "/backtest_d.rds"))
backtest_dr <- readRDS(paste0(prepared_data_path, "/backtest_dr.rds"))