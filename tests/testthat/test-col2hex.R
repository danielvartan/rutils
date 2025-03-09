testthat::test_that("col2hex() | General test", {
  col2hex("red") |> testthat::expect_equal("#FF0000")

  col2hex(c("red", "green", "blue")) |>
    testthat::expect_equal(c("#FF0000", "#00FF00", "#0000FF"))
})

testthat::test_that("col2hex() | Error test", {
  # checkmate::assert_character(x)
  col2hex(1) |> testthat::expect_error()
})
