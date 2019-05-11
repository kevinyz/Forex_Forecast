
dimensionality_reduction <- function(data) {
  ## Autoencoder
  library(keras)

  ## Prepare Data
  minmax <- function(x) (2*x - max(x) - min(x))/(max(x) - min(x))
  
  if ("Hour" %in% names(data)) {
    data <- data %>%
      select(-Hour)
  }
  
  X_train <- apply(data %>% select(-Date,-Target), 2, minmax)
  
  ## Autoencoder - Model
  model <- keras_model_sequential()
  
  model %>%
    layer_dense(units = 500, activation = "tanh", input_shape = ncol(X_train)) %>%
    layer_dense(units = 200, activation = "tanh", name = "bottleneck") %>%
    layer_dense(units = 500, activation = "tanh") %>%
    layer_dense(units = ncol(X_train))
  
  summary(model)
  
  model %>% compile(
    loss = "mean_squared_error", 
    optimizer = "adam"
  )
  
  ## Fit
  model %>% fit(
    x = X_train, 
    y = X_train, 
    epochs = 100,
    verbose = 1
  )
  
  ## Evaluation
  mse_score <- evaluate(model, X_train, X_train)
  mse_score
  
  ## Extract Reduced Dimension Dataframe
  intermediate_layer_model <- keras_model(inputs = model$input, outputs = get_layer(model, "bottleneck")$output)
  reduced_dimensions <- predict(intermediate_layer_model, X_train)
  
  colnames(reduced_dimensions) <- paste0("F",1:ncol(reduced_dimensions))
  
  data_reduced <- cbind(reduced_dimensions, data[,c("Date","Target", paste0(target_pair,"_Close"))])
  
  if ("Hour" %in% names(data)) {
    data_reduced <- cbind(data_reduced, data %>% select(Hour))
  }
  
  return(data_reduced)
}
