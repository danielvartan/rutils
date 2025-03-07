# library(tools)

find_absolute_path <- function(relative_path) {
  require_pkg("tools")

  vapply(
    relative_path, tools::file_path_as_absolute, character(1),
    USE.NAMES = FALSE
  )
}
