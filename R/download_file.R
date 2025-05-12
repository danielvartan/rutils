#' Download files from the internet to a local directory
#'
#' @description
#'
#' `download_file()` downloads files from the internet to a local directory. It
#' can handle multiple files at once and provides progress updates during the
#' download process.
#'
#' The function also checks for broken links and can return a list of any
#' broken links encountered during the download.
#'
#' @param url A [`character`][base::character()] vector of URLs pointing to
#'   files.
#' @param dir (optional) A string specifying the directory where the files
#'   should be downloaded (default: ".").
#' @param broken_links (optional) A [`logical`][base::logical()] flag indicating
#'   whether to return a list of broken links (default: `FALSE`).
#'
#' @return If `broken_links` is `TRUE`, an invisible
#'   [`character`][base::character()] vector of broken links. Otherwise, a
#'   invisible [`character`][base::character()] vector of file paths where
#'   the files were downloaded.
#'
#' @family file functions
#' @export
#'
#' @examples
#' library(curl)
#'
#' if (has_internet()) {
#'   urls <- paste0(
#'     "ftp://ftp.datasus.gov.br/dissemin/publicos/IBGE/POPSVS/",
#'      c("POPSBR00.zip", "POPSBR01.zip")
#'   )
#'
#'   dir <- tempfile("dir")
#'   dir.create(dir)
#'
#'   download_file(urls, dir)
#' }
download_file <- function(
  url,
  dir = ".",
  broken_links = FALSE
) {
  url_pattern <- paste0(
    "(http[s]?|ftp)://(?:[a-zA-Z]|[0-9]|[$-_@.&+]|[!*\\(\\),]|",
    "(?:%[0-9a-fA-F][0-9a-fA-F]))+"
  )

  checkmate::assert_character(url, pattern = url_pattern, any.missing = FALSE)
  checkmate::assert_string(dir)
  checkmate::assert_directory_exists(dir, access = "w")

  # R CMD Check variable bindings fix
  # nolint start
  . <- NULL
  # nolint end

  cli::cli_alert_info(
    paste0(
      "Downloading ",
      "{.strong {cli::col_red(length(url))}} ",
      "{cli::qty(length(url))}",
      "file{?s} to {.strong {dir}}"
    )
  )

  if (length(url) > 1) cli::cat_line()

  cli::cli_progress_bar(
    name = "Downloading data",
    total = length(url),
    clear = FALSE
  )

  broken_links <- character()

  for (i in url) {
    test <- try(
      i |>
        curl::curl_download(
          destfile = fs::path(dir, basename(i)),
          quiet = TRUE
        ),
      silent = TRUE
    )

    if (inherits(test, "try-error")) {
      cli::cli_alert_info(
        "The file {.strong {basename(i)}} could not be downloaded."
      )

      broken_links <- c(broken_links, i)
    }

    cli::cli_progress_update()
  }

  cli::cli_progress_done()

  if (isTRUE(broken_links)) {
    invisible(broken_links)
  } else {
    url |>
      magrittr::extract(!url %in% broken_links) %>%
      fs::path(dir, basename(.)) |>
      invisible()
  }
}
