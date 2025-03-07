# library(checkmate)

secure_if <- function(x, fun, ...) {
  checkmate::assert_function(fun)

  if (is.null(x) || length(x) == 0) {
    FALSE
  } else {
    fun(x, ...)
  }
}
