null_as_false <- function(x) {
  if (!is.null(x)) {
    x
  } else {
    FALSE
  }
}
