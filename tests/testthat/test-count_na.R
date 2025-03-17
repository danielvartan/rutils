testthat::test_that("count_na() | General test", {
  count_na(c(NA, 2, 3, 4, 5)) |> testthat::expect_equal(1)
  count_na(c(1, 2, 3, 4, 5)) |> testthat::expect_equal(0)
  count_na(c(NA, NA, NA, NA, NA)) |> testthat::expect_equal(5)
})

testthat::test_that("count_na() | Error test", {
  # checkmate::assert_atomic(x)
  count_na(list()) |> testthat::expect_error()
})
