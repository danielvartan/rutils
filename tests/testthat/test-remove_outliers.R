testthat::test_that("remove_outliers() | General test", {
  remove_outliers(1:50, method = "iqr") |>
    testthat::expect_equal(1:50)

  remove_outliers(c(1:50, 100), method = "iqr") |>
    testthat::expect_equal(1:50)

  remove_outliers(1:50, method = "sd") |>
    testthat::expect_equal(1:50)

  remove_outliers(c(1:50, 100), method = "sd") |>
    testthat::expect_equal(1:50)
})

testthat::test_that("remove_outliers() | Edge cases", {
  remove_outliers(numeric(0), method = "iqr") |>
    testthat::expect_equal(numeric(0))

  remove_outliers(c(NA, NA, NA), method = "iqr") |>
    testthat::expect_equal(c(NA, NA, NA))

  remove_outliers(c(1, 1, 1, 1, 1), method = "iqr") |>
    testthat::expect_equal(c(1, 1, 1, 1, 1))
})

testthat::test_that("remove_outliers() | Error test", {
  # checkmate::assert_numeric(x)
  remove_outliers(
    x = "a",
    method = "iqr",
    iqr_mult = 1.5,
    sd_mult = 3
  ) |>
    testthat::expect_error()

  # checkmate::assert_choice(method, c("iqr", "sd"))
  remove_outliers(
    x = c(1, 2, 3),
    method = "invalid_method",
    iqr_mult = 1.5,
    sd_mult = 3
  ) |>
    testthat::expect_error()

  # checkmate::assert_number(iqr_mult, lower = 1)
  remove_outliers(
    x = c(1, 2, 3),
    method = "iqr",
    iqr_mult = "invalid",
    sd_mult = 3
  ) |>
    testthat::expect_error()

  remove_outliers(
    x = c(1, 2, 3),
    method = "iqr",
    iqr_mult = "invalid",
    sd_mult = 0.5
  ) |>
    testthat::expect_error()

  # checkmate::assert_number(sd_mult, lower = 1)
  remove_outliers(
    x = c(1, 2, 3),
    method = "sd",
    iqr_mult = 1.5,
    sd_mult = "invalid"
  ) |>
    testthat::expect_error()

  remove_outliers(
    x = c(1, 2, 3),
    method = "sd",
    iqr_mult = 1.5,
    sd_mult = 0.5
  ) |>
    testthat::expect_error()
})
