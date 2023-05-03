# Sort tests by type or use the alphabetical order.

test_that("class_collapse() | general test", {
    expect_equal(class_collapse(
        x = "test"
    ),
    single_quote_(paste0(class("test"), collapse = "/"))
    )

    expect_equal(class_collapse(
        x = 1
    ),
    single_quote_(paste0(class(1), collapse = "/"))
    )

    expect_equal(class_collapse(
        x = lubridate::dhours()
    ),
    single_quote_(paste0(class(lubridate::dhours()), collapse = "/"))
    )
})

test_that("paste_collapse() | general test", {
    expect_equal(paste_collapse(1), 1)
    expect_equal(paste_collapse(1:2), "12")
    expect_equal(paste_collapse(1:2, sep = " "), "1 2")
    expect_equal(paste_collapse(1:2, sep = " ", last = ""), "12")
    expect_equal(paste_collapse(1:2, sep = " ", last = " or "), "1 or 2")
    expect_equal(paste_collapse(1:3, sep = ", ", last = ", or "), "1, 2, or 3")
})

test_that("paste_collapse() | error test", {
    # checkmate::assert_string(sep)
    expect_error(paste_collapse(x = 1:2, sep = 1, last = ""),
                 "Assertion on 'sep' failed")

    # checkmate::assert_string(last)
    expect_error(paste_collapse(x = 1:2, sep = "", last = 1),
                 "Assertion on 'last' failed")
})

test_that("inline_collapse() | general test", {
    expect_equal(inline_collapse(1:2), "'1' and '2'")
    expect_equal(inline_collapse(1:3), "'1', '2', and '3'")
    expect_equal(inline_collapse(1:3, last = "or"), "'1', '2', or '3'")
    expect_equal(inline_collapse(1:3, single_quote = FALSE), "1, 2, and 3")
    expect_equal(inline_collapse(1:3, serial_comma  = FALSE),
                 "'1', '2' and '3'")

})

test_that("inline_collapse() | error test", {
    # checkmate::assert_string(last)
    expect_error(inline_collapse(
        x = 1:3, last = 1, single_quote = TRUE, serial_comma = TRUE),
                 "Assertion on 'last' failed")
    # checkmate::assert_flag(single_quote)
    expect_error(inline_collapse(
        x = 1:3, last = "", single_quote = 1, serial_comma = TRUE),
        "Assertion on 'single_quote' failed")
    # checkmate::assert_flag(serial_comma)
    expect_error(inline_collapse(
        x = 1:3, last = "", single_quote = TRUE, serial_comma = 1),
        "Assertion on 'serial_comma' failed")
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
    expect_equal(count_na(x = c(1, NA, 1, NA)), 2)
})

test_that("drop_na() | general test", {
    expect_equal(drop_na(c(NA, 1)), 1)
})

test_that("fix_character() | general test", {
    expect_equal(fix_character(c("1   ", "   1", "", "NA")),
                 c("1", "1", NA, NA))
})

test_that("fix_character() | error test", {
    expect_error(fix_character(1), "Assertion on 'x' failed")
})

test_that("get_class() | general test", {
    expect_equal(get_class(x = 1), "numeric")

    expect_equal(get_class(
        x = datasets::iris
    ),
    vapply(datasets::iris, function(x) class(x)[1], character(1))
    )

    expect_equal(get_class(
        x = list(a = 1, b = 1)
    ),
    vapply(list(a = 1, b = 1), function(x) class(x)[1], character(1))
    )
})

test_that("get_names() | general test", {
    expect_equal(get_names(x, y, z), noquote(c("x", "y", "z")))
})
