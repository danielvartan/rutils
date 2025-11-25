# library(checkmate)
# library(dplyr)
# library(tidyr)

#' Convert a `list` to a `tibble` in long format
#'
#' @description
#'
#' `list_as_tibble()` converts a [`list`][base::list] to a
#' [`tibble`][tibble::tibble], pivoting it to long format.
#'
#' @param list A [`list`][base::list] to be converted.
#'
#' @return A [`tibble`][tibble::tibble] with two columns: `name` and `value`,
#'   where `name` corresponds to the original [`list`][base::list] element names
#'   and `value` to their respective values as [`character`][base::character]`
#'   strings.
#'
#' @family parsing/conversion functions.
#' @export
#'
#' @examples
#' list(a = 1, b = "a", c = TRUE) |>
#'   list_as_tibble()
list_as_tibble <- function(list) {
  checkmate::assert_list(list)

  list |>
    dplyr::as_tibble() |>
    dplyr::mutate(
      dplyr::across(
        .cols = dplyr::everything(),
        .fns = as.character
      )
    ) |>
    tidyr::pivot_longer(cols = dplyr::everything())
}
