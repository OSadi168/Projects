library(zoo)
library(lubridate)
library(mgcv)
library(rugarch)
library(ggplot2)
library(quantmod)
library(PerformanceAnalytics)
library(rugarch) 
library(FinTS)
library(forecast)
library(strucchange) 
library(TSA) 
library(tseries)
library(timeSeries)
library(xts)
library(pastecs)
library(tidyr)
library(dplyr)
library(splines)
library(tidyverse)
rm(list=ls()) 
library(FinTS)
library(rugarch)
library(tseries)
library(dynlm) 
library(vars)
library(nlWaldTest) 
library(broom) 
library(readxl)
# For Multilayer Perceptrons (MLP)
library(nnfor)
library(neuralnet)
library(MLmetrics)
library(Metrics) 
library(neuralnet)

# Load dataset
ExchangeUSD <- read.csv("C:/Users/ramsa/OneDrive/Desktop/Om/MachineLearning/ExchangeUSD.csv") 

# Cleaning Data - Remove NULL value records
ExchangeUSD_wo_NULL <- na.omit(ExchangeUSD)

# Use only the 3rd column from the file
Exchange_rate <- ExchangeUSD_wo_NULL$USD.EUR

# Split data - the first 400 of them have to be used as training data, 
# while the remaining ones as testing set.
training_data <- Exchange_rate[1:400]
testing_data <- Exchange_rate[401:500]

#	Each one of these I/O matrices needs to be normalised,
# Function to normalize data    
# The next step is to normalize the data so that all the features are on the same scale. As seen from the data exploration step, the values of all the attributes are more or less in a comparable range. This is necessary because without a common scale for each variable, then it will not be possible for NN to meaningfully classify the variable of interest.
normalize <- function(x) {
  (x - min(x)) / (max(x) - min(x))
}

# Normalize training and testing data
norm_training_data <- normalize(training_data)
norm_testing_data <- normalize(testing_data)

head (norm_training_data)
head (norm_testing_data)

# construct an input/output matrix (I/O) for the MLP training/testing
# Function to create input/output matrix for MLP training/testing
create_io_matrix <- function(data, input_size) {
  X <- matrix(nrow = length(data) - input_size, ncol = input_size)
  y <- vector(length = length(data) - input_size)
  for (i in 1:(length(data) - input_size)) {
    X[i, ] <- rev(data[i:(i + input_size - 1)])
    y[i] <- data[i + input_size]
  }
  return(list(X = X, y = y))
}


# Experiment with various input vectors and MLP models
results <- data.frame()
for (input_size in 1:4) {
  io_matrix <- create_io_matrix(norm_training_data, input_size)
  io_matrix_test <- create_io_matrix(norm_testing_data, input_size)
  
  
  for (hidden_layers in 1:2) {
    for (nodes in c(5,10)) {
      # Train MLP model
      mlp <- neuralnet(io_matrix$y ~ ., data = as.data.frame(io_matrix$X), hidden = rep(nodes, hidden_layers), linear.output = TRUE)
      
      # Make predictions based on the mlp and testing data
      predicted_values <- predict(mlp, as.data.frame(io_matrix_test$X))
      
      # Calculate evaluation metrics
      rmse <- sqrt(mean((predicted_values - io_matrix_test$y)^2))
      mae <- mae(io_matrix_test$y, predicted_values)
      mape <- mape(io_matrix_test$y, predicted_values)
      smape <- smape(io_matrix_test$y, predicted_values)
      
      # Store results
      results <- rbind(results, data.frame(Input_Vector_Size = input_size, Hidden_Layers = hidden_layers, Nodes = nodes, RMSE = rmse, MAE = mae, MAPE = mape, sMAPE = smape))
    }
  }
}

# Display results
print(results)

# Get the results in comparison table to further narrow down best result
comparison_table <- aggregate(cbind(RMSE, MAE, MAPE, sMAPE) ~ Input_Vector_Size + Hidden_Layers + Nodes, data = results, FUN = mean)
print(comparison_table)

# The mlp model with least error is the best model 
best_mlp_model <- comparison_table[which.min(comparison_table$RMSE), ]
print(best_mlp_model)
# Discuss the efficiency of the best MLP network
total_parameters <- function(hidden_layers, nodes, input_size) {
  total_params <- (input_size + 1) * nodes # Number of parameters in the input layer
  total_params <- total_params + (nodes + 1) * nodes * hidden_layers # Number of parameters in hidden layers
  total_params <- total_params + (nodes + 1) # Number of parameters in the output layer
  return(total_params)
}

total_params_best <- total_parameters(best_mlp_model$Hidden_Layers, best_mlp_model$Nodes, best_mlp_model$Input_Vector_Size)

cat("Total parameters of the best MLP network:", total_params_best, "\n")

# Provide graphical and statistical results for the best MLP network
io_matrix_best <- create_io_matrix(norm_training_data, best_mlp_model$Input_Vector_Size)
io_matrix_test_best <- create_io_matrix(norm_testing_data, best_mlp_model$Input_Vector_Size)

mlp_best <- neuralnet(io_matrix_best$y ~ ., data = as.data.frame(io_matrix_best$X), hidden = rep(best_mlp_model$Nodes, best_mlp_model$Hidden_Layers), linear.output = TRUE)
plot(mlp_best)
predicted_values_best <- predict(mlp_best, as.data.frame(io_matrix_test_best$X))

# Plot predictions vs. actual values
plot(norm_testing_data, type = 'l', col = 'blue', ylim = range(c(norm_testing_data, predicted_values_best)), xlab = 'Day', ylab = 'Exchange Rate')
lines(predicted_values_best, col = 'red')
legend('topleft', legend = c('Actual', 'Predicted'), col = c('blue', 'red'), lty = 1)
plot(mlp_best)

# Calculate evaluation metrics for the best MLP network
rmse_best <- sqrt(mean((predicted_values_best - io_matrix_test_best$y)^2))
mae_best <- mae(io_matrix_test_best$y, predicted_values_best)
mape_best <- mape(io_matrix_test_best$y, predicted_values_best)
smape_best <- smape(io_matrix_test_best$y, predicted_values_best)

cat("Evaluation metrics for the best MLP network:\n")
cat("RMSE:", rmse_best, "\n")
cat("MAE:", mae_best, "\n")
cat("MAPE:", mape_best, "\n")
cat("sMAPE:", smape_best, "\n")

strength_min <- min(training_data)
strength_max <- max(training_data)


unnormalize <- function(x, min, max) { 
  return( (max - min)*x + min )
}

strength_pred <- unnormalize(predicted_values_best, strength_min, strength_max)
head(strength_pred)  # this is NN’s output denormalized to original ranges
head(testing_data)

plot(testing_data, type = 'l', col = 'blue', ylim = range(c(testing_data, strength_pred)), xlab = 'Day', ylab = 'Exchange Rate')
lines(strength_pred, col = 'red')
legend('topleft', legend = c('Actual', 'Predicted'), col = c('blue', 'red'), lty = 1)


#compared to original data, normalized data give better comparison.
head(predicted_values_best)  # this is NN’s output denormalized to original ranges
head(norm_testing_data)
