# L06 Model Tuning ----
# Analysis of tuned and trained models (comparisons)
# Select final model
# Fit & analyze final model

# load packages ----
library(tidyverse)
library(tidymodels)
library(here)
library(yardstick)

# handle common conflicts
tidymodels_prefer()

# load testing data
load(here("data/carseats_test.rda"))

# load trained models
load(here("results/final_fit.rda"))

# set metrics
ames_metrics <- metric_set(rmse, rsq, mae)

# predicted vs. test value tibble
predicted_final_fit <- bind_cols(carseats_test, predict(final_fit, carseats_test)) |> 
  select(sales, .pred)

# ames metrics applied
final_fit_metrics <- ames_metrics(predicted_final_fit, truth = sales, estimate = .pred)

# save out metrics 
save(final_fit_metrics, file = here("results/final_fit_metrics.rda"))

# plot predicted vs actual---
predicted_vs_sales_plot <- predicted_final_fit |> 
  ggplot(aes(x = sales, y = .pred))+ 
  geom_abline() + # diagonal line, indicating a completely accurate prediction
  geom_point(alpha = 0.5) + 
  labs(y = "Predicted Sales (thousands of USD)", x = "Sales (thousands of USD)", title = "Predicted vs. Sales In Thousands of USD") +
  coord_obs_pred()

ggsave(here("results/predicted_vs_sales_plot.png"), predicted_vs_sales_plot)
