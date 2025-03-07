# library(checkmate, quietly = TRUE)
# library(cli, quietly = TRUE)

copy_file <- function(
    from, #nolint
    to,
    overwrite = TRUE,
    recursive = FALSE,
    copy_mode = TRUE,
    copy_date = FALSE
  ) {
  checkmate::assert_character(from)
  checkmate::assert_file_exists(from)
  checkmate::assert_character(to)
  checkmate::assert_flag(overwrite)
  checkmate::assert_flag(recursive)
  checkmate::assert_flag(copy_mode)
  checkmate::assert_flag(copy_date)

  status <- file.copy(
    from,
    to,
    overwrite = overwrite,
    recursive = recursive,
    copy.mode = copy_mode,
    copy.date = copy_date
  ) |>
    shush()

  for (i in seq_along(status)) {
    if (isFALSE(status[i])) {
      cli::cli_alert_warning(paste0(
        "The attempt to copy the file ",
        "{.strong {cli::col_blue(from[i])}} to ",
        "{.strong {cli::col_red(to[i])}} ",
        "was unsuccessful."
      ))
    }
  }

  invisible()
}
