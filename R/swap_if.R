#' Swap two values if a condition is met
#'
#' @description
#'
#' `r lifecycle::badge("stable")`
#'
#' `swap_if()` swaps two values if a condition is met.
#'
#' @param x Any type of R object.
#' @param y An R object of the same class and length as `x`.
#' @param condition A [`logical`][base::logical] flag indicating if the
#'   values should be swapped (Default: `TRUE`).
#'
#' @return A [`list`][base::list] with the swapped values.
#'
#' @family conditional functions
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
#'
#' swap_if(letters, LETTERS, c(rep(TRUE, 13), rep(FALSE, 13)))
#' #> $x
#' #>  [1] "A" "B" "C" "D" "E" "F" "G" "H" "I" "J" "K" "L" "M" "n"
#' #> [15] "o" "p" "q" "r" "s" "t" "u" "v" "w" "x" "y" "z"
#' #>
#' #> $y
#' #>  [1] "a" "b" "c" "d" "e" "f" "g" "h" "i" "j" "k" "l" "m" "N"
#' #> [15] "O" "P" "Q" "R" "S" "T" "U" "V" "W" "X" "Y" "Z"
swap_if <- function(x, y, condition = TRUE) {
  prettycheck::assert_identical(x, y, type = "class")
  prettycheck::assert_identical(x, y, condition, type = "length")
  checkmate::assert_logical(condition)

  if (!(class(x)[1] == class(y)[1])) {
    if (!(is.numeric(x) && is.numeric(y))) {
      cli::cli_abort(
        paste0(
          "{.strong {cli::col_red('x')}} and ",
          "{.strong {cli::col_red('y')}} must be of the same class."
        )
      )
    }
  }

  if (!all(
    length(x) == length(y) &&
      length(x) == length(condition) &&
      length(y) == length(condition),
    na.rm = TRUE
  )) {
    cli::cli_abort(
      paste0(
        "{.strong {cli::col_red('x')}}, ",
        "{.strong {cli::col_red('y')}} and, ",
        "{.strong {cli::col_red('condition')}} ",
        "must have the same length."
      )
    )
  }

  first_arg <- x
  second_arg <- y

  x <- dplyr::if_else(condition, second_arg, first_arg)
  y <- dplyr::if_else(condition, first_arg, second_arg)

  list(x = x, y = y)
}
