inverse_log_max <- function(x, base = exp(1)) {
  prettycheck::assert_numeric(x)
  checkmate::assert_number(base)

  # R CMD Check variable bindings fix
  # nolint start
  . <- NULL
  # nolint end

  x |>
    log(base) |>
    max(na.rm = TRUE) |>
    ceiling() %>% # Don't change the pipe!
    `^`(base, .)
}
