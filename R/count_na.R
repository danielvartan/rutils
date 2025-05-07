#' Count the amount of `NA` values in a vector
#'
#' @description
#'
#' `count_na()` counts the amount of `NA` values in a vector.
#'
#' @param x An [`atomic`][checkmate::assert_atomic] object of any type.
#'
#' @return An [`integer`][base::integer] number with the amount of `NA` values
#'   in `x`.
#'
#' @family vector functions.
#' @export
#'
#' @examples
#' count_na(c(1, 2, NA, 4, 5))
#' #> [1] 1 # Expected
#'
#' count_na(c(1, 2, 3, 4, 5))
#' #> [1] 0 # Expected
#'
#' count_na(c(NA, NA, NA, NA, NA))
#' #> [1] 5 # Expected
count_na <- function(x) {
  checkmate::assert_atomic(x)

  length(which(is.na(x)))
}
