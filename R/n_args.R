# library(checkmate)

n_args <- function(fun) {
  checkmate::assert_function(fun)

  # R CMD Check variable bindings fix
  # nolint start
  . <- NULL
  # nolint end

  as.list(args(fun)) %>%
    `[`(-length(.)) |>
    names() |>
    length()
}
