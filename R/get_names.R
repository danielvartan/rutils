get_names <- function(...) {
  list(...) |>
    substitute() |>
    magrittr::extract(-1) |>
    lapply(deparse1) |>
    vapply(unlist, character(1))
}
