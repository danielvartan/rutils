# Sort functions by type or use the alphabetical order.

inbetween_integers <- function(x, y) {
  checkmate::assert_number(x)
  checkmate::assert_number(y)

  lower_int <- min(x, y) |> floor()
  upper_int <- max(x, y) |> ceiling()

  setdiff(lower_int:upper_int, sort(c(x, y)))
}

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

args_names <- function(fun) {
  checkmate::assert_function(fun)

  # R CMD Check variable bindings fix (see: https://bit.ly/3z24hbU)
  # nolint start: object_usage_linter.
  . <- NULL
  # nolint end

  as.list(args(fun)) %>%
    `[`(-length(.)) |>
    names()
}

null_as_false <- function(x) {
  if (is.null(x)) {
    return(FALSE)
  } else {
    x
  }
}

empty_as_false <- function(x) {
  if (length(x) == 0) {
    return(FALSE)
  } else {
    x
  }
}

secure_if <- function(x, fun, ...) {
  checkmate::assert_function(fun)

  if (is.null(x) || length(x) == 0) {
    FALSE
  } else {
    fun(x, ...)
  }
}
