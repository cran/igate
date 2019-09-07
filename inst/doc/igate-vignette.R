## ----setup, include = FALSE----------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>"
)

## ---- eval=FALSE---------------------------------------------------------
#  install.packages("igate")
#  library(igate)

## ---- include=FALSE------------------------------------------------------
library(igate)

## ------------------------------------------------------------------------
set.seed(123)
n <- nrow(iris)*2/3
rows <- sample(1:nrow(iris), n)
df <- iris[rows, ]
results <- igate(df, target = "Sepal.Length", good_end = "high", savePlots = TRUE)
results

## ------------------------------------------------------------------------
igate.regressions(df, target = "Sepal.Length", ssv = results$Causes, savePlots = TRUE)

## ------------------------------------------------------------------------
validation_df <- iris[-rows,]
val <- validate(iris, target = "Sepal.Length", causes = results$Causes, results_df = results)

## ------------------------------------------------------------------------
head(val[[1]])

## ------------------------------------------------------------------------
val[[2]]

## ------------------------------------------------------------------------
val[[3]]

## ---- eval=FALSE---------------------------------------------------------
#  validatedObs <- val[[1]]
#  validationCounts <- val[[2]]
#  validationSummary <- val[[3]]
#  
#  # choose a directory you want to save the plot into.
#  output_dir <- "YOUR_DIRECTORY"
#  
#  report(df = df,
#         target = "Sepal.Length",
#         type = "continuous",
#         good_outcome = "high",
#         results_path = "results",
#         validation = TRUE,
#         validation_path = "validatedObs",
#         validation_counts = "validationCounts",
#         validation_summary = "validationSummary",
#         output_name = "testing_igate",
#         output_directory = output_dir)

