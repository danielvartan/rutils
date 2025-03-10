testthat::test_that("std_error() | General test", {
  1:100 |>
    std_error() |>
    round(5) |>
    expect_equal(2.90115)
})

testthat::test_that("std_error() | Error test", {
  # checkmate::assert_numeric(x)
  "a" |> std_error() |> expect_error()
})
