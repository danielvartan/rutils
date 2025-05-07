# library(checkmate)

inline_collapse <- function(
  x,
  last = "and",
  single_quote = TRUE,
  serial_comma = TRUE
) {
  checkmate::assert_string(last)
  checkmate::assert_flag(single_quote)
  checkmate::assert_flag(serial_comma)

  if (isTRUE(single_quote)) x <- single_quote_(x)

  if (length(x) <= 2 || isFALSE(serial_comma)) {
    paste_collapse(x, sep = ", ", last = paste0(" ", last, " "))
  } else {
    paste_collapse(x, sep = ", ", last = paste0(", ", last, " "))
  }
}
