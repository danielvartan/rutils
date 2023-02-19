#' Return a `NA` value with the same characteristics of an R object
#'
#' @description
#'
#' `r lifecycle::badge("maturing")`
#'
#' `na_as()` returns a `NA` value of the same characteristics of an R object.
#' It really helps when you need to assign `NA`s dynamically.
#'
#' @param x An [atomic vector][checkmate::test_atomic_vector()], provided that
#'   `na_as()` have a method for it.
#'
#' @return A `NA` value with the same class and attributes of `x`.
#'
#' @family parsing/conversion functions
#' @export
#'
#' @examples
#' na_as(TRUE)
#' #> [1] NA # Expected
#' class(na_as(TRUE))
#' #> [1] "logical" # Expected
#'
#' na_as(as.Date("2020-01-01"))
#' #> [1] NA # Expected
#' class(na_as(as.Date("2020-01-01")))
#' #> [1] "Date"  # Expected
na_as <- function(x) {
    UseMethod("na_as")
}

#' @export
na_as.logical <- function(x) as.logical(NA)
#' @export
na_as.character <- function(x) as.character(NA)
#' @export
na_as.integer <- function(x) as.integer(NA)
#' @export
na_as.numeric <- function(x) as.numeric(NA)
#' @export
na_as.Duration <- function(x) lubridate::as.duration(NA)
#' @export
na_as.Period <- function(x) lubridate::as.period(NA)

#' @export
na_as.difftime <- function(x) {
    as.difftime(as.numeric(NA), units = attributes(x)$units)
}

#' @export
na_as.hms <- function(x) hms::as_hms(NA)
#' @export
na_as.Date <- function(x) as.Date(NA)
#' @export
na_as.hms <- function(x) hms::as_hms(NA)

#' @export
na_as.POSIXct <- function(x) as.POSIXct(NA, tz = attributes(x)$tzone)

#' @export
na_as.POSIXlt <- function(x) as.POSIXlt(NA, tz = attributes(x)$tzone)

#' @export
na_as.Interval <- function(x) {
    lubridate::interval(NA, NA, tz = attributes(x)$tzone)
}
