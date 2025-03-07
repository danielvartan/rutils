# library(checkmate)

# Similar to `tools::file_ext()` but returns the file extension with the dot.
get_file_ext <- function(file_path) {
  checkmate::assert_string(file_path)

  file_path |>
    basename() |>
    stringr::str_extract("\\.[[:alnum:]]+$")
}
