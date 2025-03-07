# library(checkmate)

str_subset_ <- function(string, pattern, negate = FALSE, ignore_case = FALSE,
                        perl = TRUE, fixed = FALSE, use_bytes = FALSE) {
  checkmate::assert_string(pattern)
  checkmate::assert_flag(negate)
  checkmate::assert_flag(ignore_case)
  checkmate::assert_flag(perl)
  checkmate::assert_flag(fixed)
  checkmate::assert_flag(use_bytes)

  match <- grepl(pattern, string, ignore.case = ignore_case, perl = perl,
                 fixed = fixed, useBytes = use_bytes)

  if (isTRUE(negate)) {
    out <- subset(string, !match)
  } else {
    out <- subset(string, match)
  }

  if (length(out) == 0) as.character(NA) else out
}
