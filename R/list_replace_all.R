#' Replace matches in a list
#'
#' @description
#'
#' `r lifecycle::badge("experimental")`
#'
#' `list_replace_all()` replaces matches in [`atomic`][base::is.atomic] vectors
#' inside a list with a replacement value. If the list is nested, the function
#' will recursively apply the replacement to all nested lists.
#'
#' @details
#'
#' If there is a match, but the replacement value is not the same class as the
#' original value, the function will return the replacement value as is.
#'
#' If the replacement value is the same class as the original value, the
#' function will return a vector with the replacement value in the same
#' position as the match.
#'
#' @param list A [`list`][base::list] or [`pairlist`][base::pairlist] object.
#' @param pattern A [`character`][base::character] string containing a regular
#'   expression to be matched in the list.
#' @param replacement An [`atomic`][base::is.atomic] value to replace the
#'   matches with.
#'
#' @return A [`list`][base::list] with matches replaced with the replacement
#'   value.
#'
#' @family list functions.
#' @export
#'
#' @examples
#' list_replace_all(list(a = "", b = "b", c = list(d = "", e = "e")))
#' #> $a
#' #> NULL
#' #>
#' #> $b
#' #> [1] "b"
#' #>
#' #> $c
#' #> $c$d
#' #> NULL
#' #>
#' #> $c$e
#' #> [1] "e"
list_replace_all <- function(list, pattern = "^$", replacement = NULL) {
  # checkmate::assert_multi_class(list, c("list", "pairlist"))

  if (is.list(list)) {
    lapply(list, list_replace_all)
  } else if (is.atomic(list)) {
    if (any(grepl(pattern, list), na.rm = TRUE)) {
      if (!inherits(list, class(replacement)[1])) {
        replacement
      } else {
        vapply(
          X = list,
          FUN = \(x) if (grepl(pattern, x)) replacement else x,
          FUN.VALUE = vector(typeof(list), length(list))
        )
      }
    } else {
      list
    }
  } else {
    list
  }
}
