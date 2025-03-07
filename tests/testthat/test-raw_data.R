test_that("raw_data_1() | General test", {
  raw_data_1(package = "base") |>
    checkmate::expect_character()
})

test_that("raw_data_1() | Error test", {
  raw_data_1(file = 1, package = "base") |>
    expect_error("Assertion on 'file' failed")
})
