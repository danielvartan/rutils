drop_inf <- function(x) {
  checkmate::assert_atomic(x)

  x[!(x == -Inf | x == Inf)]
}
