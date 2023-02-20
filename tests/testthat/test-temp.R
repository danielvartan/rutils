test_that("multiplication works", {
  expect_equal(2 * 2, 4)
})
test_that("flat_posixct() | general test", {
    expect_equal(flat_posixt(
        posixt = lubridate::dmy_hms("17/04/1995 12:00:00"),
        base = as.Date("1970-01-01"), force_tz = TRUE,  tz = "UTC"
    ),
    lubridate::ymd_hms("1970-01-01 12:00:00")
    )

    expect_equal(flat_posixt(
        posixt = lubridate::dmy_hms("17/04/1995 12:00:00", tz = "EST"),
        base = as.Date("1970-01-01"), force_tz = FALSE,  tz = "UTC"
    ),
    lubridate::ymd_hms("1970-01-01 12:00:00", tz = "EST")
    )

    expect_equal(flat_posixt(
        posixt = lubridate::dmy_hms("17/04/1995 12:00:00", tz = "EST"),
        base = as.Date("2000-01-01"), force_tz = TRUE,  tz = "UTC"
    ),
    lubridate::ymd_hms("2000-01-01 12:00:00")
    )
})

test_that("flat_posixct() | error test", {
    # assert_posixt(posixt, null.ok = FALSE)
    expect_error(flat_posixt(
        posixt = 1, base = as.Date("1970-01-01"), force_tz = TRUE, tz = "UTC"
    ),
    "Assertion on 'posixt' failed"
    )

    # checkmate::assert_date(base, len = 1, all.missing = FALSE)
    expect_error(flat_posixt(
        posixt = lubridate::as_datetime(1), base = "", force_tz = TRUE,
        tz = "UTC"
    ),
    "Assertion on 'base' failed"
    )

    expect_error(flat_posixt(
        posixt = lubridate::as_datetime(1),
        base = c(as.Date("1970-01-01"), as.Date("1970-01-01")),
        force_tz = TRUE, tz = "UTC"
    ),
    "Assertion on 'base' failed"
    )

    expect_error(flat_posixt(
        posixt = lubridate::as_datetime(1),  base = as.Date(NA),
        force_tz = TRUE, tz = "UTC"
    ),
    "Assertion on 'base' failed"
    )

    # checkmate::assert_flag(force_tz)
    expect_error(flat_posixt(
        posixt = lubridate::as_datetime(1), base = as.Date("1970-01-01"),
        force_tz = 1, tz = "UTC"
    ),
    "Assertion on 'force_tz' failed"
    )

    # checkmate::assert_choice(tz, OlsonNames())
    expect_error(flat_posixt(
        posixt = lubridate::as_datetime(1), base = as.Date("1970-01-01"),
        force_tz = TRUE, tz = ""
    ),
    "Assertion on 'tz' failed"
    )
})

test_that("midday_change() | general test", {
    expect_equal(midday_change(
        time = hms::parse_hm("18:00")
    ),
    lubridate::ymd_hms("1970-01-01 18:00:00")
    )

    expect_equal(midday_change(
        time = lubridate::ymd_hms("2000-05-04 06:00:00")
    ),
    lubridate::ymd_hms("1970-01-02 06:00:00")
    )

    expect_equal(midday_change(
        time = c(lubridate::ymd_hms("2020-01-01 18:00:00"),
                 lubridate::ymd_hms("2020-01-01 06:00:00")
        )
    ),
    c(lubridate::ymd_hms("1970-01-01 18:00:00"),
      lubridate::ymd_hms("1970-01-02 06:00:00")
    ))
})

test_that("midday_change() | error test", {
    # checkmate::assert_multi_class(time, c("hms", "POSIXct", "POSIXlt"))
    expect_error(midday_change(time = 1), "Assertion on 'time' failed")
})

test_that("extract_seconds() | general test", {
    expect_equal(extract_seconds(x = lubridate::dhours(1)), 3600)
    expect_equal(extract_seconds(x = as.difftime(3600, units = "secs")), 3600)
    expect_equal(extract_seconds(x = hms::hms(3600)), 3600)

    expect_equal(extract_seconds(
        x = as.POSIXct("2020-01-01 01:00:00", tz = "UTC")
    ),
    3600
    )

    expect_equal(extract_seconds(
        x = as.POSIXlt("2020-01-01 01:00:00", tz = "UTC")
    ),
    3600
    )

    expect_equal(extract_seconds(
        x = lubridate::as.interval(lubridate::dhours(1), lubridate::origin)
    ),
    3600
    )
})

test_that("extract_seconds() | error test", {
    # checkmate::assert_multi_class(x, classes)
    expect_error(extract_seconds(x = 1), "Assertion on 'x' failed")
})
