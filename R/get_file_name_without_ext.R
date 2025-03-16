#' Get file names without the extension
#'
#' @description
#' `get_file_name_without_ext()` returns file names without the extension
#' part.
#'
#' @param file A [`character`][base::character] vector with file paths.
#'
#' @return A [`character`][base::character] vector containing file names
#'   without the extension part.
#'
#' @family string functions
#' @export
#'
#' @examples
#' get_file_name_without_ext("example.txt")
#' #> [1] "example" # Expected
#'
#' get_file_name_without_ext("/path/to/file.tar.gz")
#' #> [1] "file.tar"  # Expected
#'
#' get_file_name_without_ext("no-extension")
#' #> [1] "no-extension" # Expected
#'
#' get_file_name_without_ext(c("data.csv", "data.rds"))
#' #> [1] "data" "data" # Expected
get_file_name_without_ext <- function(file) {
  checkmate::assert_character(file)

  ext <- get_file_ext(file)

  ifelse(
    is.na(ext),
    file |> basename(),
    file |>
      basename() |>
      stringr::str_replace(paste0("\\", ext, "$"), "")
  )
}
