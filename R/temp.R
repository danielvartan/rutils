flat_posixt <- function(posixt, base = as.Date("1970-01-01"),
                        force_tz = TRUE, tz = "UTC") {
    assert_posixt(posixt, null.ok = FALSE)
    checkmate::assert_date(base, len = 1, all.missing = FALSE)
    checkmate::assert_flag(force_tz)
    checkmate::assert_choice(tz, OlsonNames())

    lubridate::date(posixt) <- base

    if (isTRUE(force_tz)) {
        lubridate::force_tz(posixt, tz)
    } else {
        posixt
    }
}

midday_change <- function(time) {
    checkmate::assert_multi_class(time, c("hms", "POSIXct", "POSIXlt"))

    if (hms::is_hms(time)) time <- as.POSIXct(time)
    time <- flat_posixt(time)

    dplyr::case_when(
        lubridate::hour(time) < 12 ~ lubridate::`day<-`(time, 2),
        TRUE ~ time
    )
}

extract_seconds <- function(x) {
    classes <- c("Duration", "difftime", "hms", "POSIXct", "POSIXlt",
                 "Interval")

    checkmate::assert_multi_class(x, classes)

    if (lubridate::is.POSIXt(x) || lubridate::is.difftime(x)) {
        as.numeric(hms::as_hms(x))
    } else {
        as.numeric(x)
    }
}
