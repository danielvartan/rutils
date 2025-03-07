test_that("escape_regex() | general test", {
  expect_equal(escape_regex(x = "test.test"), "test\\.test")
})
