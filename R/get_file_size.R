#' Get the sizes of local files or files from URLs
#'
#' @description
#'
#' `get_file_size()` returns the sizes of files in bytes. It works with local
#' files and URLs.
#'
#' @param file A [`character`][base::character()] vector of file paths.
#'   The function also works with URLs.
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
#'   write_lines(rep(letters, sample(1000:10000, 1)), file.path(dir, i))
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
get_file_size <- function(file) {
  checkmate::assert_character(file)

  url_pattern <- paste0(
    "(http[s]?|ftp)://(?:[a-zA-Z]|[0-9]|[$-_@.&+]|[!*\\(\\),]|",
    "(?:%[0-9a-fA-F][0-9a-fA-F]))+"
  )

  file <- stringr::str_trim(file)
  out <- character()

  for (i in seq_along(file)) {
    if (stringr::str_detect(file[i], url_pattern)) {
      out[i] <- get_file_size_by_url(file[i])
    } else {
      out[i] <- fs::file_size(file[i])
    }
  }

  out |> fs::fs_bytes()
}

get_file_size_by_url <- function(file) {
  url_pattern <- paste0(
    "(http[s]?|ftp)://(?:[a-zA-Z]|[0-9]|[$-_@.&+]|[!*\\(\\),]|",
    "(?:%[0-9a-fA-F][0-9a-fA-F]))+"
  )

  prettycheck::assert_internet()
  checkmate::assert_character(file, pattern = url_pattern)

  out <- character()

  for (i in seq_along(file)) {
    request <- try({file[i] |> httr::HEAD()}, silent = TRUE) #nolint

    if (inherits(request, "try-error")) {
      out[i] <- NA
    } else if (!is.null(request$headers$`Content-Length`)) {
      out[i] <- as.numeric(request$headers$`content-length`)
    } else {
      out[i] <- NA
    }
  }

  out |> fs::fs_bytes()
}
