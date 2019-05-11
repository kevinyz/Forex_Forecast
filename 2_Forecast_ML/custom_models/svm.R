svm <- list(type = "Classification",
              library = "kernlab",
              loop = NULL) 
 
### Parameters
svm$parameters <- data.frame(parameter = c("C", "sigma"),
                               class = rep("numeric", 2),
                               label = c("Cost", "Sigma"))


### Grid
svm$grid <- function(x, y, len = NULL, search = "grid") {
  library(kernlab)
  ## This produces low, middle and high values for sigma 
  ## (i.e. a vector with 3 elements). 
  sigmas <- kernlab::sigest(as.matrix(x), na.action = na.omit, scaled = TRUE)  
  
  ## To use grid search:
  out <- expand.grid(sigma = mean(as.vector(sigmas[-2])),
                     C = 2 ^((1:len) - 3))
                     # C = 2)
  out
}


### Fit
svm$fit <- function(x, y, wts, param, lev, last, weights, classProbs, ...) { 
  kernlab::ksvm(
    x = as.matrix(x), y = y,
    kernel = "rbfdot",
    kpar = list(sigma = param$sigma),
    C = param$C,
    prob.model = classProbs,
    ...
  )
}


### Predict
svm$predict <- function(modelFit, newdata, preProc = NULL, submodels = NULL)
  kernlab::predict(modelFit, newdata)


### Prob
svm$prob <- function(modelFit, newdata, preProc = NULL, submodels = NULL)
  kernlab::predict(modelFit, newdata, type = "probabilities")


### Sort
svm$sort <- function(x) x[order(x$C),]


### Levels
svm$levels <- function(x) kernlab::lev(x)