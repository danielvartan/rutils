# library(checkmate)

n_args <- function(fun) {
  checkmate::assert_function(fun)

  # R CMD Check variable bindings fix (see: https://bit.ly/3z24hbU)
  # nolint start: object_usage_linter.
  . <- NULL
  # nolint end

  as.list(args(fun)) %>%
    `[`(-length(.)) |>
    names() |>
    length()
}
