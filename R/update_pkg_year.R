#' Update the year in system files of a package
#'
#' @description
#'
#' `update_pkg_year()` updates the year in system files of a package.
#'
#' @param file (optional) A [`character`][base::character] vector indicating
#'   the path of the files that must be updated. Default to `LICENSE`,
#'   `LICENSE.md`, and `inst/CITATION`.
#'
#' @return An invisible `NULL`. This function is used for its side effect.
#'
#' @family R package functions
#' @export
update_pkg_year <- function(
  file = c(
    here::here("LICENSE"),
    here::here("LICENSE.md"),
    here::here("inst", "CITATION")
  )
) {
  checkmate::assert_character(file, any.missing = FALSE)
  checkmate::assert_file_exists(file)

  for (i in file) {
    data <-
      i |>
      readr::read_lines() |>
      stringr::str_replace_all(
        pattern = "20\\d{2}",
        replacement = as.character(Sys.Date() |> lubridate::year())
      )

    data |> readr::write_lines(i)
  }

  invisible()
}
