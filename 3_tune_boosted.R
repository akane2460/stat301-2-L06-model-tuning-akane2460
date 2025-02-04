# L06 Model Tuning ----
# Define and fit tuned boosted

# random processes present

# load packages ----
library(tidyverse)
library(tidymodels)
library(here)
library(xgboost)
library(parallel)
library(doMC)

# handle common conflicts
tidymodels_prefer()

# parallel processing 
num_cores <- parallel::detectCores(logical = TRUE)

registerDoMC(cores = num_cores)

# registerDoSEQ() RESET TO SEQUENTIAL PROCESSING HERE

# load training data
load(here("data/carseats_train.rda"))

# load pre-processing/feature engineering/recipe
load(here("recipes/carseats_recipe.rda"))
load(here("data/carseats_fold.rda"))

# tuning model initially----

# model specifications ----

# 3.  A boosted tree model with the `xgboost` engine (tune `mtry`, `min_n`, and `learn_rate`).
boosted_spec <- 
  boost_tree(mtry = tune(), min_n = tune(), learn_rate = tune()) |> 
  set_engine("xgboost") |> 
  set_mode("regression")

# define workflows ----
boosted_model <-
  workflow() |> 
  add_model(boosted_spec) |> 
  add_recipe(carseats_recipe)

# hyperparameter tuning values ----

# check ranges for hyperparameters
hardhat::extract_parameter_set_dials(boosted_model)

# change hyperparameter ranges
boosted_params <- parameters(boosted_model) %>% 
  update(mtry = mtry(c(1, 14)), learn_rate = learn_rate(c(-5, -0.2)))

# build tuning grid
boosted_grid <- grid_regular(boosted_params, levels = 5)

# tuning model  ----
# set seed
set.seed(0927074)

boosted_tuned <- 
  boosted_model |> 
  tune_grid(
    carseats_fold, 
    grid = boosted_grid, 
    control = control_grid(save_workflow = TRUE)
  )

# write out results (tuned model) ----
save(boosted_tuned, file = here("results/boosted_tuned.rda"))

