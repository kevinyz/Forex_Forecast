
### Create Splits for Backtesting

generate_backtesting_data <- function(data, data_reduced) {
  ## Full Dataset
  backtesting_data <- lapply(train_test_splits, function(current_split){
    train <- data[(lubridate::year(data$Date) >= current_split[[1]] & 
                              lubridate::year(data$Date) < current_split[[2]]),]
    test <- data[(lubridate::year(data$Date) == current_split[[2]]),]
    
    return(list(train = train,
                test = test))
  })
  
  ## Dataset with reduced Dimensions
  backtesting_data_reduced <- lapply(train_test_splits, function(current_split){
    train <- data_reduced[(lubridate::year(data_reduced$Date) >= current_split[[1]] & 
                                      lubridate::year(data_reduced$Date) < current_split[[2]]),]
    test <- data_reduced[(lubridate::year(data_reduced$Date) == current_split[[2]]),]
    
    return(list(train = train,
                test = test))
  })
  
  return(list(backtesting_data, backtesting_data_reduced))
}