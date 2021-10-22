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
na_as.POSIXct <- function(x) {
    out <- as.POSIXct(NA)
    attributes(out) <- attributes(x)
    out
}

#' @export
na_as.POSIXlt <- function(x) {
    out <- as.POSIXlt(NA)
    attributes(out) <- attributes(x)
    out
}