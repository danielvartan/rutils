#' Return a `NA` value of the same type of an R object
#'
#' @description
#'
#' `r lifecycle::badge("stable")`
#'
#' `na_as()` returns a `NA` value of the same class and attributes of a
#' specific R object.
#'
#' This function was made to facilitate assigning `NA`s dynamically.
#'
#' @param x An [atomic][checkmate::test_atomic] vector, provided that
#'   `na_as()` has a method for it.
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

#' @rdname na_as
#' @export
na_as.logical <- function(x) as.logical(NA)

#' @rdname na_as
#' @export
na_as.character <- function(x) as.character(NA)

#' @rdname na_as
#' @export
na_as.integer <- function(x) as.integer(NA)

#' @rdname na_as
#' @export
na_as.numeric <- function(x) as.numeric(NA)

#' @rdname na_as
#' @export
na_as.Duration <- function(x) lubridate::as.duration(NA)

#' @rdname na_as
#' @export
na_as.Period <- function(x) lubridate::as.period(NA)

#' @rdname na_as
#' @export
na_as.difftime <- function(x) {
  as.difftime(as.numeric(NA), units = attributes(x)$units)
}

#' @rdname na_as
#' @export
na_as.hms <- function(x) hms::as_hms(NA)

#' @rdname na_as
#' @export
na_as.Date <- function(x) as.Date(NA)

#' @rdname na_as
#' @export
na_as.hms <- function(x) hms::as_hms(NA)

#' @rdname na_as
#' @export
na_as.POSIXct <- function(x) as.POSIXct(NA, tz = attributes(x)$tzone)

#' @rdname na_as
#' @export
na_as.POSIXlt <- function(x) as.POSIXlt(NA, tz = attributes(x)$tzone)

#' @rdname na_as
#' @export
na_as.Interval <- function(x) {
  lubridate::interval(NA, NA, tz = attributes(x)$tzone)
}
