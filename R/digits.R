digits <- function(x, left = FALSE, right = FALSE) {
  checkmate::assert_numeric(x)
  checkmate::assert_flag(left)
  checkmate::assert_flag(right)

  if (isTRUE(left)) {
    left_digits(x)
  } else if (isTRUE(right)) {
    right_digits(x)
  } else {
    left_digits(x) + right_digits(x)
  }
}

left_digits <- function(x, count_zero = TRUE) {
  checkmate::assert_numeric(x)
  checkmate::assert_flag(count_zero)

  out <-
    x |>
    abs() |>
    trunc()

  if (out == 0) {
    ifelse(isTRUE(count_zero), 1, 0)
  } else {
    out |> nchar()
  }
}

right_digits <- function(x, max_digits = 15) {
  checkmate::assert_numeric(x)
  checkmate::assert_int(max_digits, lower = 1, upper = 15)

  digit_options <- getOption("digits")
  options(digits = max_digits)

  out <- vapply(
    x,
    function(x) {
      if (is.na(x)) {
        NA_real_
      } else {
        if (abs(x - round(x)) > .Machine$double.eps^0.5) {
          x |>
            format() |>
            strsplit("\\.") |>
            magrittr::extract2(1) |>
            magrittr::extract(2) |>
            nchar()
        } else {
          0
        }
      }
    },
    FUN.VALUE = numeric(1)
  )

  options(digits = digit_options)
  out
}
