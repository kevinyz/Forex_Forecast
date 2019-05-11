
cv_rnn <- function(train_test_data) {
  batch_size <- 400
  
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
  
  X_train <- train_partition[, -which(names(train_partition) %in% "Target")]
  X_test <- test_partition[, -which(names(test_partition) %in% "Target")]
  
  y_train <- train_partition$Target
  y_test <- test_partition$Target
  
  #### Scale & Center
  # mean <- apply(rbind(X_train, X_test), 2, mean)
  std <- apply(rbind(X_train, X_test), 2, sd)

  X_train <- scale(X_train, scale = std)
  X_test <- scale(X_test, scale = std)
  
  #### Prepare Model
  y_train <- to_categorical(y_train, num_classes = 2)
  # y_test <- to_categorical(y_test, num_classes = 2)
  
  # Initialize a sequential model
  model <- keras_model_sequential()
  
  # Add layers to model
  model %>%
    layer_lstm(units = dim(X_train)[2],
               input_shape = c(1, dim(X_train)[2]),
               dropout = 0.2,
               recurrent_dropout = 0.2,
               return_sequences = TRUE) %>%
    layer_lstm(units = 32,
               dropout = 0.2,
               recurrent_dropout = 0.2,
               return_sequences = TRUE) %>%
    layer_lstm(units = 32,
               dropout = 0.2,
               recurrent_dropout = 0.2,
               return_sequences = TRUE) %>%
    layer_lstm(units = 32,
               dropout = 0.2,
               recurrent_dropout = 0.2,
               return_sequences = TRUE) %>%
    layer_dense(units = 2, activation = 'sigmoid')
  
  model %>% compile(
    loss = 'binary_crossentropy',
    optimizer = 'sgd',
    metrics = 'accuracy')
  
  #### Batch-Training
  print("Run RNN-Model..")
  
  reshape_data <- function(X) {
    dim(X) <- c(dim(X)[1], 1, dim(X)[2])
    X
  }
  
  X_train <- reshape_data(X_train)
  y_train <- reshape_data(y_train)
  
  X_test <- reshape_data(X_test)
  # y_test <- reshape_X_3d(y_test)
  
  model %>% fit(x = X_train,
                y = y_train,
                batch_size = batch_size,
                epochs = 2000,
                verbose = 0, 
                validation_split = 0.2,
                shuffle = FALSE)
  
  #### Validate Model with Test-Partition
  y_pred_rnn <- model %>%
    predict(X_test)
  
  y_pred_rnn <- ifelse(y_pred_rnn[,1,2] > 0.5, 1, 0)
  
  conf_matrix <- confusionMatrix(as.factor(y_pred_rnn),
                                 as.factor(test_partition$Target),
                                 positive = "1",
                                 mode = "everything")
  
  
  
  return (list(model = model,
               conf_matrix = conf_matrix,
               predictions = as.numeric(as.character(y_pred_rnn))))
}
