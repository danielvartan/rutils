test_that("raw_data_1() | general test", {
    checkmate::expect_character(raw_data_1(package = "base"))
})

test_that("raw_data_1() | error test", {
    expect_error(raw_data_1(file = 1, package = "base"),
                 "Assertion on 'file' failed")
})
