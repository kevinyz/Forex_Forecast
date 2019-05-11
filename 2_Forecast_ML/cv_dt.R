cv_dt <- function(train_test_data, 
                  run_parallel = TRUE, 
                  no_cores = 3) {
  
  if ("Hour" %in% names(train_test_data$train)) {
    train_partition <- train_test_data$train %>%
      select(-Date,-Hour)
    
    test_partition <- train_test_data$test %>%
      select(-Date,-Hour)
  } else {
    train_partition <- train_test_data$train %>%
      select(-Date)
    
    test_partition <- train_test_data$test %>%
      select(-Date)
  }
  
  
  #### Training Method
  tc_window <- train_partition %>% nrow() / 10
  tc_horizon <- tc_window / 4
  
  tr_control <- trainControl(method = "timeslice", 
                             initialWindow = tc_window, 
                             horizon = tc_horizon,
                             skip = tc_window + tc_horizon - 1)
  
  #### Cross-Validation
  print("Run DT-Model..")
  
  if (run_parallel) {
    library(doParallel)
    
    cl <- makeCluster(no_cores)
    registerDoParallel(cl)
  }
  
  dt_fit <- train(as.factor(Target) ~ ., 
                  data = train_partition,
                  method = "rpart",
                  preProcess = c("scale"),
                  parms = list(split = "information"),
                  trControl = tr_control)
  
  if (run_parallel) {
    stopCluster(cl)
  }
  
  #### Validate Model with Test-Partition
  y_pred_dt <- predict(dt_fit, test_partition)
  
  conf_matrix <- confusionMatrix(as.factor(y_pred_dt),
                                 as.factor(test_partition$Target), 
                                 positive = "1",
                                 mode = "everything")
  
  
  
  return (list(model = dt_fit,
               conf_matrix = conf_matrix,
               predictions = as.numeric(as.character(y_pred_dt))))
}
