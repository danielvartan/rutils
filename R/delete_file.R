# library(checkmate, quietly = TRUE)
# library(cli, quietly = TRUE)

delete_file <- function(...) {
  checkmate::assert_character(unlist(list(...)))
  checkmate::assert_file_exists(unlist(list(...)))

  file <- unlist(list(...)) #nolint
  status <- suppressWarnings(file.remove(...)) |> shush()

  for (i in seq_along(status)) {
    if (isFALSE(status[i])) {
      cli::cli_alert_warning(paste0(
        "The attempt to remove the file ",
        "{.strong {cli::col_red(file[i])}} ",
        "was unsuccessful."
      ))
    }
  }

  invisible()
}
