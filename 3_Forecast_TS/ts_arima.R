
ts_arima <- function(train_test_data, 
                     retrain = TRUE) {
  train_partition <- train_test_data$train
  test_partition <- train_test_data$test
  
  if ("Hour" %in% names(train_test_data$train)) {
    train_partition <- train_partition %>%
      mutate(Datetime = lubridate::ymd_hms(paste0(Date, "T", Hour, ":00:00")))
    
    test_partition <- test_partition %>%
      mutate(Datetime = lubridate::ymd_hms(paste0(Date, "T", Hour, ":00:00")))
  } else {
    train_partition <- train_partition %>%
      mutate(Datetime = lubridate::ymd_hms(paste0(Date, "T00:00:00")))
    
    test_partition <- test_partition %>%
      mutate(Datetime = lubridate::ymd_hms(paste0(Date, "T00:00:00")))
  }
  
  #### Prepare Train-Timeseries
  train_ts <- train_partition[,c("Datetime", paste0(target_pair,"_Close"))]
  names(train_ts) <- c("ds","y")
  
  #### Fit Model
  m <- auto.arima(train_ts$y,
                  stepwise = FALSE,
                  parallel = TRUE)
  
  #### Forecast
  print("Run ARIMA..")
  
  arima_predictions <- rep(0, nrow(test_partition))
  
  if (retrain) {
    for (i in 1:nrow(test_partition)) {
      # Predict
      forecast <- forecast(m, h=1)
      
      arima_predictions[i] <- forecast$mean

      # Refit Model
      print(paste0("Retrain run ", i))
      test_ts <- test_partition[1:i, c("Datetime", paste0(target_pair,"_Close"))]
      names(test_ts) <- c("ds","y")
      
      m <- auto.arima(c(train_ts$y, test_ts$y),
                      stepwise = FALSE,
                      parallel = TRUE)
    }
  } else {
    forecast <- forecast(m, 
                         h=nrow(test_partition))
    arima_predictions <- forecast$mean
  }
  
  #### Validate Model with Test-Partition
  forecast_res <- data.frame(Target = c(train_partition[nrow(train_partition),"Target"], 
                                        test_partition[,"Target"]))
  forecast_res$Target_Value <- c(train_partition[nrow(train_partition),paste0(target_pair,"_Close")], 
                                 test_partition[,paste0(target_pair,"_Close")])
  forecast_res$yhat <- c(0, arima_predictions)
  
  forecast_res <- forecast_res %>%
    mutate(Prediction = ifelse(lag(Target_Value) < yhat, 1, 0))
  
  forecast_res <- forecast_res[2:nrow(forecast_res),]
  
  conf_matrix <- confusionMatrix(as.factor(forecast_res$Prediction),
                                 as.factor(forecast_res$Target), 
                                 positive = "1",
                                 mode = "everything")
  
  return (list(model = m,
               conf_matrix = conf_matrix,
               predictions = forecast_res$Prediction))
}
