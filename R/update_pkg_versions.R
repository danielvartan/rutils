#' Update package versions in DESCRIPTION file
#'
#' @description
#'
#' `update_pkg_versions()` updates the version of the packages in the
#' `DESCRIPTION` file of R packages with their current version.
#'
#' If the package is an R base package, the function will update the version to
#' the previous minor version of the current R version. This is made to avoid
#' errors with CI/CD.
#'
#' @param file (optional) A string indicating the path to the `DESCRIPTION` file
#'   (default: `here::here("DESCRIPTION")`).
#' @param old_r_version (optional) A string indicating the previous minor
#'   version of the current R version (default: `bump_back_r_version()`).
#'
#' @return An invisible `NULL`. This function is used for its side effect.
#'
#' @family R system functions
#' @export
update_pkg_versions <- function(
    file = here::here("DESCRIPTION"),
    old_r_version = bump_back_r_version()
  ) {
  checkmate::assert_string(file)
  checkmate::assert_file_exists(file)
  checkmate::assert_string(old_r_version, pattern = "^\\d\\.\\d$")

  # R CMD Check variable bindings fix (see: https://bit.ly/3z24hbU)
  # nolint start: object_usage_linter.
  Priority <- NULL
  # nolint end

  lines <- readr::read_lines(file)

  installed_packages <- utils::installed.packages() |> dplyr::as_tibble()
  base_packages <- installed_packages |> dplyr::filter(Priority == "base")

  out <- character()

  for (i in lines) {
    if (stringr::str_detect(stringr::str_trim(i), "^[a-z0-9.]* \\(.+\\)")) {
      package <- stringr::str_extract(stringr::str_trim(i), "^[a-zA-Z0-9.]*")

      if (package %in% installed_packages$Package) {
        version <- stringr::str_extract(i, "(?<=\\().*(?=\\))")
        complement <- stringr::str_extract(version, "^.* (?=[0-9.-])")

        if (package %in% base_packages$Package) {
          version <- stringr::str_replace(version, "[0-9.-]+$", old_r_version)
        } else {
          version <- stringr::str_replace(
            version,
            "[0-9.-]+$",
            as.character(utils::packageVersion(package))
          )
        }

        out <- append(
          out,
          stringr::str_replace(
            i,
            "\\(.*\\)",
            paste0("(", version, ")")
          )
        )
      } else {
        out <- append(out, i)
      }
    } else {
      out <- append(out, i)
    }
  }

  readr::write_lines(out, file)

  invisible()
}

bump_back_r_version <- function() {
  version <- stringr::str_remove(as.character(getRversion()), ".[0-9]$")
  major <- as.numeric(stringr::str_extract(version, "^[0-9]"))
  minor <- as.numeric(stringr::str_extract(version, "[0-9]$"))

  if (minor == 0) {
    cli::cli_abort(
      "The current R version is a major release. ",
      "`bump_back_r_version()` can bump back only minor releases."
    )
  } else {
    minor <- minor - 1
  }

  paste0(major, ".", minor)
}
