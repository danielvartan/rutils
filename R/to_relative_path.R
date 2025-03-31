to_relative_path <- function(path, root = ".") {
  checkmate::assert_string(path)
  checkmate::assert_string(root)

  path <- stringr::str_remove(path, here::here())

  paste0(root, path)
}
