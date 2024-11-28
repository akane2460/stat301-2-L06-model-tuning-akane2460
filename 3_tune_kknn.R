# L06 Model Tuning ----
# Define and fit tuned nearest neighbors

# random processes present

# load packages ----
library(tidyverse)
library(tidymodels)
library(here)
library(kknn)
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
set.seed(2201946)

# 1.  A $k$-nearest neighbors model with the `kknn` engine (tune `neighbors`);
kknn_spec <- 
  nearest_neighbor(neighbors = tune()) |> 
  set_engine("kknn") |> 
  set_mode("regression")

# define workflows ----
kknn_model <-
  workflow() |> 
  add_model(kknn_spec) |> 
  add_recipe(carseats_recipe)

# hyperparameter tuning values ----

# check ranges for hyperparameters
hardhat::extract_parameter_set_dials(kknn_model)

# change hyperparameter ranges
kknn_params <- parameters(kknn_model)

# build tuning grid
kknn_grid <- grid_regular(kknn_params, levels = 5)

# fit workflows/models ----
# set seed
set.seed(0927074)

kknn_tuned <- 
  kknn_model |> 
  tune_grid(
    carseats_fold, 
    grid = kknn_grid, 
    control = control_grid(save_workflow = TRUE)
  )

# write out results (fitted/trained workflows) ----
save(kknn_tuned, file = here("results/kknn_tuned.rda"))
