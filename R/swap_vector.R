#' Swap values in a vector
#'
#' @description
#'
#' `r lifecycle::badge("maturing")`
#'
#' `swap_vector()` swaps values in a vector with a specified value.
#'
#' @param x An [`atomic`][checkmate::test_atomic] vector.
#' @param swap (Optional) A single value to swap the values in `x`
#'   (Default: `na_as(x)`).
#' @param except (Optional) A vector of values to exclude from swapping.
#' @param preserve_nas (Optional) A [`logical`][base::logical] flag to
#'   indicating if the function must preserve `NA` values in `x`
#'   (Default: `FALSE`).
#'
#' @return The same type of object in `x` with swapped values.
#'
#' @family conditional functions
#' @export
#'
#' @examples
#' swap_vector(1:10)
#' #> [1] NA NA NA NA NA NA NA NA NA NA
#'
#' swap_vector(1:10, swap = 0L, except = 5:7)
#' #> [1] 0 0 0 0 5 6 7 0 0 0
#'
#' swap_vector(c("a", "b", NA, "c"), swap = "d", preserve_nas = TRUE)
#' #> [1] "d" "d" NA  "d"
swap_vector <- function(
    x, #nolint
    swap = na_as(x),
    except = NULL,
    preserve_nas = FALSE
  ) {
  checkmate::assert_atomic(x)
  checkmate::assert_class(swap, class(x)[1], null.ok = TRUE)
  # if (!is.null(swap)) prettycheck::assert_length(swap, len = 1)
  checkmate::assert_class(except, class(x)[1], null.ok = TRUE)
  # if (!is.null(except)) prettycheck::assert_length(except, min_len = 1)
  checkmate::assert_logical(preserve_nas)

  out <- NULL

  for (i in x) {
    if (i %in% except) {
      out <- c(out, i)
    } else if (is.na(i) && isTRUE(preserve_nas)) {
      out <- c(out, i)
    } else {
      out <- c(out, swap)
    }
  }

  out
}
