testthat::test_that("update_pkg_year() | General test", {
  file <- tempfile()

  writeLines('\"2021\"', file)

  update_pkg_year(file)

  file |>
    readLines() |>
    testthat::expect_equal(
      Sys.Date() |>
        lubridate::year() |>
        as.character() |>
        glue::double_quote()
    )
})

testthat::test_that("update_pkg_year() | Error test", {
  # checkmate::assert_character(file, any.missing = FALSE)
  c("a", NA) |>
    update_pkg_year() |>
    testthat::expect_error()

  c(1, 2) |>
    update_pkg_year() |>
    testthat::expect_error()

  # checkmate::assert_file_exists(file)
  "./TeSt/TeSt.test" |>
    update_pkg_year() |>
    testthat::expect_error()
})
