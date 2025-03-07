# library(checkmate)

rm_pattern <- function(x, pattern, ignore_case = TRUE) {
  checkmate::assert_atomic(x)
  checkmate::assert_string(pattern)
  checkmate::assert_flag(ignore_case)

  x[!grepl(pattern, x, ignore.case = ignore_case)]
}
