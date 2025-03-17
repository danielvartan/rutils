#' Get all the integers between two integers
#'
#' @description
#'
#' `r lifecycle::badge("stable")`
#'
#' `inbetween_integers()` returns all the integers between two integers.
#'  This is useful while subsetting a vector.
#'
#' @param x An integer number.
#' @param y An integer number.
#'
#' @return An [`integer`][base::integer] vector with all the integers between
#' `x` and `y`.
#'
#' @family vector functions.
#' @export
#'
#' @examples
#' inbetween_integers(1, 5)
#' #> [1] 2 3 4 # Expected
#'
#' inbetween_integers(5, 1)
#' #> [1] 2 3 4 # Expected
inbetween_integers <- function(x, y) {
  checkmate::assert_int(x)
  checkmate::assert_int(y)

  lower_int <- min(x, y) |> floor()
  upper_int <- max(x, y) |> ceiling()

  setdiff(lower_int:upper_int, sort(c(x, y)))
}
