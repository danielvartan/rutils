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
