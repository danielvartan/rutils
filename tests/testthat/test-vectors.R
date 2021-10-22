# Sort tests by type or use the alphabetical order.

test_that("class_collapse() | general test", {
    expect_equal(class_collapse("test"),
                 single_quote_(paste0(class("test"), collapse = "/")))
    expect_equal(class_collapse(1),
                 single_quote_(paste0(class(1), collapse = "/")))
    expect_equal(class_collapse(lubridate::dhours()),
                 single_quote_(paste0(class(lubridate::dhours()),
                                      collapse = "/")))
})

test_that("close_round() | error test", {
    expect_error(close_round("", 1), "Assertion on 'x' failed")
    expect_error(close_round(1, ""), "Assertion on 'digits' failed")
})

test_that("close_round() | general test", {
    expect_equal(close_round(1.999999, 5), 2)
    expect_equal(close_round(1.000001, 5), 1)
    expect_equal(close_round(1.001, 2), 1)
    expect_equal(close_round(1.0001, 5), 1.0001)
    expect_equal(close_round(c(1.000001, 1.999999, 1.11), 5),
                 c(1, 2, 1.11))
})

test_that("count_na() | general test", {
    expect_equal(count_na(c(1, NA, 1, NA)), 2)
})

test_that("fix_character() | general test", {
    expect_equal(fix_character(c("1   ", "   1", "", "NA")),
                 c("1", "1", NA, NA))
})

test_that("fix_character() | error test", {
    expect_error(fix_character(1), "Assertion on 'x' failed")
})

test_that("get_class() | general test", {
    expect_equal(get_class(1), "numeric")
    expect_equal(get_class(datasets::iris),
                 vapply(datasets::iris, function(x) class(x)[1], character(1)))
    expect_equal(get_class(list(a = 1, b = 1)),
                 vapply(list(a = 1, b = 1), function(x) class(x)[1],
                        character(1)))
})

test_that("get_names() | general test", {
    expect_equal(get_names(x, y, z), noquote(c("x", "y", "z")))
})
