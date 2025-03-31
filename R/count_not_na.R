count_not_na <- function(x) {
  checkmate::assert_atomic(x)

  length(which(!is.na(x)))
}
