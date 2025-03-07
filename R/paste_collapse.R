# library(checkmate)

paste_collapse <- function(x, sep = "", last = sep) {
  checkmate::assert_string(sep)
  checkmate::assert_string(last)

  if (length(x) == 1) {
    x
  } else {
    paste0(paste(x[-length(x)], collapse = sep), last, x[length(x)])
  }
}
