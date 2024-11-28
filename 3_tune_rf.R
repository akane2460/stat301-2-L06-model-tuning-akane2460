# L06 Model Tuning ----
# Define and fit tuned random forest

# random processes present

# load packages ----
library(tidyverse)
library(tidymodels)
library(here)
library(hardhat)
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
load(here("data/carseats_fold.rda"))

# load pre-processing/feature engineering/recipe
load(here("recipes/carseats_recipe.rda"))

# model specifications ----
# set seed
set.seed(2109739)

rf_spec <- 
  rand_forest(trees = 1000, min_n = tune(), mtry = tune()) |> 
  set_engine("ranger") |> 
  set_mode("regression")

# define workflows ----
rf_model <-
  workflow() |> 
  add_model(rf_spec) |> 
  add_recipe(carseats_recipe)

# hyperparameter tuning values ----

# check ranges for hyperparameters
hardhat::extract_parameter_set_dials(rf_model)

# change hyperparameter ranges
rf_params <- parameters(rf_model) %>% 
  update(mtry = mtry(c(1, 14))) 

# build tuning grid
rf_grid <- grid_regular(rf_params, levels = 5)

# fit workflows/models ----
# set seed
set.seed(0127307)
rf_tuned <- 
  rf_model |> 
  tune_grid(
    carseats_fold, 
    grid = rf_grid, 
    control = control_grid(save_workflow = TRUE)
  )

# write out results (fitted/trained workflows) ----
save(rf_tuned, file = here("results/rf_tuned.rda"))
