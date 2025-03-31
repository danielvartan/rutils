# Based on: https://stackoverflow.com/a/61354463/8258804
mode <- function(x) {
  checkmate::assert_atomic(x)

  # R CMD Check variable bindings fix
  # nolint start
  n <- NULL
  # nolint end

  out <-
    dplyr::tibble(x = x) |>
    dplyr::count(x) |>
    dplyr::arrange(dplyr::desc(n))

  if (out$n[1] == 1 || is.na(out$n[1]) || out$n[1] == out$n[2]) {
    methods::as(NA, class(x)[1])
  } else {
    out$x[1]
  }
}
