# library(checkmate)

escape_regex <- function(x) {
  checkmate::assert_atomic(x)

  gsub("([.|()\\^{}+$*?]|\\[|\\])", "\\\\\\1", x)
}
