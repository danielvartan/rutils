empty_as_false <- function(x) {
  if (!length(x) == 0) {
    x
  } else {
    FALSE
  }
}
