rm(list = ls())

if(!require("here")) install.packages("here")
library(here)

### Load Data Paths
source(here::here("setup_data_path.R"))


### Load Libraries
if(!require("keras")) {
  install.packages("Rcpp")
  install.packages("devtools")
  devtools::install_github("rstudio/reticulate")
  devtools::install_github("rstudio/tensorflow")
  devtools::install_github("rstudio/keras")
  
  keras::install_keras()
}

if(!require("pacman")) install.packages("pacman")
pacman::p_load(
  tidyverse,
  glue,
  forcats,
  timetk,
  tidyquant,
  tibbletime,
  cowplot,
  recipes,
  keras,
  tfruns,
  readr,
  tidyr, 
  lubridate, 
  dplyr, 
  broom, 
  tidyquant, 
  ggplot2, 
  purrr, 
  stringr, 
  knitr,
  caret,
  kernlab,
  doParallel,
  rpart.plot,
  TTR,
  rsample,
  prophet,
  forecast,
  kableExtra,
  DiagrammeR
)

### Load Parameters
source(here::here("setup_parameters.R"))
