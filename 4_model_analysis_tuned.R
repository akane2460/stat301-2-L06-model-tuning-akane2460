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

# load models
load(here("results/rf_tuned.rda"))
load(here("results/kknn_tuned.rda"))
load(here("results/boosted_tuned.rda"))

# rmse autoplots----
# rf_tuned
rf_tuned_rmse_plot <- autoplot(rf_tuned, metric = "rmse") +
  labs(title = "RMSE for Random Forest Tuned Model")

ggsave(here("results/rf_tuned_rmse_plot.png"), rf_tuned_rmse_plot)

# kknn_tuned
kknn_tuned_rmse_plot <- autoplot(kknn_tuned, metric = "rmse") +
  labs(title = "RMSE for KKNN Tuned Model")

ggsave(here("results/kknn_tuned_rmse_plot.png"), kknn_tuned_rmse_plot)

# boosted_tuned
boosted_tuned_rmse_plot <- autoplot(boosted_tuned, metric = "rmse") +
  labs(title = "RMSE for Boosted Tree Tuned Model")

ggsave(here("results/boosted_tuned_rmse_plot.png"), boosted_tuned_rmse_plot)

# select best----

select_best(rf_tuned, metric = "rmse")
select_best(boosted_tuned, metric = "rmse")
select_best(kknn_tuned, metric = "rmse")

model_set <- as_workflow_set(
  boosted = boosted_tuned, 
  rf = rf_tuned,
  kknn = kknn_tuned)

rmse_metrics <- model_set |> 
  collect_metrics() |> 
  filter(.metric == "rmse") 

min_rmse <- rmse_metrics |> 
  group_by(wflow_id) |> 
  slice_min(mean)

# save these results
save(min_rmse, file = here("results/min_rmse.rda"))

