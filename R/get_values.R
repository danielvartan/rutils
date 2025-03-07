get_values <- function(...) {
  list(...) |>
    lapply(function(x) ifelse(is.null(x), "NULL", x)) |>
    unlist()
}
