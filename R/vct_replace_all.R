#' Replace values in a vector
#'
#' @description
#'
#' `r lifecycle::badge("maturing")`
#'
#' `vct_replace_all()` replaces values in a vector with a specified value.
#'
#' @param x An [`atomic`][checkmate::test_atomic] vector.
#' @param replacement (Optional) A single value to replace the values in `x`
#'   (Default: `na_as(x)`).
#' @param except (Optional) A vector of values to exclude from replacement.
#' @param preserve_nas (Optional) A [`logical`][base::logical] flag to
#'   indicating if the function must preserve `NA` values in `x`
#'   (Default: `FALSE`).
#'
#' @return The same type of object in `x` with the values replaced.
#'
#' @family conditional functions
#' @export
#'
#' @examples
#' vct_replace_all(1:10)
#' #> [1] NA NA NA NA NA NA NA NA NA NA
#'
#' vct_replace_all(1:10, replacement = 0L, except = 5:7)
#' #> [1] 0 0 0 0 5 6 7 0 0 0
#'
#' vct_replace_all(c("a", "b", NA, "c"), replacement = "d", preserve_nas = TRUE)
#' #> [1] "d" "d" NA  "d"
vct_replace_all <- function(
    x, #nolint
    replacement = na_as(x),
    except = NULL,
    preserve_nas = FALSE
  ) {
  checkmate::assert_atomic(x)
  checkmate::assert_class(replacement, class(x)[1], null.ok = TRUE)
  if (!is.null(replacement)) prettycheck::assert_length(replacement, len = 1)
  checkmate::assert_class(except, class(x)[1], null.ok = TRUE)
  if (!is.null(except)) prettycheck::assert_length(except, min_len = 1)
  checkmate::assert_logical(preserve_nas)

  out <- NULL

  for (i in x) {
    if (i %in% except) {
      out <- c(out, i)
    } else if (is.na(i) && isTRUE(preserve_nas)) {
      out <- c(out, i)
    } else {
      out <- c(out, replacement)
    }
  }

  out
}
