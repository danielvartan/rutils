testthat::test_that("drop_na() | General test", {
  drop_na(c(NA, 1)) |> testthat::expect_equal(1)
})

testthat::test_that("drop_na() | Error test", {
  # checkmate::assert_atomic(x)
  drop_na(list()) |> testthat::expect_error()
})
