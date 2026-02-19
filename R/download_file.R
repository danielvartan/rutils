#' Download files
#'
#' @description
#'
#' `download_file()` is a wrapper around the `httr2` package that provides a
#' user-friendly interface for downloading files, with built-in error handling
#' and progress reporting.
#'
#' @param url A [`character`][base::character()] vector of URLs pointing to
#'   remote files.
#' @param connection_timeout (optional) A [`numeric`][base::numeric()] value
#'   specifying the connection timeout in seconds for HTTP requests
#'   (default: `10`).
#' @param max_tries (optional) A [`numeric`][base::numeric()] value specifying
#'   the maximum number of retry attempts (default: `3`).
#' @param retry_on_failure (optional) A [`logical`][base::logical()] value
#'   indicating whether to retry on failure (default: `TRUE`).
#' @param backoff (optional) A [`function`][base::function()] that takes the
#'   current attempt number as input and returns the number of seconds to wait
#'   before the next attempt (default: `\(attempt) 5^attempt`).
#' @param dir (optional) A string specifying the directory where the files
#'   should be downloaded (default: `tempdir()`).
#'
#' @return A invisible [`character`][base::character()] vector of file paths
#'   where the files were downloaded.
#'
#' @family file functions
#' @export
#'
#' @examples
#' library(httr2)
#'
#' if (is_online()) {
#'   urls <- file.path(
#'     "ftp://ftp.datasus.gov.br/dissemin/publicos/IBGE/POPSVS",
#'      c("POPSBR00.zip", "POPSBR01.zip")
#'   )
#'
#'   download_file(urls)
#' }
download_file <- function(
  url,
  connection_timeout = 10,
  max_tries = 3,
  retry_on_failure = TRUE,
  backoff = \(attempt) 5^attempt,
  dir = tempdir()
) {
  require_package("fs", "httr2")

  url_pattern <- paste0(
    "(http[s]?|ftp)://(?:[a-zA-Z]|[0-9]|[$-_@.&+]|[!*\\(\\),]|",
    "(?:%[0-9a-fA-F][0-9a-fA-F]))+"
  )

  if (!is_online()) {
    cli::cli_abort(
      paste0(
        "No internet connection. ",
        "Please check your connection and try again."
      )
    )
  }

  checkmate::assert_character(url, pattern = url_pattern, any.missing = FALSE)
  checkmate::assert_string(dir)
  checkmate::assert_directory_exists(dir, access = "w")
  checkmate::assert_number(connection_timeout, lower = 1)
  checkmate::assert_number(max_tries, lower = 1)
  checkmate::assert_flag(retry_on_failure)
  checkmate::assert_function(backoff)

  # R CMD Check variable bindings fix
  # nolint start
  . <- NULL
  # nolint end

  file_sizes <-
    url |>
    get_file_size_by_url(
      connection_timeout = connection_timeout,
      max_tries = max_tries,
      retry_on_failure = retry_on_failure
    )

  cli::cli_alert_info(
    paste0(
      "Downloading ",
      "{.strong {cli::col_red(length(url))}} ",
      "{cli::qty(length(url))}",
      "file{?s} to {.strong {dir}}"
    )
  )

  cli::cli_progress_bar(
    name = "Downloading files",
    total = length(url),
    clear = FALSE
  )

  broken_links <- character()

  for (i in url) {
    test <- try(
      i |>
        httr2::request() |>
        httr2::req_options(connecttimeout = connection_timeout) |>
        httr2::req_retry(
          max_tries = max_tries,
          retry_on_failure = retry_on_failure,
          backoff = backoff
        ) |>
        httr2::req_progress() |>
        httr2::req_perform(
          path = fs::path(dir, basename(i)),
        ),
      silent = TRUE
    )

    if (inherits(test, "try-error")) {
      cli::cli_alert_warning(
        paste0(
          "The file {.strong {cli::col_red(basename(i))}} ",
          "could not be downloaded."
        ),
        wrap = TRUE
      )

      broken_links <- c(broken_links, i)
    }

    cli::cli_progress_update()
  }

  cli::cli_progress_done()

  url |>
    magrittr::extract(!url %in% broken_links) %>%
    fs::path(dir, basename(.)) |>
    invisible()
}
