test_that("raw_data_1() | general test", {
  raw_data_1(package = "base") |>
    checkmate::expect_character()
})

test_that("raw_data_1() | error test", {
  raw_data_1(file = 1, package = "base") |>
    expect_error("Assertion on 'file' failed")
})
