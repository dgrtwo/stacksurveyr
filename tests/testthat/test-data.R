context("datasets")

library(stringr)
suppressPackageStartupMessages(library(dplyr))

test_that("The schema is internally consistent", {
  select_types <- stack_schema %>%
    filter(str_detect(question, "\\(select")) %>%
    .$type
  expect_true(all(select_types == "multi"))
})


test_that("The schema is consistent with the Stack survey dataset", {
  expect_equal(colnames(stack_survey), stack_schema$column)

  select_types <- stack_schema %>%
    filter(str_detect(question, "\\(select")) %>%
    .$type

  multi_cols <- stack_schema$column[stack_schema$type == "multi"]

  for (col in colnames(stack_survey)) {
    if (col %in% multi_cols) {
      expect_true(any(str_detect(stack_survey[[col]], ";"), na.rm = TRUE),
                  paste("Expected at least one ; in", col))
    } else {
      expect_false(any(str_detect(stack_survey[[col]], ";"), na.rm = TRUE),
                   paste("Expected no ; in", col))
    }
  }
})



