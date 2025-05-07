#' Find the most frequent value in a vector
#'
#' @description
#'
#' `mode()` returns the most frequent value in a vector.
#'
#' If there are more than one mode, it returns all of them. If all values are
#' unique, it returns `NA`.
#'
#' This function is based on
#'
#' @param x An [`atomic`][base::is.atomic()] vector.
#'
#' @return
#'
#' @family statistical functions.
#' @export
#'
#' @examples
#' mode(c(1, 2, 3, 4, 5, 6))
#' #> [1] NA # Expected
#'
#' mode(c(1, 2, 3, 4, 5, 5, 6))
#' #> [1] 5 # Expected
#'
#' mode(c(1, 2, 3, 4, 5, 5, 6, NA))
#' #> [1] 5 # Expected
#'
#' mode(c(1, 2, 3, 4, 5, 5, 6, 6))
#' #> [1] 5 6 # Expected
mode <- function(x) {
  checkmate::assert_atomic(x)

  # R CMD Check variable bindings fix
  # nolint start
  n <- NULL
  # nolint end

  out <-
    dplyr::tibble(x = x) |>
    dplyr::count(x) |>
    dplyr::arrange(dplyr::desc(n))

  if (out$n[1] == 1 || is.na(out$n[1])) {
    methods::as(NA, class(x)[1])
  } else if (length(out$x[out$n == out$n[1]] > 1)) {
    out$x[out$n == out$n[1]]
  } else {
    out$x[1]
  }
}
