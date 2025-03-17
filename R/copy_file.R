#' Copy files recursively
#'
#' @description
#'
#' `r lifecycle::badge("stable")`
#'
#' `file_copy()` is an alternative for [`file_copy()`][fs::file_copy] from the
#' [`fs`][fs] package. The main difference is that it can copy files
#' recursively.
#'
#' @param from A [`character`][base::character] vector of paths to the files
#'   to be copied.
#' @param to A [`character`][base::character] vector of paths indicating
#'   the destination of the files to be copied.
#' @param overwrite (Optional) A [`logical`][base::logical] flag indicating
#'   whether existing files should be overwritten.
#' @param recursive (Optional) A [`logical`][base::logical] flag indicating
#'   whether directories should be copied recursively.
#' @param ... (Optional) Additional arguments to be passed to
#'   [`file.copy()`][base::file.copy].
#'
#' @return An invisible `NULL`. This function is used for its side effect.
#'
#' @family file functions.
#' @noRd
#'
#' @examples
#' dir_1 <- tempfile("test-dir-1")
#' dir.create(dir_1) |> invisible()
#'
#' file <- tempfile("test", tmpdir = dir_1)
#' file.create(file) |> invisible()
#'
#' dir_2 <- tempfile("test-dir-2")
#'
#' file_copy(
#'   from = file,
#'   to = file.path(file.path(dir_2, basename(file))),
#'   overwrite = TRUE,
#'   recursive = TRUE
#' )
#'
#' list.files(dir_2)
file_copy <- function(
    from, #nolint
    to,
    overwrite = TRUE,
    recursive = FALSE,
    ...
  ) {
  checkmate::assert_character(from)
  checkmate::assert_file_exists(from)
  checkmate::assert_character(to)
  checkmate::assert_flag(overwrite)
  checkmate::assert_flag(recursive)

  status <- file.copy(
    from,
    to,
    overwrite = overwrite,
    recursive = recursive,
    ...
  ) |>
    shush()

  for (i in seq_along(status)) {
    if (isFALSE(status[i])) {
      cli::cli_alert_warning(paste0(
        "The attempt to copy the file ",
        "{.strong {cli::col_red(from[i])}} to ",
        "{.strong {cli::col_blue(to[i])}} ",
        "was unsuccessful."
      ))
    }
  }

  invisible()
}
