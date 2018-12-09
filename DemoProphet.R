library(prophet)
library(ggplot2)
library(tidyverse)
library(lubridate)

#demo data = passengers catching airplanes 1949-1960
myDates = seq(from = dmy("01/01/1949"),to = dmy("01/12/1960"), by = 'month')
passenger_count = AirPassengers

df_for_prophet <- data.frame(ds = myDates, # e.g. one date every month
                             y = log10(passenger_count) # e.g. number of passengers every month, or here, a function of that e.g. log()
) %>%
  na.omit()

m <- prophet(df_for_prophet, 
             daily.seasonality = F,
             weekly.seasonality = F,
             yearly.seasonality = 3)#, #can use TRUE, FALSE, or a number of fourier components
             #mcmc.samples = 1000) # turn on mcmc sampling to generate uncertainties a little better, still not proper bayesian

empty_future_df <- make_future_dataframe(m, periods = 730) #make empty future for 2 years

forecast_future_df <- predict(m, empty_future_df) #predict 2 years

prophet_plot_components(m, forecast_future_df) #plot seasonality

#plot data with prediction
plot(m, forecast_future_df)+
  labs(title = "Passengers on Airplanes",
       x = "Date",
       y = "Log10(Number of passengers)")


