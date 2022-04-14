#' Get paths to `insert_package_name` raw data
#'
#' @description
#'
#' `r lifecycle::badge("experimental")`
#'
#' `raw_data_1()` returns the raw data paths of the `insert_package_name`
#' package.
#'
#' @param file (optional) a `character` object indicating the raw data file
#'   name(s). If `NULL`, all raw data file names will be returned (default:
#'   `NULL`).
#' @param package (optional) a string indicating the target package. If not
#'   assigned, the function will try to use the name of the active project
#'   directory (requires the `rstudioapi` package).
#'
#' @return If `file == NULL`, a [`character`][character()] object with all file
#'   names available. Else, a string with the file name path.
#'
#' @family R system functions
#' @export
#'
#' @examples
#' \dontrun{
#' ## To list all raw data file names available
#'
#' raw_data_1()
#'
#' ## To get the file path from a specific raw data
#'
#' raw_data_1(raw_data()[1])}
raw_data_1 <- function(file = NULL, package = "insert_package_name") {
    checkmate::assert_character(file, any.missing = FALSE, null.ok = TRUE)
    checkmate::assert_string(package, null.ok = TRUE)

    if (is.null(package)) package <- get_package_name()
    assert_namespace(package)

    if (is.null(file)) {
        list.files(find_path("extdata", package))
    } else {
        out <- file.path(find_path("extdata", package), file)
        checkmate::assert_file_exists(out)
        out
    }
}

#' Get paths to `insert_package_name` raw data
#'
#' @description
#'
#' `r lifecycle::badge("experimental")`
#'
#' `raw_data_2()` returns the raw data paths of the `insert_package_name`
#' package.
#'
#' @param type (optional) a string indicating the file type of the raw data
#'   (default: `NULL`).
#' @param file (optional) a `character` object indicating the file name(s) of
#'   the raw data (default: `NULL`).
#' @param package (optional) a string indicating the package with the database
#'   data. If `NULL`, the function will try to use the name of the active
#'   project directory (requires the `rstudioapi` package) (default:
#'   `insert_package_name`).
#'
#' @return
#'
#' * If `type = NULL`, a `character` object with all file type names
#'   available.
#' * If `type != NULL` and `file = NULL`, a `character` object with all file
#' names available from type.
#' * If `type != NULL` and `file != NULL`, a `character` with the file name(s)
#' path.
#'
#' @family R system functions
#' @export
#'
#' @examples
#' \dontrun{
#' raw_data_2()
#' }
raw_data_2 <- function(type = NULL, file = NULL,
                       package = "insert_package_name") {
    choices <- list.files(find_path("extdata", package))

    checkmate::assert_choice(type, choices, null.ok = TRUE)
    checkmate::assert_character(file, any.missing = FALSE, null.ok = TRUE)
    checkmate::assert_string(package, null.ok = TRUE)

    if (is.null(package)) package <- get_package_name()
    assert_namespace(package)

    if (is.null(file) && is.null(type)) {
        list.files(find_path("extdata", package))
    } else if (is.null(file) && !is.null(type)) {
        list.files(file.path(find_path("extdata", package), type))
    } else if (!is.null(file) && !is.null(type)) {
        out <- file.path(find_path("extdata", package), type, file)
        checkmate::assert_file_exists(out)
        out
    } else if (!is.null(file) & is.null(type)) {
        cli::cli_abort(paste0(
            "When {cli::col_blue('file')} is assigned the ",
            "{cli::col_red('type')} argument cannot be ",
            "{cli::col_silver('NULL')}."
        ))
    }
}
