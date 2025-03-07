# library(checkmate, quietly = TRUE)
# library(cli, quietly = TRUE)

delete_dir <- function(...) {
  checkmate::assert_character(unlist(list(...)))
  checkmate::assert_directory_exists(unlist(list(...)))

  dir <- unlist(list(...))
  status <- unlink(dir, recursive = TRUE) |> shush()

  for (i in seq_along(status)) {
    if (status[i] == 1) {
      cli::cli_alert_warning(paste0(
        "The attempt to remove the directory ",
        "{.strong {cli::col_red(dir[i])}} ",
        "was unsuccessful."
      ))
    }
  }

  invisible()
}
