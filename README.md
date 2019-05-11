# Forex_Forecast

Machine Learning project to forecast the movement of the EUR/USD currency pair, using Decision Trees, Support Vector Machines, ARIMA, a Long Short-Term Memory Network and an Ensemble-Model.

## Getting Started

These instructions will get you a copy of the project up and running on your local machine for development and testing purposes. See deployment for notes on how to deploy the project on a live system.

### Prerequisites

What things you need to install the software and how to install them

* Anaconda Python Distribution (https://www.anaconda.com/distribution/)
* R (https://cran.r-project.org/)
* R-Studio (https://www.rstudio.com/)

Installing R-Studio is not necessarliy required, but recommended.

### Installation

```
git clone https://github.com/kevinyz/Forex_Forecast.git
```

### Data

The data used in this project is not included in the repository. Historic forex data was acquired from https://histdata.com

It can also be found on this OSF-Repository: https://osf.io/w6bj8/

To re-create the experiment, it is recommended to download the entire repository (including the data) from OSF.

Size: 1.04GB

## Deployment

### Run Experiment

The full experiment can be executed by running the "run_experiment.R" script via R-Studio or using the Rscript command. 

```
Rscript run_experiment.R
``` 

### Results

To get the model accuracies, it is necessary to run the 5_Results/Model_Accuracy.Rmd script. It will generate a pdf file containing the accuracies for each model.

## Built With

* Anaconda Python Distribution (https://www.anaconda.com/distribution/)
* R (https://cran.r-project.org/)
* R-Studio (https://www.rstudio.com/)

## Authors

* **Kevin Yildiz** - [kevinyz](https://github.com/kevinyz)
