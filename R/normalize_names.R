#' Normalize file names
#'
#' @description
#'
#' `r lifecycle::badge("maturing")`
#'
#' `normalize_names()` normalize file names to make them machine-readable.
#' It converts names to lowercase and replaces spaces and special characters
#' with hyphens.
#'
#' This function follows the naming conventions from the
#' [Tidyverse Style Guide](https://style.tidyverse.org/files.html#names).
#'
#' @param path (Optional) A [`character`][base::character] string indicating
#'   the files directory path. Defaults to clipboard content.
#' @param exceptions (Optional) A [`character`][base::character] vector of
#'   regex patterns for files to exclude from renaming.
#' @param just_dirs (Optional) A [`logical`][base::logical] flag indicating
#'   if only directory names should be normalized (Default: `FALSE`).
#'
#' @return An invisible `NULL`. This function is used for its side effect.
#'
#' @family file functions.
#' @export
#'
#' @examples
#' dir <- tempfile("")
#' dir.create(dir) |> invisible()
#'
#' file <- tempfile("Test - Test-", tmpdir = dir)
#' file.create(file) |> invisible()
#'
#' normalize_names(dir)
#'
#' list.files(dir)
#' #> [1] "test-test-***" # Expected
normalize_names <- function(
    path = clipr::read_clip(), # nolint
    exceptions = c(
      "^README", "^OFL.txt$", "^DESCRIPTION", "^Google README.txt$"
    ),
    just_dirs = FALSE
  ) {
  checkmate::assert_string(path)
  checkmate::assert_directory_exists(path)
  checkmate::assert_character(exceptions)
  checkmate::assert_flag(just_dirs)

  # R CMD Check variable bindings fix (see <https://bit.ly/3z24hbU>)
  # nolint start: object_usage_linter.
  . <- NULL
  # nolint end

  dirs <- path |> list.dirs()
  if (length(dirs) == 0) dirs <- path

  if (!length(dirs) == 0 && isTRUE(just_dirs)) {
    dirs <- dirs |> magrittr::extract(-1)

    new_dir_name <-
      dirs |>
      basename() |>
      tolower() |>
      stringr::str_replace_all(" - ", "-") |>
      stringr::str_replace_all("_", "-") |>
      stringr::str_replace_all(" ", "-") |>
      stringr::str_squish() %>%
      file.path(dirname(dirs), .)

    for (i in rev(seq_along(dirs))) {
      if (!dirs[i] == new_dir_name[i]) {
        paste(
          "mv",
          glue::single_quote(dirs[i]),
          glue::single_quote(new_dir_name[i])
        ) |>
          system()
      }
    }

    dirs <-
      path |>
      list.dirs() |>
      magrittr::extract(-1)
  } else {
    for (i in dirs) {
      files <- list.files(i)

      for (j in exceptions) {
        files <- files |> stringr::str_subset(j, negate = TRUE)
      }

      if (length(files) == 0) {
        next
      } else {
        new_name <-
          files |>
          tolower() |>
          stringr::str_replace_all(" - ", "_") |>
          stringr::str_replace_all("_", "-") |>
          stringr::str_replace_all(" ", "-") |>
          stringr::str_squish()

        file.rename(file.path(i, files), file.path(i, new_name))
      }
    }
  }

  invisible()
}
