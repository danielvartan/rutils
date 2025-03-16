testthat::test_that("test_outlier() | General test", {
  test_outlier(c(1, 2, 3, 4, 100), method = "iqr") |>
    testthat::expect_equal(c(FALSE, FALSE, FALSE, FALSE, TRUE))

  test_outlier(c(1, 2, 3, 4, 5), method = "iqr") |>
    testthat::expect_equal(c(FALSE, FALSE, FALSE, FALSE, FALSE))

  test_outlier(c(1, 5, 6, 7, 10), method = "iqr", iqr_mult = 1) |>
    testthat::expect_equal(c(TRUE, FALSE, FALSE, FALSE, TRUE))

  test_outlier(c(1, 2, 3, 4, 5), method = "sd", sd_mult = 1) |>
    testthat::expect_equal(c(TRUE, FALSE, FALSE, FALSE, TRUE))

  test_outlier(c(1, 2, 3, 4, 100), method = "sd", sd_mult = 1) |>
    testthat::expect_equal(c(FALSE, FALSE, FALSE, FALSE, TRUE))
})

testthat::test_that("test_outlier() | Edge cases", {
  test_outlier(numeric(0), method = "iqr") |>
    testthat::expect_equal(logical(0))

  test_outlier(c(NA, NA, NA), method = "iqr") |>
    testthat::expect_equal(c(FALSE, FALSE, FALSE))

  test_outlier(c(1, 1, 1, 1, 1), method = "iqr") |>
    testthat::expect_equal(c(FALSE, FALSE, FALSE, FALSE, FALSE))
})

testthat::test_that("test_outlier() | Error test", {
  # checkmate::assert_numeric(x)
  test_outlier(
    x = "a",
    method = "iqr",
    iqr_mult = 1.5,
    sd_mult = 3
  ) |>
    testthat::expect_error()

  # checkmate::assert_choice(method, c("iqr", "sd"))
  test_outlier(
    x = c(1, 2, 3),
    method = "invalid_method",
    iqr_mult = 1.5,
    sd_mult = 3
  ) |>
    testthat::expect_error()

  # checkmate::assert_number(iqr_mult, lower = 1)
  test_outlier(
    x = c(1, 2, 3),
    method = "iqr",
    iqr_mult = "invalid",
    sd_mult = 3
  ) |>
    testthat::expect_error()

  test_outlier(
    x = c(1, 2, 3),
    method = "iqr",
    iqr_mult = "invalid",
    sd_mult = 0.5
  ) |>
    testthat::expect_error()

  # checkmate::assert_number(sd_mult, lower = 1)
  test_outlier(
    x = c(1, 2, 3),
    method = "sd",
    iqr_mult = 1.5,
    sd_mult = "invalid"
  ) |>
    testthat::expect_error()

  test_outlier(
    x = c(1, 2, 3),
    method = "sd",
    iqr_mult = 1.5,
    sd_mult = 0.5
  ) |>
    testthat::expect_error()
})
