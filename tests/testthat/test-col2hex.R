testthat::test_that("col2hex() | General test", {
  col2hex("red") |> testthat::expect_equal("#FF0000")

  col2hex(c("red", "green", "blue")) |>
    testthat::expect_equal(c("#FF0000", "#00FF00", "#0000FF"))

  col2hex(c("red", "#000000")) |>
    testthat::expect_equal(c("#FF0000", "#000000"))

  col2hex(c("red", "#000000FF")) |>
    testthat::expect_equal(c("#FF0000", "#000000FF"))
})

testthat::test_that("col2hex() | Error test", {
  # checkmate::assert_character(x)
  col2hex(1) |> testthat::expect_error()

  # assert_color(x)
  col2hex("a") |> testthat::expect_error()
})
