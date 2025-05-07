#' Compute the interval means of a cut factor
#'
#' @description
#'
#' `cut_interval_mean()` computes the interval means of a [`cut`][base::cut]
#' factor, regardless of the their open or closed nature.
#'
#' @param x A [`factor`][base::factor] or [`character`][base::character] vector
#'   with [`cut`][base::cut] intervals.
#' @param round A [`logical`][base::logical] flag indicating whether to round
#'   the means to `0`` decimal places (Default: `FALSE`).
#' @param names A [`logical`][base::logical] flag indicating whether to name
#'   the output vector with the original intervals (Default: `FALSE`).
#'
#' @return A [`numeric`][base::numeric] vector with the interval means.
#'
#' @family statistical functions
#' @export
#'
#' @examples
#' cut(1:5, breaks = 3)
#' #> [1] (0.996,2.33] (0.996,2.33] (2.33,3.67]  (3.67,5] # Expected
#' #> [5] (3.67,5]
#' #> Levels: (0.996,2.33] (2.33,3.67] (3.67,5]
#'
#' cut(1:5, breaks = 3) |> cut_interval_mean()
#' #> [1] 1.663 1.663 3.000 4.335 4.335 # Expected
#'
#' cut(1:5, breaks = 3) |> cut_interval_mean(names = TRUE)
#' #> # Expected
#' #> (0.996,2.33] (0.996,2.33]  (2.33,3.67]     (3.67,5]     (3.67,5]
#' #>       1.663        1.663        3.000        4.335        4.335
#'
#' cut(1:5, breaks = 3) |> cut_interval_mean(round = TRUE)
#' #> [1] 2 2 3 4 4 # Expected
cut_interval_mean <- function(x, round = FALSE, names = FALSE) {
  checkmate::assert_multi_class(x, c("character", "factor"))
  checkmate::assert_character(as.character(x), pattern = "^\\[|^\\(")
  checkmate::assert_flag(round)
  checkmate::assert_flag(names)

  if (is.factor(x)) x <- as.character(x)

  out <-
    x |>
    stringr::str_remove_all("\\(|\\[|\\)|\\]") |>
    stringr::str_split(",") |>
    lapply(as.numeric) |>
    lapply(mean) |>
    unlist()

  if (isTRUE(round)) out <- round(out)
  if (isTRUE(names)) names(out) <- x

  out
}
