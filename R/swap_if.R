#' Swap two values if a condition is met
#'
#' @description
#'
#' `r lifecycle::badge("maturing")`
#'
#' `swap_if()` swaps two values if a condition is met.
#'
#' @param x Any type of R object.
#' @param y Any type of R object.
#' @param condition A [`logical`][base::logical] flag indicating if the
#'   values should be swapped (Default: `TRUE`).
#'
#' @return A [`list`][base::list] with the swapped values.
#'
#' @family conditional functions.
#' @export
#'
#' @examples
#' swap_if(1, 2)
#' #> $x # Expected
#' #> [1] 2
#' #>
#' #> $y
#' #> [1] 1
#'
#' swap_if(1, 2, condition = FALSE)
#' #> $x # Expected
#' #> [1] 1
#' #>
#' #> $y
#' #> [1] 2
swap_if <- function(x, y, condition = TRUE) {
  checkmate::assert_flag(condition)

  first_arg <- x
  second_arg <- y

  if (isTRUE(condition)) {
    x <- second_arg
    y <- first_arg
  }

  list(x = x, y = y)
}
