
ensemble_level_1 <- function(bt_data) {
  
  model_list <- c("svm", "dt", "lstm", "arima")
  split_no <- 1
  
  level_1_res <- lapply(bt_data, function(current_split) {
    print(paste0("Split ", split_no))
    split_no <<- split_no + 1
    cutoff <- nrow(current_split$train) * 0.75
    
    subsample <- list()
    subsample$train <- current_split$train[c(1:cutoff),]
    subsample$test <- current_split$train[-c(1:cutoff),]
    
    ### Get Predictions on subset of training data
    print("Get Predictions on subset of training data")
    train_res <- lapply(model_list, function(model_spec) {
      model_function <- switch(model_spec, 
                               "svm" = cv_svm, 
                               "dt" = cv_dt, 
                               "lstm" = cv_rnn, 
                               "arima" = ts_arima)
      
      predictions <- model_function(subsample)[["predictions"]]
    }) %>% bind_cols()
    
    train_res <- cbind(train_res, current_split$train[-c(1:cutoff), "Target"])
    names(train_res) <- c(model_list, "Target")
    
    ### Train Level 1 Model
    print("Train Ensemble")
    tr_control <- trainControl(method = "repeatedcv", 
                               number = 10,
                               repeats = 3,
                               returnResamp = "all",
                               savePredictions = "all")
    
    library(doParallel)
    
    cl <- makeCluster(3)
    registerDoParallel(cl)
    
    ensemble_fit <- train(as.factor(Target) ~ ., data = train_res,
                          method = svm,
                          tuneLength = 4,
                          trControl = tr_control, 
                          na.action = na.omit)
    
    stopCluster(cl)
    
    ### Test Ensemble
    print("Test Ensemble")
    test_res <- lapply(model_list, function(model_spec) {
      
      model_function <- switch(model_spec, 
                               "svm" = cv_svm, 
                               "dt" = cv_dt, 
                               "lstm" = cv_rnn, 
                               "arima" = ts_arima)

      predictions <- model_function(current_split)[["predictions"]]
    }) %>% bind_cols()
    
    test_res <- cbind(test_res, current_split$test[,"Target"])
    names(test_res) <- c(model_list, "Target")
    
    test_res[,"Ensemble"] <- predict(ensemble_fit, test_res %>% select(-Target))
    
    test_res
  })
  
  return (level_1_res)
}
