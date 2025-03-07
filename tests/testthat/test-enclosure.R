test_that("backtick_() | general test", {
  expect_equal(backtick_(x = "a"), paste0("`", "a", "`"))
  expect_equal(backtick_(x = 1), paste0("`", 1, "`"))
})

test_that("single_quote_() | general test", {
  expect_equal(single_quote_(x = "a"), paste0("'", "a", "'"))
  expect_equal(single_quote_(x = 1), paste0("'", 1, "'"))
})

test_that("double_quote_() | general test", {
  expect_equal(double_quote_(x = "a"), paste0("\"", "a", "\""))
  expect_equal(double_quote_(x = 1), paste0("\"", 1, "\""))
})
