# L06 Model Tuning ----
# Initial data checks, data splitting, & data folding

# random processes present

# load packages ----
library(tidyverse)
library(tidymodels)
library(here)
library(patchwork)

# handle common conflicts
tidymodels_prefer()

# Load the data from `data/carseats.csv` into *R* and familiarize yourself with the variables it contains using the codebook (`data/carseats_codebook.txt`). When loading the data make sure to type variables as factors where appropriate --- in this case we will type all factor variables as nominal (ignore ordering). 
# That is, don't type any as an ordered factor.

# load data
carseats <- read.csv(here("data/carseats.csv")) |> 
  janitor::clean_names() |> 
  mutate(shelve_loc = factor(shelve_loc, labels = c("Bad", "Medium", "Good")),
         us = factor(us),
         urban = factor(urban))

# data quality check
carseats |> 
  skimr::skim_without_charts()
  # dimensions 400 rows by 11 columns
  # no missingness issues

# target variable investigation
carseats |> 
  skimr::skim_without_charts(sales)

p1 <- carseats |> 
  ggplot(aes(sales)) + 
  geom_density() +
  theme_minimal() +
  theme(
    axis.text.y = element_blank(),
    axis.title.y = element_blank(),
    axis.ticks.y = element_blank()
  ) 
# unimodal

p2 <- carseats |> 
  ggplot(aes(sales)) + 
  geom_boxplot() +
  theme_void()

sales_distribution <- p2/p1 + plot_layout(heights = unit(c(1, 5), c("cm", "cm"))) 

ggsave(here("results/sales_distribution.png"), sales_distribution)

carseats |> 
summarize(
  med_sales = median(sales),
  min_sales = min(sales),
  max_sales = max(sales)
)



## splitting data----
# set seed
set.seed(802345)

# split the data
carseats_split <- carseats |> 
  initial_split(prop = .75, strata = age)

carseats_train <- carseats_split |> training()
carseats_test <- carseats_split |>  testing()

# fold the data
carseats_fold <- carseats_train |> 
  vfold_cv(v = 10, repeats = 5, strata = sales)

# write out datasets
save(carseats_split, file = here("data/carseats_split.rda"))
save(carseats_train, file = here("data/carseats_train.rda"))
save(carseats_test, file = here("data/carseats_test.rda"))
save(carseats_fold, file = here("data/carseats_fold.rda"))

