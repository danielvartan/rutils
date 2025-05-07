#' List all files linked to a reference in a Zotero library
#'
#' @description
#'
#' `list_linked_files()` reads a CSV file exported from Zotero and extracts the
#' file paths of all attachments linked to the references in the library.
#'
#' @details
#'
#' To export your library from Zotero, go to the menu `File > Export Library...`
#' and choose the **CSV** format.
#'
#' @param lib_file (optional) A string specifying the path to the Zotero library
#'   exported as a **CSV** file.
#'   (default: [`tk_choose.files()``][tcltk::tk_choose.files()]).
#' @param basename (optional) A [`logical`][base::logical()] flag indicating
#'   if the function should return the full path to the files or only the file
#'   names (default: `TRUE`).
#'
#' @return A [`character`][base::as.character] vector with the names of the
#'  files linked to the references in the Zotero library.
#'
#' @family Zotero functions
#' @export
#'
#' @examples
#' \dontrun{
#'   list_linked_files()
#' }
list_linked_files <- function(
  lib_file = tcltk::tk_choose.files(
    caption = "Select Zotero library CSV file",
    multi = FALSE
  ),
  basename = TRUE
) {
  checkmate::assert_file_exists(lib_file, access = "r")
  checkmate::assert_flag(basename)

  out <-
    lib_file |>
    readr::read_csv(col_types = readr::cols(.default = "c")) |>
    magrittr::extract2("File Attachments") |>
    stringr::str_split("; (?=[A-Z]:)") |>
    unlist() |>
    stringr::str_squish() |>
    stringr::str_remove("[^A-Za-z0-9]$") |>
    purrr::discard(is.na)

  if (isTRUE(basename)) {
    basename(out)
  } else {
    out
  }
}
