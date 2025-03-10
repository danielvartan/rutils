testthat::test_that("cut_interval_mean() | General test", {
  cut(1:5, breaks = 3) |>
    cut_interval_mean() |>
    testthat::expect_equal(c(1.663, 1.663, 3, 4.335, 4.335))

  cut(1:5, breaks = 3) |>
    cut_interval_mean(names = TRUE) |>
    names() |>
    testthat::expect_equal(as.character(cut(1:5, breaks = 3)))

  cut(1:5, breaks = 3) |>
    cut_interval_mean(round = TRUE) |>
    testthat::expect_equal(c(2, 2, 3, 4, 4))

  cut(-1:5, breaks = 3) |>
    cut_interval_mean() |>
    testthat::expect_equal(c(-0.005, -0.005, -0.005, 2, 2, 4.005, 4.005))

  cut(-1:5, breaks = 3) |>
    cut_interval_mean(names = TRUE) |>
    names() |>
    testthat::expect_equal(as.character(cut(-1:5, breaks = 3)))

  cut(-1:5, breaks = 3) |>
    cut_interval_mean(round = TRUE) |>
    testthat::expect_equal(c(0, 0, 0, 2, 2, 4, 4))
})

testthat::test_that("cut_interval_mean() | Error test", {
  # checkmate::assert_multi_class(x, c("character", "factor"))
  cut_interval_mean(1, FALSE, FALSE) |> testthat::expect_error()

  # checkmate::assert_character(as.character(x), pattern = "^\\[|^\\(")
  cut_interval_mean("1", FALSE, FALSE) |> testthat::expect_error()

  # checkmate::assert_flag(round)
  cut_interval_mean(
    cut(1:5, breaks = 3),
    round = "TRUE",
    names = FALSE
  ) |>
    testthat::expect_error()

  # checkmate::assert_flag(names)
  cut_interval_mean(
    cut(1:5, breaks = 3),
    round = FALSE,
    names = "TRUE"
  ) |>
    testthat::expect_error()
})
