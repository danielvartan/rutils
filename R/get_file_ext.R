#' Get file extensions
#'
#' @description
#' `get_file_ext()` is similar to [`file_ext()`][tools::file_ext], the
#' difference is that it returns the file extension with the dot
#' separator (e.g., `.csv`).
#'
#' @param file A [`character`][base::character] vector with file paths.
#'
#' @return A [`character`][base::character] vector containing the file
#'   extension of the files.
#'
#' @family string functions
#' @export
#'
#' @examples
#' get_file_ext("example.txt")
#' #> [1] ".txt" # Expected
#'
#' get_file_ext("/path/to/file.tar.gz")
#' #> [1] ".gz"  # Expected
#'
#' get_file_ext("no-extension")
#' #> [1] NA # Expected
#'
#' get_file_ext(c("data.csv", "data.rds"))
#' #> [1] ".csv" ".rds" # Expected
get_file_ext <- function(file) {
  checkmate::assert_character(file)

  file |>
    basename() |>
    stringr::str_extract("\\.[[:alnum:]]+$")
}
