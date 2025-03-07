test_that("shush() | general test", {
  expect_equal(shush(x = "a", quiet = FALSE), "a")

  test <- function() {
    warning("test", call. = FALSE)
    "test"
  }

  expect_equal(shush(x = test(), quiet = TRUE), "test")
  expect_warning(shush(x = test(), quiet = FALSE), "test")
})
