# library(checkmate)

na_replace <- function(x, replacement = "") {
  checkmate::assert_atomic(x, min.len = 1)
  checkmate::assert_atomic(replacement, len = 1)
  checkmate::assert_class(replacement, class(x))

  x[which(is.na(x))] <- replacement

  x
}
