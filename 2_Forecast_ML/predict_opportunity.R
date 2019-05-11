### predict_opportunity("crm/0060O00000m6PQvQAM")

predict_opportunity <- function(selected_ftid, feature_data = op_data_2019) {
  #### Prepare Dataset
  ftid_data <- feature_data[,c(features,"FTID","IsWon","StageId","DayDateString")] %>%
    filter(FTID == selected_ftid)
    
  ftid_features <- ftid_data[,features]
  ftid_features[is.na(ftid_features)] <- -1
  ftid_features <- as.data.frame(as.matrix(ftid_features))
  
  #### Factorize Features
  # ftid_features <- factorize_variables(ftid_features, sel_features)
  
  #### Predict
  print("Predicting opportunities..")
  success_prob <- rep(0, nrow(ftid_features))
  relevant_features <- list()
  
  for (row in 1:nrow(ftid_features)) {
    current_elem <- ftid_features[row, ]
    
    model_num <- switch(as.character(ftid_data[row, "StageId"]), 
                        "10" = 1, 
                        "20" = 2, 
                        "30" = 3, 
                        "40" = 4, 
                        "50" = 5)
    
    predictor_model <- lpsvm_all_stages_full[[model_num]]
    
    success_prob[row] <- predict(predictor_model, current_elem, type = "prob")[2]
    # success_prob[row] <- as.character(predict(predictor_model, current_elem))
    # relevant_features[[row]] <- important_features[[model_num]]
  }
  
  ftid_data$SuccessProb <- success_prob
  
  #### Model Interpretation
  # print("Interpreting model..")
  # ftid_data$FeatureImportance <- relevant_features
  
  return(ftid_data)
}