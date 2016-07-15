context("stack_multi")

test_that("stack_multi works on all columns at once", {
  all_multi <- stack_multi()

  co <- count(all_multi, column)
  expect_equal(sort(co$column),
               sort(stack_schema$column[stack_schema$type == "multi"]))

  expect_true(all(all_multi$respondent_id %in% stack_survey$respondent_id))
  answers <- all_multi %>%
    filter(column == "why_stack_overflow") %>%
    count(answer)
  expect_equal(nrow(answers), 10)
})

test_that("stack_multi works on one column", {
  multi_why_stack <- stack_multi("why_stack_overflow")
  expect_equal(nrow(count(multi_why_stack, answer)), 10)
  expect_true(all(multi_why_stack$column == "why_stack_overflow"))
})

test_that("stack_multi gives an error with non-multiple response columns", {
  expect_error(stack_multi("occupation"), "is not a multi-response column")
})
