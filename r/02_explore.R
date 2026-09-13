# ============================================================
# PROJECT: Forecasting Green Consumer Interest
# SUBTITLE: An ARIMA Analysis of Google Search Behavior
# ============================================================


# ============================================================
# 1. PACKAGES
# ============================================================

library(readr)
library(ggplot2)
library(dplyr)
library(urca)
library(feasts)
library(tsibble)


# ============================================================
# 2. DATA IMPORT
# ============================================================

electric_car <- read_csv("data/raw/electric_car_raw.csv")

head(electric_car)
tail(electric_car)
summary(electric_car)


# ============================================================
# 3. EXPLORATORY TIME-SERIES ANALYSIS
# ============================================================

original_plot <- ggplot(electric_car, aes(x = date, y = hits)) + geom_line() + labs( title = "US Google Search Interest in 'Electric Car'", x = "Date", y = "Google Trends Interest")

# Display the graph
original_plot 

# Save the graph 
ggsave("figures/01_original_time_series.png", plot = original_plot, width = 10, height = 6)


# ============================================================
# 4. STATIONARITY TESTING
# ============================================================

# Augmented Dickey-Fuller test with drift

adf_level <- ur.df( electric_car$hits, type = "drift", selectlags = "AIC")
summary(adf_level)


# Augmented Dickey-Fuller test with trend

adf_trend <- ur.df(electric_car$hits, type = "trend", selectlags = "AIC")
summary(adf_trend)


# ============================================================
# 5. TIME-SERIES PREPARATION
# ============================================================

# Convert date variable to monthly time-series format

electric_car_ts <- electric_car %>% mutate(date = yearmonth(date)) %>% as_tsibble(index = date)
summary(electric_car_ts)

# SAVE PROCESSED DATA

write_csv(as.data.frame(electric_car_ts),"data/processed/electric_car_processed.csv")

# ============================================================
# 6. MODEL IDENTIFICATION: ACF AND PACF
# ============================================================

# Autocorrelation Function

acf_plot <- electric_car_ts %>% ACF(hits) %>% autoplot()

# Display the graph
acf_plot

# Save the graph
ggsave("figures/02_acf_plot.png",plot = acf_plot,width = 10,height = 6)

# Partial Autocorrelation Function

pacf_plot <- electric_car_ts %>% PACF(hits) %>% autoplot()

# Display the graph
pacf_plot

# Save the graph
ggsave("figures/03_pacf_plot.png",plot = pacf_plot,width = 10,height = 6)

# ============================================================
# 7. CANDIDATE MODEL ESTIMATION
# ============================================================

# AR(1): ARIMA(1,0,0)

model_ar1 <- arima(electric_car$hits, order = c(1, 0, 0))

model_ar1


# MA(1): ARIMA(0,0,1)

model_ma1 <- arima(electric_car$hits, order = c(0, 0, 1))
model_ma1


# ARMA(1,1): ARIMA(1,0,1)

model_arma11 <- arima( electric_car$hits, order = c(1, 0, 1))

model_arma11


# ============================================================
# 8. MODEL SELECTION
# ============================================================

# Compare models using Akaike Information Criterion

aic_results <- AIC( model_ar1, model_ma1, model_arma11)
aic_results
write.csv(aic_results,"output/aic_results.csv")

# Compare models using Bayesian Information Criterion

bic_results <- BIC( model_ar1,model_ma1, model_arma11)
bic_results

write.csv(bic_results,"output/bic_results.csv")

# ============================================================
# 9. RESIDUAL DIAGNOSTICS
# ============================================================

residuals_arma11 <- residuals(model_arma11)

Box.test( residuals_arma11, lag = 20, type = "Ljung-Box")


# ============================================================
# 10. TRAIN-TEST SPLIT
# ============================================================

# Use all observations except the final 12 months for training

train <- electric_car[1:(nrow(electric_car) - 12),]


# Use the final 12 months as the test set

test <- electric_car[(nrow(electric_car) - 11):nrow(electric_car),]

train
test


# ============================================================
# 11. ARIMA MODEL ESTIMATION ON TRAINING DATA
# ============================================================

model_train <- arima(train$hits,order = c(1, 0, 1))

model_train


# ============================================================
# 12. OUT-OF-SAMPLE FORECASTING
# ============================================================

forecast_train <- predict(model_train,n.ahead = 12)

forecast_train


# ============================================================
# 13. ACTUAL VS FORECAST COMPARISON
# ============================================================

comparison <- data.frame(date = test$date,actual = test$hits,forecast = as.numeric(forecast_train$pred))

comparison


# ============================================================
# 14. ARIMA FORECAST ACCURACY
# ============================================================

# Mean Absolute Error

mae_arima <- mean(abs(comparison$actual - comparison$forecast))

mae_arima


# Root Mean Squared Error

rmse_arima <- sqrt(mean((comparison$actual - comparison$forecast)^2))

rmse_arima


# ============================================================
# 15. NAIVE FORECAST BENCHMARK
# ============================================================

# Obtain the final observed value in the training data

last_training_value <- tail(train$hits, 1)

last_training_value


# Use the final training value as the forecast
# for each of the 12 test observations

naive_forecast <- rep(last_training_value,12)


# Naive forecast MAE

mae_naive <- mean(abs(test$hits - naive_forecast))

mae_naive


# Naive forecast RMSE

rmse_naive <- sqrt(mean((test$hits - naive_forecast)^2))

rmse_naive


# ============================================================
# 16. FORECAST ACCURACY COMPARISON
# ============================================================

forecast_results <- data.frame(Model = c("ARIMA(1,0,1)", "Naive"), MAE = c(mae_arima, mae_naive), RMSE = c(rmse_arima, rmse_naive))

forecast_results

# Save forecast accuracy results
write.csv(forecast_results,"output/forecast_accuracy_results.csv",row.names = FALSE)


# ============================================================
# 17. ACTUAL VS ARIMA FORECAST GRAPH
# ============================================================

plot(comparison$date,comparison$actual,type = "o",xlab = "Date",ylab = "Google Trends Interest",main = "Actual vs ARIMA Forecast")
lines(comparison$date,comparison$forecast,lty = 2)
legend("topleft",legend = c("Actual", "ARIMA Forecast"),lty = c(1, 2))

# Save the graph as a PNG file
png("figures/04_actual_vs_arima_forecast.png",width = 1000,height = 600)
# Close the PNG device

dev.off()