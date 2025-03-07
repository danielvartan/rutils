# library(magrittr)
# library(rlang)

get_fun_name <- function() {
  rlang::caller_call() |>
    as.character() |>
    magrittr::extract(1)
}
