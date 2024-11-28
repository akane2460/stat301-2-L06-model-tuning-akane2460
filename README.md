## Overview


The goal for this lab is to start using resampling methods to both tune and compare models. Instead of comparing one candidate model from each model type we will now explore several candidate sub-models from each model type by tuning hyperparameters. The lab focuses on hyperparameter tuning, but this technique easily extends tuning to preprocessing techniques or tuning of structural parameters. Ultimately leading to the selection of a final/winning/best model.

This lab covers material up to and including [13. Grid search (section 13.3)](https://www.tmwr.org/grid-search.html) from [Tidy Modeling with R](https://www.tmwr.org/).
## What's in the Repo

### Folders
- `data/` can find the original dataset `carseats.csv` and its codebook. Additionally, it includes training, testing, fold and split data generated and used for model fitting and analysis.
- `recipes/` can find the recipes used to create these predictive models
- `results/` can find fitted models and plots to be included in the final report.

### R Scripts
- `1_initial_setup.R` can find the early code processing, establishing the folds, and splitting into train/test sets
- `2_recipes.R` can find the recipes for lm and tree based models
- `3_tune_boosted.R` can find the tuning and specification of a boosted model
- `3_tune_kknn.R` can find the tuning and specification of a kknn model
- `3_tune_rf.R`can find the tuning and specification of a rf model
- `3_fit_boosted_final.R` can find the fitting of the selected final model
- `4_model_analysis_tuned.R` can find the analysis of all the tuned models and calculations to answer tasks
- `4_model_analysis_final.R` can find the analysis of the final model and calculations to answer tasks.

### Quarto Documents
- `Kane_Allison_L06.qmd` contains the exercises in their concise form and answers to questions.

### HTML Documents
- `Kane_Allison_L06.html` contains the rendered exercises in their concise form and answers to questions.

- `L06_model_tuning.html` contains a template of the lab.