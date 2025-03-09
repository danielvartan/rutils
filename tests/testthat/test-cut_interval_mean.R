testthat::test_that("cut_interval_mean() | General test", {
  cut(1:5, breaks = 3) |>
    cut_interval_mean() |>
    testthat::expect_equal(c(2, 2, 3, 4, 4))

  cut(1:5, breaks = 3) |>
    cut_interval_mean(round = FALSE) |>
    testthat::expect_equal(c(1.663, 1.663, 3, 4.335, 4.335))
})

testthat::test_that("cut_interval_mean() | Error test", {
  # checkmate::assert_multi_class(x, c("character", "factor"))
  cut_interval_mean(1, TRUE) |> testthat::expect_error()

  # checkmate::assert_character(as.character(x), pattern = "^\\[|^\\(")
  cut_interval_mean("1", TRUE) |> testthat::expect_error()
})
