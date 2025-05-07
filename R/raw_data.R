#' Get paths to `[INSERT PACKAGE NAME]` raw data
#'
#' @description
#'
#' `raw_data_1()` returns the raw data paths of the `[INSERT PACKAGE NAME]`
#' package.
#'
#' @param file (optional) A [`character`][base::character] vector indicating
#'   the file name(s) of the raw data. If `NULL`, all raw data file names will
#'   be returned (Default: `NULL`).
#' @param package (optional) A [`character`][base::character] string indicating
#'   the package with the database data. If `NULL`, the function will try to
#'   use the basename of the working directory (Default: `NULL`).
#'
#' @return If `file == NULL`, a [`character`][character()] vector with all file
#'   names available. Else, a string with the file name path.
#'
#' @family R package functions
#' @keywords internal
#' @export
#'
#' @examples
#' if (interactive()) {
#' ## To list all raw data file names available
#'
#'   raw_data_1()
#'
#' ## To get the file path from a specific raw data
#'
#'   raw_data_1(raw_data()[1])
#' }
raw_data_1 <- function(file = NULL, package = NULL) {
  checkmate::assert_character(file, any.missing = FALSE, null.ok = TRUE)
  checkmate::assert_string(package, null.ok = TRUE)
  if (is.null(package)) package <- here::here() |> basename()
  # assert_namespace(package)

  if (is.null(file)) {
    list.files(find_path("extdata", package))
  } else {
    out <- file.path(find_path("extdata", package), file)
    checkmate::assert_file_exists(out)
    out
  }
}

#' Get paths to `[INSERT PACKAGE NAME]` raw data
#'
#' @description
#'
#' `raw_data_2()` returns the raw data paths of the `[INSERT PACKAGE NAME]`
#' package.
#'
#' @param type (optional) A [`character`][base::character] string indicating
#'   the file type of the raw data (Default: `NULL`).
#' @param file (optional) A [`character`][base::character] vector indicating
#'   the file name(s) of the raw data (Default: `NULL`).
#'
#' @return
#'
#' - If `type = NULL`, a `character` vector with all file type names
#'   available.
#' - If `type != NULL` and `file = NULL`, a `character` vector with all file
#' names available from type.
#' - If `type != NULL` and `file != NULL`, a `character` vector with the file
#' name(s) path.
#'
#' @inheritParams raw_data_1
#' @family R package functions
#' @keywords internal
#' @export
#'
#' @examples
#' if (interactive()) {
#'   raw_data_2()
#' }
raw_data_2 <- function(type = NULL, file = NULL, package = NULL) {
  choices <- list.files(find_path("extdata", package))

  checkmate::assert_choice(type, choices, null.ok = TRUE)
  checkmate::assert_character(file, any.missing = FALSE, null.ok = TRUE)
  checkmate::assert_string(package, null.ok = TRUE)
  if (is.null(package)) package <- here::here() |> basename()
  # assert_namespace(package)

  if (is.null(file) && is.null(type)) {
    list.files(find_path("extdata", package))
  } else if (is.null(file) && !is.null(type)) {
    list.files(file.path(find_path("extdata", package), type))
  } else if (!is.null(file) && !is.null(type)) {
    out <- file.path(find_path("extdata", package), type, file)
    checkmate::assert_file_exists(out)
    out
  } else if (!is.null(file) && is.null(type)) {
    cli::cli_abort(paste0(
      "When {cli::col_blue('file')} is assigned the ",
      "{cli::col_red('type')} argument cannot be ",
      "{cli::col_silver('NULL')}."
    ))
  }
}
