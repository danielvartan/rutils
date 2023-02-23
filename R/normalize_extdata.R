#' Normalize file names from the `extdata` folder
#'
#' @description
#'
#' `r lifecycle::badge("experimental")`
#'
#' `normalize_extdata()` normalize file names founded in the `./inst/extdata/`
#' folder of a package. __This function must be used only with
#' [RStudio](https://posit.co/products/open-source/rstudio/) IDE__.
#'
#' The function lowercase the names, substitute `" - "` characters for `"_"`,
#' and substitute `" "` characters for `"-"`.
#'
#' @param package (optional) a string indicating the target package. If not
#'   assigned, the function will try to use the name of the active project
#'   directory (requires the `rstudioapi` package).
#'
#' @family R system functions
#' @export
#'
#' @examples
#' \dontrun{
#' normalize_extdata()}
normalize_extdata <- function(package = NULL) {
    if (is.null(package)) package <- get_package_name()
    assert_namespace(package)

    extdata <- system.file("inst/extdata", package = package)
    path <- list.dirs(extdata)

    for (i in path) {
        i <- paste0(i, "/")

        if (length(list.files(i)) == 0) {
            next
        } else {
            new_name <- tolower(list.files(i))
            new_name <- stringr::str_replace_all(new_name, " - ", "_")
            new_name <- stringr::str_replace_all(new_name, " ", "-")
            file.rename(paste0(i, list.files(i)), paste0(i, new_name))
        }
    }

    invisible(NULL)
}
