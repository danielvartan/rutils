#' Extract initials from a character vector
#'
#' @description
#'
#' `r lifecycle::badge("stable")`
#'
#' `extract_initials()` extracts the initials of names in a character
#' vector.
#'
#' @param x A [`character`][base::character] vector with names.
#' @param sep A [`character`][base::character] string to separate initials
#'   (Default: ". ").
#'
#' @return A [`character`][base::character] vector with the initials of
#'   names in `x`.
#'
#' @family string functions.
#' @export
#'
#' @examples
#' extract_initials(c("John Doe", "Jane Doe", "John Smith"))
#' #> [1] "J. D." "J. D." "J. S." # Expected
#'
#' extract_initials(c("John Doe", "Jane Doe", "John Smith"), sep = ".")
#' #> [1] "J.D." "J.D." "J.S." # Expected
extract_initials <- function(x, sep = ". ") {
  checkmate::assert_character(x)

  ifelse(
    grepl(" ", x),
    gsub("(?<=[A-Z])[^A-Z]+", sep, x, perl = TRUE) |> trimws(),
    stringr::str_sub(x, 1, 1)
  )
}
