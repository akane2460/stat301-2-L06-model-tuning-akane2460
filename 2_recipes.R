# L06 Model Tuning ----
# Setup pre-processing/recipes

# load packages ----
library(tidyverse)
library(tidymodels)
library(here)

# handle common conflicts
tidymodels_prefer()

# load training data----
load(here("data/carseats_train.rda"))

# tree-based ----
carseats_recipe <- recipe(sales ~ ., data = carseats_train) |> 
  step_dummy(all_nominal_predictors(), one_hot = TRUE) |> 
  step_zv(all_predictors()) |> 
  step_normalize(all_numeric_predictors())

carseats_recipe |>
  prep() |>
  bake(new_data = NULL) |>
  glimpse()

# write out recipes----
save(carseats_recipe, file = here("recipes/carseats_recipe.rda"))
