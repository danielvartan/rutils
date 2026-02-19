#' Get the sizes of local files or files from URLs
#'
#' @description
#'
#' `get_file_size()` returns the sizes of files in bytes. It works with local
#' and remote files.
#'
#' @param file A [`character`][base::character()] vector of file paths.
#'   The function also works with URLs.
#' @inheritParams download_file
#'
#' @return A [`fs_bytes`][fs::fs_bytes()] vector of file sizes.
#'
#' @family file functions
#' @export
#'
#' @examples
#' library(fs)
#' library(readr)
#'
#' files <- c("file1.txt", "file2.txt", "file3.txt")
#'
#' dir <- tempfile("dir")
#' dir.create(dir)
#'
#' for (i in files) {
#'   letters |>
#'     rep(sample(1000:10000, 1)) |>
#'     write_lines(file.path(dir, i))
#' }
#'
#' urls <- c(
#'   paste0(
#'     "https://geodata.ucdavis.edu/climate/worldclim/2_1/base/",
#'     "wc2.1_2.5m_tavg.zip"
#'   ),
#'   paste0(
#'     "https://geodata.ucdavis.edu/climate/worldclim/2_1/base/",
#'     "wc2.1_10m_prec.zip"
#'   )
#' )
#'
#' c(urls, path(dir, files)) |> get_file_size()
get_file_size <- function(
  file,
  connection_timeout = 10,
  max_tries = 3,
  retry_on_failure = TRUE
) {
  require_package("fs", "httr2")

  checkmate::assert_character(file)
  checkmate::assert_number(connection_timeout, lower = 1)
  checkmate::assert_number(max_tries, lower = 1)
  checkmate::assert_flag(retry_on_failure)

  url_pattern <- paste0(
    "(http[s]?|ftp)://(?:[a-zA-Z]|[0-9]|[$-_@.&+]|[!*\\(\\),]|",
    "(?:%[0-9a-fA-F][0-9a-fA-F]))+"
  )

  file <- file |> stringr::str_trim()
  out <- character()

  for (i in seq_along(file)) {
    if (stringr::str_detect(file[i], url_pattern)) {
      out[i] <-
        file[i] |>
        get_file_size_by_url(
          connection_timeout = connection_timeout,
          max_tries = max_tries,
          retry_on_failure = retry_on_failure
        )
    } else {
      out[i] <- file[i] |> fs::file_size()
    }
  }

  out |> fs::fs_bytes()
}

get_file_size_by_url <- function(
  file,
  connection_timeout = 10,
  max_tries = 3,
  retry_on_failure = TRUE
) {
  require_package("fs", "httr2")

  url_pattern <- paste0(
    "(http[s]?|ftp)://(?:[a-zA-Z]|[0-9]|[$-_@.&+]|[!*\\(\\),]|",
    "(?:%[0-9a-fA-F][0-9a-fA-F]))+"
  )

  checkmate::assert_character(file, pattern = url_pattern)
  checkmate::assert_number(connection_timeout, lower = 1)
  checkmate::assert_number(max_tries, lower = 1)
  checkmate::assert_flag(retry_on_failure)

  if (!is_online()) {
    cli::cli_abort(
      paste0(
        "No internet connection. ",
        "Please check your connection and try again."
      )
    )
  }

  out <- character()

  for (i in seq_along(file)) {
    response <- try(
      {
        file[i] |>
          httr2::request() |>
          httr2::req_method("HEAD") |>
          httr2::req_options(connecttimeout = connection_timeout) |>
          httr2::req_retry(
            max_tries = max_tries,
            retry_on_failure = TRUE
          ) |>
          httr2::req_perform()
      },
      silent = TRUE
    )

    if (inherits(response, "try-error")) {
      out[i] <- NA
    } else if (!is.null(response$headers$`Content-Length`)) {
      out[i] <-
        response |>
        httr2::resp_headers() |>
        purrr::pluck("Content-Length") |>
        as.numeric()
    } else {
      out[i] <- NA
    }
  }

  out |> fs::fs_bytes()
}
