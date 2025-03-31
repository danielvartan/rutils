# library(here)
# library(prettycheck) # github.com/danielvartan/prettycheck
# library(stringr)

to_relative_path <- function(path, root = ".") {
  prettycheck:::assert_string(path)
  prettycheck:::assert_string(root)

  path <- stringr::str_remove(path, here::here())

  paste0(root, path)
}
