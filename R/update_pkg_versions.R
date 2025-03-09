#' Update package versions in the `DESCRIPTION` file
#'
#' @description
#'
#' `r lifecycle::badge("maturing")`
#'
#' `update_pkg_versions()` updates the version of packages listed in the
#' `DESCRIPTION` file of an R package with their installed versions.
#'
#' If the package comes with an typical installation of R (e.g., base, utils),
#' the function will update the version to the previous minor version of the
#' current R version. This is made to avoid errors with CI/CD.
#'
#' @param file (Optional) A string indicating the path to the `DESCRIPTION`
#'   file.
#' @param old_r_version (Optional) A string indicating the previous minor
#'   version of the current R version.
#'
#' @return An invisible `NULL`. This function is used for its side effect.
#'
#' @family R package functions
#' @export
update_pkg_versions <- function(
    file = here::here("DESCRIPTION"), #nolint
    old_r_version = bump_back_r_version()
  ) {
  checkmate::assert_string(file)
  checkmate::assert_file_exists(file)
  checkmate::assert_string(old_r_version, pattern = "^\\d\\.\\d$")

  # R CMD Check variable bindings fix (see: https://bit.ly/3z24hbU)
  Priority <- NULL #nolint

  lines <- readr::read_lines(file)

  installed_packages <- utils::installed.packages() |> dplyr::as_tibble()
  base_packages <- installed_packages |> dplyr::filter(Priority == "base")

  out <- character()

  for (i in lines) {
    if (stringr::str_detect(stringr::str_trim(i), "^[a-z0-9.]* \\(.+\\)")) {
      package <- stringr::str_extract(stringr::str_trim(i), "^[a-zA-Z0-9.]*")

      if (package %in% installed_packages$Package) {
        version <- stringr::str_extract(i, "(?<=\\().*(?=\\))")
        # complement <- stringr::str_extract(version, "^.* (?=[0-9.-])")

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
