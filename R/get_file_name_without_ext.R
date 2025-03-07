# library(checkmate)

get_file_name_without_ext <- function(file_path) {
  checkmate::assert_string(file_path)

  ext <- get_file_ext(file_path)

  if (is.na(ext)) {
    file_path |> basename()
  } else {
    file_path |>
      basename() |>
      stringr::str_replace(paste0("\\", ext, "$"), "")
  }
}
