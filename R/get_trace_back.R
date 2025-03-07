# library(magrittr)
# library(rlang)
# library(stringr)
# library(utils)

get_trace_back <- function() {
  rlang::trace_back() |>
    utils::capture.output() |>
    stringr::str_extract("(?<=\\u2514\\u2500).*(?=\\()") |>
    magrittr::inset(1, "Global Enviroment") |>
    remove_last()
}
