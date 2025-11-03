# library(cli)

#' Get the current locale settings
#'
#' @description
#'
#' `get_locale()` prints the current locale settings in system and local
#' environments.
#'
#' @return An invisible `NULL`. This function is called for its side effects.
#'
#' @family system functions.
#' @export
#'
#' @examples
#' get_locale()
get_locale <- function() {
  cli::cli_alert(
    paste0(
      "The current system locale is:\n\n",
      "{Sys.getlocale()}\n\n"
    ),
    wrap = TRUE
  )

  env_keys <- c(
    .LC.categories[-1], "LC_NAME", "LC_ADDRESS", "LC_TELEPHONE",
    "LC_IDENTIFICATION"
  )

  cat("\n")

  env_values <- character()

  for (i in env_keys) {
    env_values <- c(env_values, paste0(i, "=", Sys.getenv(i)))
  }

  env_values <- paste(env_values, collapse = ";")

  cli::cli_alert(
    paste0(
      "The current values for the locale environment variables are:\n\n",
      "{env_values}"
    ),
    wrap = TRUE
  )

  invisible()
}
