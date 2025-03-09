#' Remove `NA` values from an atomic object
#'
#' @description
#'
#' `r lifecycle::badge("stable")`
#'
#' `drop_na()` remove all `NA` values from an atomic object.
#'
#' @param x An [`atomic`][checkmate::assert_atomic] object of any type.
#'
#' @return An object of the same type as `x` with all `NA` values removed.
#'
#' @family vector functions.
#' @export
#'
#' @examples
#' drop_na(c(1, NA, 2, 3, NA, 4))
#' #> [1] 1 2 3 4 # Expected
#'
#' drop_na(c("a", NA, "b", "c"))
#' #> [1] "a" "b" "c" # Expected
drop_na <- function(x) {
  checkmate::assert_atomic(x)

  x[which(!is.na(x))]
}
