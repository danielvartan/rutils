change_sign <- function(x, flag = TRUE) {
  prettycheck::assert_numeric(x)
  checkmate::assert_flag(flag)

  if (isTRUE(flag)) {
    x * (-1)
  } else {
    x
  }
}
