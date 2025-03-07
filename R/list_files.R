# library(checkmate, quietly = TRUE)

list_files <- function(
    path = ".", #nolint
    full.names = FALSE, #nolint
    recursive = FALSE,
    ...
  ) {
  checkmate::assert_string(path)
  checkmate::assert_directory_exists(path)
  checkmate::assert_flag(full.names)
  checkmate::assert_flag(recursive)

  setdiff(
    list.files(
      path = path,
      full.names = full.names,
      recursive = recursive,
      ...
    ),
    list.dirs(
      path = path,
      full.names = full.names,
      recursive = recursive
    )
  )
}
