testthat::test_that("inbetween_integers() | General test", {
  inbetween_integers(1, 5) |> testthat::expect_equal(2:4)
  inbetween_integers(5, 1) |> testthat::expect_equal(2:4)
})

testthat::test_that("inbetween_integers() | Error test", {
  # checkmate::assert_int(x)
  inbetween_integers(1.5, 1) |> testthat::expect_error()

  # checkmate::assert_int(y)
  inbetween_integers(1, 1.5) |> testthat::expect_error()
})
