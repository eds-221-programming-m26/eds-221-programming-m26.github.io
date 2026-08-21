library(tidyverse)
qs_path <- "data/QuebradaSonadora.csv"

qs_data <- read_csv("data/QuebradaSonadora_Fall1984.csv")
qs_data

qs_smoothed <- tibble(
  window_start = seq(
    qs_data$sample_date[1],
    qs_data$sample_date[nrow(qs_data)],
    by = "9 days"
  ),
  k_mgl = NA,
  mg_mgl = NA
)
for (i in 1:nrow(qs_smoothed)) {
  print(i)
  t1 <- qs_smoothed$window_start[i]
  t2 <- t1 + 9
  print("window:")
  print(c(t1, t2))
  in_window <- qs_data$sample_date >= t1 & qs_data$sample_date < t2
  print("k:")
  print(qs_data$k_mgl[in_window])
  k_window <- qs_data$k_mgl[in_window]
  qs_smoothed$k_mgl[i] <- mean(k_window, na.rm = TRUE)
  print(qs_smoothed$k_mgl[i])
  print("mg:")
  print(qs_data$mg_mgl[in_window])
  mg_window <- qs_data$mg_mgl[in_window]
  qs_smoothed$mg_mgl[i] <- mean(mg_window, na.rm = TRUE)
  print(qs_smoothed$mg_mgl[i])
  print("=========")
}
qs_smoothed
