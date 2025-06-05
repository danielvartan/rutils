#' Compute the proportion of values in a vector
#'
#' @description
#'
#' `prop()` computes the proportion of specified values in a vector.
#'
#' @param x An [`atomic`][base::atomic] vector.
#' @param value An [`atomic`][base::atomic] vector containing the unique values
#'   in `x` for which to compute proportions.
#' @param na_rm A [`logical`][base::logical] flag indicating whether to
#'   remove `NA` values from `x` before computing proportions (default: `TRUE`).
#'
#' @return A [`numeric`][base::numeric] vector with the proportions of each
#'   value in `value` relative to the total number of values in `x`.
#'
#' @family statistical functions
#' @export
#'
#' @examples
#' prop(c("a", "b", "a", "c", "b", "a"), c("a", "b"))
#' #> [1] 0.500000 0.3333333
#'
#' prop(c(1, 2, 1, 2, 1), c(1, 2))
#' #> [1] 0.6 0.4
#'
#' prop(c(TRUE, TRUE, TRUE, FALSE), c(TRUE, FALSE))
#' #> [1] 0.75 0.25
prop <- function(x, value, na_rm = TRUE) {
  checkmate::assert_atomic_vector(x)
  checkmate::assert_atomic(value, unique = TRUE)
  prettycheck::assert_identical(x, value, type = "class")
  checkmate::assert_subset(value, unique(x))
  checkmate::assert_flag(na_rm)

  if (na_rm) x <- x[!is.na(x)]

  purrr::map_dbl(value, \(value) length(which(x == value)) / length(x))
}
