# library(checkmateE)
# library(cli)

rename_file <- function(from, to) {
  checkmate::assert_character(from)
  checkmate::assert_file_exists(from)

  status <- file.rename(from, to) |> shush()

  for (i in seq_along(status)) {
    if (isFALSE(status[i])) {
      cli::cli_alert_warning(paste0(
        "The attempt to rename the file ",
        "{.strong {cli::col_blue(from[i])}} to ",
        "{.strong {cli::col_red(to[i])}} ",
        "was unsuccessful."
      ))
    }
  }

  invisible()
}
