# Sort tests by type or use the alphabetical order.

test_that("backtick_() | general test", {
    expect_equal(backtick_("a"), paste0("`", "a", "`"))
    expect_equal(backtick_(1), paste0("`", 1, "`"))
})

test_that("single_quote_() | general test", {
    expect_equal(single_quote_("a"), paste0("'", "a", "'"))
    expect_equal(single_quote_(1), paste0("'", 1, "'"))
})

test_that("double_quote_() | general test", {
    expect_equal(double_quote_("a"), paste0("\"", "a", "\""))
    expect_equal(double_quote_(1), paste0("\"", 1, "\""))
})

test_that("escape_regex() | general test", {
    expect_equal(escape_regex("test.test"), "test\\.test")
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

test_that("str_extract_() | general test", {
    expect_equal(str_extract_("test123", "\\d+$", TRUE),
                 regmatches("test123", regexpr("\\d+$", "test123",
                                               perl = TRUE)))
    expect_equal(str_extract_("test123", "^0$", TRUE), as.character(NA))
})

test_that("str_extract_() | error test", {
    expect_error(str_extract_(1, TRUE, TRUE, TRUE, TRUE, TRUE, TRUE),
                 "Assertion on 'pattern' failed")
    expect_error(str_extract_(1, "a", "", TRUE, TRUE, TRUE, TRUE),
                 "Assertion on 'ignore_case' failed")
    expect_error(str_extract_(1, "a", TRUE, "", TRUE, TRUE, TRUE),
                 "Assertion on 'perl' failed")
    expect_error(str_extract_(1, "a", TRUE, TRUE, "", TRUE, TRUE),
                 "Assertion on 'fixed' failed")
    expect_error(str_extract_(1, "a", TRUE, TRUE, TRUE, "", TRUE),
                 "Assertion on 'use_bytes' failed")
    expect_error(str_extract_(1, "a", TRUE, TRUE, TRUE, TRUE, ""),
                 "Assertion on 'invert' failed")
})

test_that("str_subset_() | general test", {
    expect_equal(str_subset_(month.name, "^J.+", perl = TRUE, negate = FALSE),
                 subset(month.name, grepl("^J.+", month.name, perl = TRUE)))
    expect_equal(str_subset_(month.name, "^J.+", perl = TRUE, negate = TRUE),
                 subset(month.name, !grepl("^J.+", month.name, perl = TRUE)))
    expect_equal(str_subset_(month.name, "^z$", perl = TRUE, negate = FALSE),
                 as.character(NA))
})

test_that("str_subset_() | error test", {
    expect_error(str_subset_(1, TRUE, TRUE, TRUE, TRUE, TRUE, TRUE),
                 "Assertion on 'pattern' failed")
    expect_error(str_subset_(1, "a", "", TRUE, TRUE, TRUE, TRUE),
                 "Assertion on 'negate' failed")
    expect_error(str_subset_(1, "a", TRUE, "", TRUE, TRUE, TRUE),
                 "Assertion on 'ignore_case' failed")
    expect_error(str_subset_(1, "a", TRUE, TRUE, "", TRUE, TRUE),
                 "Assertion on 'perl' failed")
    expect_error(str_subset_(1, "a", TRUE, TRUE, TRUE, "", TRUE),
                 "Assertion on 'fixed' failed")
    expect_error(str_subset_(1, "a", TRUE, TRUE, TRUE, TRUE, ""),
                 "Assertion on 'use_bytes' failed")
})
