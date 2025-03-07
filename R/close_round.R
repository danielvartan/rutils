# library(checkmate)

close_round <- function(x, digits = 3) {
  checkmate::assert_numeric(x)
  checkmate::assert_number(digits)

  # nolint start: object_usage_linter.
  pattern_9 <- paste0("\\.", paste(rep(9, digits), collapse = ""))
  pattern_0 <- paste0("\\.", paste(rep(0, digits), collapse = ""))
  # nolint end

  dplyr::case_when(
    grepl(pattern_9, x) | grepl(pattern_0, x) ~ round(x),
    TRUE ~ x
  )
}
