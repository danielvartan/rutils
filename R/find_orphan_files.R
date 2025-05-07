#' Find orphan files in a Zotero library
#'
#' @description
#'
#' `find_orphan_files()` compares the files present in a specified folder
#' with those linked to references in a Zotero library, returning the names
#' of files that are not linked (i.e., orphan files).
#'
#' @details
#'
#' To export your library from Zotero, go to the menu `File > Export Library...`
#' and choose the **CSV** format.
#'
#' @param lib_file (optional) A string specifying the path to the Zotero library
#'   exported as a **CSV** file.
#'   (default: [`tk_choose.files()`][tcltk::tk_choose.files()]).
#' @param file_folder (optional) A string specifying the path to the folder
#'   containing the files linked to references in the Zotero library.
#'   (default: [`tk_choose.dir()`][tcltk::tk_choose.dir()]).
#'
#' @return A [`character`][base::as.character] vector with the names of the
#'   orphan files.
#'
#' @family Zotero functions
#' @export
#'
#' @examples
#' \dontrun{
#'   find_orphan_files()
#' }
find_orphan_files <- function(
  lib_file = tcltk::tk_choose.files(
    caption = "Select the Zotero library CSV file",
    multi = FALSE
  ),
  file_folder = tcltk::tk_choose.dir(
    caption = "Select the folder containing the files"
  )
) {
  checkmate::assert_file_exists(lib_file, access = "r")
  checkmate::assert_directory_exists(file_folder, access = "rw")

  linked_files <- list_linked_files(lib_file, basename = TRUE)
  real_files <- list.files(file_folder) |> basename()

  real_files[!real_files %in% linked_files]
}
