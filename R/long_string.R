long_string <- function(x) {
  checkmate::assert_string(x)

  x |>
    strwrap() |>
    paste0(collapse = " ") |>
    gsub(x = _, pattern = "\\s+", replacement = " ")
}
