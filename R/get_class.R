get_class <- function(x) {
  if (is.list(x)) {
    vapply(x, function(x) class(x)[1], character(1))
  } else {
    class(x)[1]
  }
}
