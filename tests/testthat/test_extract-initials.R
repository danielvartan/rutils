testthat::test_that("extract_initials() | General test", {
  extract_initials(c("John Doe", "Jane Doe", "John Smith")) |>
    testthat::expect_equal(c("J. D.", "J. D.", "J. S."))

  extract_initials(c("John Doe", "Jane Doe", "John Smith"), sep = ".") |>
    testthat::expect_equal(c("J.D.", "J.D.", "J.S."))
})

testthat::test_that("extract_initials() | Error test", {
  # checkmate::assert_character(x)
  extract_initials(list()) |> testthat::expect_error()
})
