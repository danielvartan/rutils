# library(checkmate)

str_extract_ <- function(string, pattern, ignore_case = FALSE, perl = TRUE,
                         fixed = FALSE, use_bytes = FALSE, invert = FALSE) {
  checkmate::assert_string(pattern)
  checkmate::assert_flag(ignore_case)
  checkmate::assert_flag(perl)
  checkmate::assert_flag(fixed)
  checkmate::assert_flag(use_bytes)
  checkmate::assert_flag(invert)

  match <- regexpr(pattern, string, ignore.case = ignore_case, perl = perl,
                   fixed = fixed, useBytes = use_bytes)
  out <- rep(NA, length(string))
  out[match != -1 & !is.na(match)] <- regmatches(string, match,
                                                 invert = invert)
  out
}
