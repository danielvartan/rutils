test_that("*_has_length() | general test", {
    expect_true(test_has_length(x = c(1, 2)))
    expect_false(test_has_length(x = NULL))

    checkmate::expect_string(check_has_length(
        x = c(1, NA), any.missing = FALSE
    ),
    pattern = "'c\\(1, NA\\)' cannot have missing "
    )

    checkmate::expect_string(check_has_length(
        x = numeric()
    ),
    pattern = "'numeric\\(\\)' must have length "
    )

    expect_true(check_has_length(x = 1))
    expect_equal(assert_has_length(x = 1), 1)

    expect_error(assert_has_length(
        x = numeric()
    ),
    "Assertion on 'numeric\\(\\)' failed"
    )
})

test_that("assert_internet() | general test", {
    mock <- function(.parent = parent.frame(), .env = topenv(.parent)) {
        mockr::with_mock(
            has_internet = function(...) TRUE,
            {assert_internet()}
        )
    }

    expect_true(mock())

    mock <- function(.parent = parent.frame(), .env = topenv(.parent)) {
        mockr::with_mock(
            has_internet = function(...) FALSE,
            {assert_internet()}
        )
    }

    expect_error(mock())
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
    expect_true(test_length_one(x = NA))
    expect_false(test_length_one(x = NULL))

    checkmate::expect_string(check_length_one(
        x = c(1, 1)
    ),
    pattern = "'c\\(1, 1\\)' must have length 1, "
    )

    expect_true(check_length_one(x = 1))
    expect_equal(assert_length_one(x = 1), 1)

    expect_error(assert_length_one(
        x = c(1, 1)
    ),
    "Assertion on 'c\\(1, 1\\)' failed"
    )
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
                             "'NULL' cannot be 'NULL'")
    checkmate::expect_string(check_whole_number(c(1, 1.5)),
                             pattern = "'c\\(1, 1.5\\)' must consist of whole ")
    expect_true(check_whole_number(c(1, 1)))
    expect_true(check_whole_number(c(1, NA), any.missing = TRUE))
    expect_true(check_whole_number(NULL, null.ok = TRUE))

    expect_equal(assert_whole_number(c(1, 1)), c(1, 1))
    expect_error(assert_whole_number(c(1, 1.5)),
                 "Assertion on 'c\\(1, 1.5\\)' failed")
})

test_that("*_numeric_() | general test", {
    expect_true(test_numeric_(x = as.integer(1)))
    expect_true(test_numeric_(x = as.double(1)))
    expect_true(test_numeric_(x = as.numeric(1)))
    expect_true(test_numeric_(x = c(1, NA), any.missing = TRUE))
    expect_true(test_numeric_(x = NULL, null.ok = TRUE))
    expect_false(test_numeric_(x = lubridate::dhours()))
    expect_false(test_numeric_(x = letters))
    expect_false(test_numeric_(x = datasets::iris))
    expect_false(test_numeric_(x = c(1, NA), any.missing = FALSE))
    expect_false(test_numeric_(x = NULL, null.ok = FALSE))
    expect_false(test_numeric_(x = 1, lower = 2))
    expect_false(test_numeric_(x = 1, upper = 0))

    checkmate::expect_string(check_numeric_(
        x = c(1, NA), any.missing = FALSE
    ),
    "'c\\(1, NA\\)' cannot have missing values"
    )

    checkmate::expect_string(check_numeric_(
        x = NULL, null.ok = FALSE
    ),
    "'NULL' cannot be 'NULL'"
    )

    checkmate::expect_string(check_numeric_(
        x = 1, lower = 2
    ),
    "Element 1 is not <= "
    )

    checkmate::expect_string(check_numeric_(
        x = 1, upper = 0
    ),
    "Element 1 is not >= "
    )

    checkmate::expect_string(check_numeric_(
        x = c("a", "b")
    ),
    "Must be of type 'numeric', not 'character'"
    )

    expect_true(check_numeric_(x = c(1, 1)))
    expect_true(check_numeric_(x = NULL, null.ok = TRUE))

    expect_equal(assert_numeric_(x = c(1, 1)), c(1, 1))

    expect_error(assert_numeric_(
        x = c("a", "b")
    ),
    "Assertion on 'c\\(\"a\", \"b\"\\)' failed"
    )
})

test_that("*_duration() | general test", {
    expect_true(test_duration(x = lubridate::dhours(1)))

    expect_true(test_duration(
        x = c(lubridate::dhours(1), NA), any.missing = TRUE)
    )

    expect_true(test_duration(x = NULL, null.ok = TRUE))
    expect_false(test_duration(x = "a"))
    expect_false(test_duration(x = 1))
    expect_false(test_duration(x = lubridate::hours()))
    expect_false(test_duration(x = hms::hms(1)))
    expect_false(test_duration(x = datasets::iris))

    expect_false(test_duration(
        x = c(lubridate::dhours(1), NA), any.missing = FALSE)
    )

    expect_false(test_duration(x = NULL, null.ok = FALSE))

    expect_false(test_duration(
        x = lubridate::dhours(1), lower = lubridate::dhours(2))
    )

    expect_false(test_duration(
        x = lubridate::dhours(1), upper = lubridate::dhours(0))
    )

    checkmate::expect_string(check_duration(
        x = c(1, NA), any.missing = FALSE
    ),
    "'c\\(1, NA\\)' cannot have missing values"
    )

    checkmate::expect_string(check_duration(
        x = NULL, null.ok = FALSE
    ),
    "'NULL' cannot be 'NULL'"
    )

    checkmate::expect_string(check_duration(
        x = lubridate::dhours(1), lower = lubridate::dhours(2)
    ),
    "Element 1 is not <= "
    )

    checkmate::expect_string(check_duration(
        x = lubridate::dhours(1), upper = lubridate::dhours(0)
    ),
    "Element 1 is not >= "
    )

    checkmate::expect_string(check_duration(
        x = c(1, 1)
    ),
    "Must be of type 'Duration', not 'numeric'"
    )

    expect_true(check_duration(
        x = c(lubridate::dhours(1), lubridate::dhours(1)))
    )

    expect_true(check_duration(x = NULL, null.ok = TRUE))

    expect_equal(assert_duration(
        x = c(lubridate::dhours(1), lubridate::dhours(1))
    ),
    c(lubridate::dhours(1), lubridate::dhours(1))
    )

    expect_error(assert_duration(
        x = c(1, 1)
    ),
    "Assertion on 'c\\(1, 1\\)' failed"
    )
})

test_that("*_hms() | general test", {
    expect_true(test_hms(x = hms::hms(1)))
    expect_true(test_hms(x = c(hms::hms(1), NA), any.missing = TRUE))
    expect_true(test_hms(x = NULL, null.ok = TRUE))
    expect_false(test_hms(x = "a"))
    expect_false(test_hms(x = 1))
    expect_false(test_hms(x = lubridate::hours()))
    expect_false(test_hms(x = lubridate::dhours()))
    expect_false(test_hms(x = datasets::iris))

    expect_false(test_hms(
        x = c(lubridate::dhours(1), NA), any.missing = FALSE)
    )

    expect_false(test_hms(x = NULL, null.ok = FALSE))

    expect_false(test_hms(
        x = hms::hms(1), lower = hms::hms(2))
    )

    expect_false(test_hms(
        x = hms::hms(1), upper = hms::hms(0))
    )

    checkmate::expect_string(check_hms(
        x = c(1, NA), any.missing = FALSE
    ),
    "'c\\(1, NA\\)' cannot have missing values"
    )

    checkmate::expect_string(check_hms(
        x = NULL, null.ok = FALSE
    ),
    "'NULL' cannot be 'NULL'"
    )

    checkmate::expect_string(check_hms(
        x = hms::hms(1), lower = hms::hms(2)
    ),
    "Element 1 is not <= "
    )

    checkmate::expect_string(check_hms(
        x = hms::hms(1), upper = hms::hms(0)
    ),
    "Element 1 is not >= "
    )

    checkmate::expect_string(check_hms(
        x = c(1, 1)
    ),
    "Must be of type 'hms', not 'numeric'"
    )

    expect_true(check_hms(x = c(hms::hms(1), hms::hms(1))))
    expect_true(check_hms(x = NULL, null.ok = TRUE))

    expect_equal(assert_hms(
        x = c(hms::hms(1), hms::hms(1))
    ),
    c(hms::hms(1), hms::hms(1))
    )

    expect_error(assert_hms(
        x = c(1, 1)
    ),
    "Assertion on 'c\\(1, 1\\)' failed"
    )
})

test_that("*_hms() | error test", {
    # checkmate::assert_flag(any.missing)
    expect_error(test_hms(hms::hms(1), any.missing = 1))
    expect_error(check_hms(hms::hms(1), any.missing = 1))

    # checkmate::assert_flag(null.ok)
    expect_error(test_hms(hms::hms(1), null.ok = 1))
    expect_error(check_hms(hms::hms(1), null.ok = 1))
})

test_that("*_posixt() | general test", {
    expect_true(test_posixt(x = lubridate::as_datetime(1)))
    expect_true(test_posixt(x = as.POSIXlt(lubridate::as_datetime(1))))

    expect_true(test_posixt(
        x = c(lubridate::as_datetime(1), NA), any.missing = TRUE)
    )

    expect_true(test_posixt(x = NULL, null.ok = TRUE))
    expect_false(test_posixt(x = "a"))
    expect_false(test_posixt(x = 1))
    expect_false(test_posixt(x = lubridate::hours()))
    expect_false(test_posixt(x = hms::hms(1)))
    expect_false(test_posixt(x = datasets::iris))

    expect_false(test_posixt(
        x = c(lubridate::as_datetime(1), NA), any.missing = FALSE)
    )

    expect_false(test_posixt(x = NULL, null.ok = FALSE))

    expect_false(test_posixt(
        x = lubridate::as_datetime(1), lower = lubridate::as_datetime(2))
    )

    expect_false(test_posixt(
        x = lubridate::as_datetime(1), upper = lubridate::as_datetime(0))
    )

    checkmate::expect_string(check_posixt(
        x = c(1, NA), any.missing = FALSE
    ),
    "'c\\(1, NA\\)' cannot have missing values"
    )

    checkmate::expect_string(check_posixt(
        x = NULL, null.ok = FALSE
    ),
    "'NULL' cannot be 'NULL'"
    )

    checkmate::expect_string(check_posixt(
        x = lubridate::as_datetime(1), lower = lubridate::as_datetime(2)
    ),
    "Element 1 is not <= "
    )

    checkmate::expect_string(check_posixt(
        x = lubridate::as_datetime(1), upper = lubridate::as_datetime(0)
    ),
    "Element 1 is not >= "
    )

    checkmate::expect_string(check_posixt(
        x = c(1, 1)
    ),
    "Must be of type 'POSIXct' or 'POSIXlt', "
    )

    expect_true(check_posixt(
        x = c(lubridate::as_datetime(1), lubridate::as_datetime(1)))
    )

    expect_true(check_posixt(x = NULL, null.ok = TRUE))

    expect_equal(assert_posixt(
        x = c(lubridate::as_datetime(1), lubridate::as_datetime(1))
    ),
    c(lubridate::as_datetime(1), lubridate::as_datetime(1))
    )

    expect_error(assert_posixt(
        x = c(1, 1)
    ),
    "Assertion on 'c\\(1, 1\\)' failed"
    )
})

test_that("*_posixt() | error test", {
    # checkmate::assert_flag(any.missing)
    expect_error(test_posixt(lubridate::as_datetime(1), any.missing = 1))
    expect_error(check_posixt(lubridate::as_datetime(1), any.missing = 1))

    # checkmate::assert_flag(null.ok)
    expect_error(test_posixt(lubridate::as_datetime(1), null.ok = 1))
    expect_error(check_posixt(lubridate::as_datetime(1), null.ok = 1))
})

test_that("*_interval() | general test", {
    int <- lubridate::interval(
        as.POSIXct("2020-01-01 00:00:00"), as.POSIXct("2020-01-02 00:00:00"))
    int_lower <- lubridate::interval(
        as.POSIXct("2020-01-01 01:00:00"), as.POSIXct("2020-01-02 00:00:00"))
    int_upper <- lubridate::interval(
        as.POSIXct("2020-01-01 00:00:00"), as.POSIXct("2020-01-02 01:00:00"))

    expect_true(test_interval(int))
    expect_true(test_interval(c(int, lubridate::as.interval(NA)),
                              any.missing = TRUE))
    expect_true(test_interval(NULL, null.ok = TRUE))
    expect_true(test_interval(int, lower = int_lower))
    expect_true(test_interval(int, upper = int_upper))
    expect_false(test_interval("a"))
    expect_false(test_interval(1))
    expect_false(test_interval(lubridate::hours()))
    expect_false(test_interval(hms::hms(1)))
    expect_false(test_interval(datasets::iris))
    expect_false(test_interval(c(int, NA), any.missing = FALSE))
    expect_false(test_interval(NULL, null.ok = FALSE))
    expect_false(test_interval(int, lower = int_upper))
    expect_false(test_interval(int, upper = int_lower))

    checkmate::expect_string(
        check_interval(c(1, NA), any.missing = FALSE),
        pattern = "'c\\(1, NA\\)' cannot have missing values"
        )
    checkmate::expect_string(check_interval(NULL, null.ok = FALSE),
                             pattern = "'NULL' cannot be 'NULL'")
    checkmate::expect_string(check_interval(int, lower = int_upper),
                             pattern = "Element 1 is not >= ")
    checkmate::expect_string(check_interval(int, upper = int_lower),
                             pattern = "Element 1 is not <= ")
    checkmate::expect_string(check_interval(c(1, 1)),
                             pattern = "Must be of type 'Interval'")
    expect_true(check_interval(c(int, int_lower)))
    expect_true(check_interval(NULL, null.ok = TRUE))

    expect_equal(assert_interval(c(int, int_lower)), c(int, int_lower))
    expect_error(assert_interval(c(1, 1)), "Assertion on 'c\\(1, 1\\)' failed")
})

test_that("*_interval() | error test", {
    # checkmate::assert_flag(any.missing)
    expect_error(test_interval(lubridate::as_datetime(1), any.missing = 1))
    expect_error(check_interval(lubridate::as_datetime(1), any.missing = 1))

    # checkmate::assert_flag(null.ok)
    expect_error(test_interval(lubridate::as_datetime(1), null.ok = 1))
    expect_error(check_interval(lubridate::as_datetime(1), null.ok = 1))
})

test_that("*_temporal() | general test", {
    expect_true(test_temporal(lubridate::dhours()))
    expect_true(test_temporal(lubridate::hours()))
    expect_true(test_temporal(as.difftime(1, units = "secs")))
    expect_true(test_temporal(hms::hms(1)))
    expect_true(test_temporal(as.Date("2000-01-01")))
    expect_true(test_temporal(lubridate::as_datetime(1)))
    expect_true(test_temporal(as.POSIXlt(lubridate::as_datetime(1))))
    expect_true(test_temporal(lubridate::as.interval(
        lubridate::dhours(), lubridate::as_datetime(0))))
    expect_true(test_temporal(NULL, null.ok = TRUE))
    expect_false(test_temporal(1))
    expect_false(test_temporal(letters))
    expect_false(test_temporal(datasets::iris))
    expect_false(test_temporal(lubridate::dhours(), rm = "Duration"))
    expect_false(test_temporal(lubridate::hours(), rm = "Period"))
    expect_false(test_temporal(as.difftime(1, units = "secs"), rm = "difftime"))
    expect_false(test_temporal(hms::hms(1), rm = "hms"))
    expect_false(test_temporal(as.Date("2000-01-01"), rm = "Date"))
    expect_false(test_temporal(lubridate::as_datetime(1), rm = "POSIXct"))
    expect_false(test_temporal(as.POSIXlt(lubridate::as_datetime(1)),
                               rm = "POSIXlt"))
    expect_false(test_temporal(lubridate::as.interval(
        lubridate::dhours(), lubridate::as_datetime(0)), rm = "Interval"))
    expect_false(test_temporal(c(1, NA), any.missing = FALSE))
    expect_false(test_temporal(NULL, null.ok = FALSE))

    checkmate::expect_string(check_temporal(c(1, 1)),
                             pattern = "Must be a temporal object ")
    checkmate::expect_string(check_temporal(c(1, NA), any.missing = FALSE),
                             pattern = "'c\\(1, NA\\)' cannot have missing ")
    checkmate::expect_string(check_temporal(NULL, null.ok = FALSE),
                             pattern = "'NULL' cannot be 'NULL'")
    expect_true(check_temporal(c(lubridate::hours(1), lubridate::hours(1))))
    expect_true(check_temporal(NULL, null.ok = TRUE))

    expect_equal(assert_temporal(c(lubridate::hours(1), lubridate::hours(1))),
                 c(lubridate::hours(1), lubridate::hours(1)))
    expect_error(assert_temporal(c(1, 1)), "Assertion on 'c\\(1, 1\\)' failed")
})
