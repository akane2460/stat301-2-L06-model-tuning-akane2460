# L06 Model Tuning ----
# Define and fit final model: boosted

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

# registerDoSEQ() # RESET TO SEQUENTIAL PROCESSING HERE

# load training data----
load(here("data/carseats_train.rda"))

# load pre-processing/feature engineering/recipe
load(here("recipes/carseats_recipe.rda"))
load(here("data/carseats_fold.rda"))

# load boosted_fit
load(here("results/boosted_tuned.rda"))

# finalizing the model----
# finalize workflow 
final_wflow <- boosted_tuned |> 
  extract_workflow(boosted_tuned) |>  
  finalize_workflow(select_best(boosted_tuned, metric = "rmse"))

# train final model ----
# set seed
set.seed(0298375)
final_fit <- fit(final_wflow, carseats_train)

# write out results (fitted/trained workflows) ----
save(final_fit, file = here("results/final_fit.rda"))

