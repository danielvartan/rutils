get_trace_back <- function() {
  out <-
    rlang::trace_back() |>
    utils::capture.output() |>
    stringr::str_extract("(?<=\\u2514\\u2500).*(?=\\()") |>
    magrittr::inset(1, "Global Enviroment")

  out[-length(out)]
}
