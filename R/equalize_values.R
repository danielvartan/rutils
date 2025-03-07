equalize_values <- function(x, y) {
  x <- eval(x)
  y <- eval(y)

  if (!is.null(x) && is.null(y)) {
    x
  } else if (is.null(x) && !is.null(y)) {
    y
  } else {
    x
  }
}
