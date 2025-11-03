# library(cli)
# library(stats)
# library(stringr)

#' Set the system locale to English (United States)
#'
#' @description
#'
#' `set_en_us_locale()` sets the system locale to English (United States)
#' trying to overcome OS-dependent differences in locale handling.
#'
#' @return An invisible `NULL`. This function is called for its side effects.
#'
#' @family system functions.
#' @export
#'
#' @examples
#' get_locale()
#'
#' set_en_us_locale()
#'
#' get_locale()
set_en_us_locale <- function() {
  locale_values <- c(
    "en_US.utf8", "en_US.UTF-8", "en_US", "en-US", "en",
    "English_United States"
  )

  # "LC_NAME", "LC_ADDRESS", "LC_TELEPHONE" == "invalid 'category' argument"

  locale_keys <-
    .LC.categories |>
    stringr::str_subset("LC_NUMERIC", negate = TRUE)

  env_keys <- c(
    .LC.categories[-1], "LC_NAME", "LC_ADDRESS", "LC_TELEPHONE",
    "LC_IDENTIFICATION"
  )

  # Sys.setlocale("LC_NUMERIC", "C")

  for (i in locale_values) {
    test <- Sys.setlocale(locale = i) |> suppressWarnings()

    if (!test == "" && Sys.getlocale("LC_TIME") == i) {
      for (j in locale_keys) {
        try(Sys.setlocale(j, i), silent = TRUE) |>
          suppressWarnings()
      }

      for (j in env_keys) do.call(Sys.setenv, as.list(stats::setNames(i, j)))
      Sys.setenv(LANG = "en")
      Sys.setenv(LANGUAGE = "en")

      break
    }
  }

  if (test == "" || !Sys.getlocale("LC_TIME") %in% locale_values) {
    cli::cli_alert_danger(
      paste0(
        "An error occurred while attempting to set the system locale to ",
        "English ({.strong Sys.setlocale(locale = 'en_US.utf8')})."
      ),
      wrap = TRUE
    )

    cat("\n")

    cli::cli_alert(
      paste0(
        "Errors related to locale values are likely caused by differences in ",
        "how operating systems handle locale settings."
      ),
      wrap = TRUE
    )
  }

  invisible()
}
