# library(checkmate)
# library(here)

find_path <- function(dir, package = NULL) {
  checkmate::assert_string(dir)
  checkmate::assert_string(package, null.ok = TRUE)
  if (is.null(package)) package <- here::here() |> basename()

  root <- system.file(package = package)

  if (!stringr::str_detect(root, "inst/?$") &&
        any(stringr::str_detect("^inst$", list.files(root)), na.rm = TRUE)) {

    system.file(paste0("inst/", dir), package = package)
  } else {
    system.file(dir, package = package)
  }
}
