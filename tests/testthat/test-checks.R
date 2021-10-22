# Sort tests by type or use the alphabetical order.

test_that("*_has_length() | general test", {
    expect_true(test_has_length(c(1, 2)))
    expect_false(test_has_length(NULL))

    checkmate::expect_string(check_has_length(c(1, NA), any.missing = FALSE),
                             pattern = "'c\\(1, NA\\)' cannot have missing ")
    checkmate::expect_string(check_has_length(numeric()),
                             pattern = "'numeric\\(\\)' must have length ")
    expect_true(check_has_length(1))

    expect_equal(assert_has_length(1), 1)
    expect_error(assert_has_length(numeric()),
                 "Assertion on 'numeric\\(\\)' failed")
})

test_that("assert_identical() | general test", {
    expect_error(assert_identical(1))
    expect_error(assert_identical(1, c(1, 1), type = "value"))
    expect_true(assert_identical(1, 1, type = "value"))

    expect_error(assert_identical(1, c(2, 2), type = "length"))
    expect_true(assert_identical(1, 2, type = "length"))

    expect_error(assert_identical(1, "a", type = "class"))
    expect_true(assert_identical(1, 3, type = "class"))

    expect_true(assert_identical(NULL, NULL, null.ok = TRUE))
    expect_error(assert_identical(1, NA, any.missing = FALSE))
    expect_error(assert_identical(NULL, NULL, null.ok = FALSE))
})

test_that("*_length_one() | general test", {
    expect_true(test_length_one(NA))
    expect_false(test_length_one(NULL))

    checkmate::expect_string(check_length_one(c(1, 1)),
                             pattern = "'c\\(1, 1\\)' must have length 1, ")
    expect_true(check_length_one(1))

    expect_equal(assert_length_one(1), 1)
    expect_error(assert_length_one(c(1, 1)),
                 "Assertion on 'c\\(1, 1\\)' failed")
})

test_that("*_whole_number() | general test", {
    expect_true(test_whole_number(0))
    expect_true(test_whole_number(as.integer(1)))
    expect_true(test_whole_number(as.double(11)))
    expect_true(test_whole_number(as.numeric(475)))
    expect_true(test_whole_number(c(1, NA), any.missing = TRUE))
    expect_true(test_whole_number(NULL, null.ok = TRUE))
    expect_false(test_whole_number(-1L))
    expect_false(test_whole_number(-55))
    expect_false(test_whole_number(1.58))
    expect_false(test_whole_number(letters))
    expect_false(test_whole_number(datasets::iris))
    expect_false(test_whole_number(c(1, NA), any.missing = FALSE))
    expect_false(test_whole_number(NULL, null.ok = FALSE))

    checkmate::expect_string(check_whole_number(c(1, NA), any.missing = FALSE),
                             pattern = "'c\\(1, NA\\)' cannot have missing ")
    checkmate::expect_string(check_whole_number(NULL, null.ok = FALSE),
                             "'NULL' cannot have 'NULL' values")
    checkmate::expect_string(check_whole_number(c(1, 1.5)),
                             pattern = "'c\\(1, 1.5\\)' must consist of whole ")
    expect_true(check_whole_number(c(1, 1)))
    expect_true(check_whole_number(c(1, NA), any.missing = TRUE))
    expect_true(check_whole_number(NULL, null.ok = TRUE))

    expect_equal(assert_whole_number(c(1, 1)), c(1, 1))
    expect_error(assert_whole_number(c(1, 1.5)),
                 "Assertion on 'c\\(1, 1.5\\)' failed")
})
