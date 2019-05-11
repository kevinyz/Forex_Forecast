####### Hourly

### Get Close-Values of all Pairs
currency_close_vals <- all_pairs_hourly[, grep("Close", names(all_pairs_hourly))]

### Check Correlation between all Pairs vs Target Pair
target_cp <- as.numeric(currency_close_vals[, paste0(target_pair,"_Close")])

print("Checking Correlations..")

corr_vals <- sapply(currency_pairs, function(cp) {
  check_cp <- as.numeric(currency_close_vals[, paste0(cp, "_Close")])
  cor(target_cp, check_cp, method = "pearson")
})

correlating_pairs <- currency_pairs[corr_vals > correlation_threshold]

### Reduce Dataframe to Currency Pairs with correlation > correlation threshold
correlating_cols <- lapply(correlating_pairs, function(cp) {
  grep(cp,names(all_pairs_hourly),value = TRUE)
  }) %>% unlist()

selected_pairs_hourly <- all_pairs_hourly[,c("Date","Hour",correlating_cols)]





####### Daily

### Get Close-Values of all Pairs
currency_close_vals <- all_pairs_daily[, grep("Close", names(all_pairs_daily))]

### Check Correlation between all Pairs vs Target Pair
target_cp <- currency_close_vals %>% pluck(paste0(target_pair,"_Close"))

print("Checking Correlations..")

corr_vals <- sapply(currency_pairs, function(cp) {
  check_cp <- currency_close_vals %>% pluck(paste0(cp,"_Close"))
  cor(target_cp, check_cp, method = "pearson")
})

correlating_pairs <- currency_pairs[corr_vals > correlation_threshold]

### Reduce Dataframe to Currency Pairs with correlation > correlation threshold
correlating_cols <- lapply(correlating_pairs, function(cp) {
  grep(cp,names(all_pairs_daily),value = TRUE)
}) %>% unlist()

selected_pairs_daily <- all_pairs_daily[,c("Date",correlating_cols)]
