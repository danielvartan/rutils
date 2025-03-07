# library(checkmate, quietly = TRUE)
# library(cli, quietly = TRUE)

create_file <- function(file) {
  checkmate::assert_character(file)

  for (i in file) {
    checkmate::assert_directory_exists(dirname(i))
  }

  for (i in file) {
    if (checkmate::test_file_exists(i)) {
      cli::cli_alert_warning(
        paste0(
          "The file ",
          "{.strong {cli::col_red(i)}} ",
          "already exists."
        )
      )

      file <- file[!file == i]
    }
  }

  status <- file.create(file, showWarnings = FALSE) |> shush()

  for (i in seq_along(status)) {
    if (isFALSE(status[i])) {
      cli::cli_alert_warning(
        paste0(
          "The attempt to create the file ",
          "{.strong {cli::col_red(file[i])}} ",
          "was unsuccessful."
        )
      )
    }
  }

  invisible()
}
