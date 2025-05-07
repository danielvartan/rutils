#' Aggregate data by year from SIDRA API
#'
#' @description
#'
#' This function downloads data from the Brazilian Institute of Geography and
#' Statistics ([IBGE](https://www.ibge.gov.br/)) Automatic Retrieval System
#' ([SIDRA](https://sidra.ibge.gov.br/)) API for a given range of years.
#'
#' @details
#'
#' To get the API call, go to the SIDRA, look for your data in one of the
#' tables, then click on the share button and copy the *Parâmetros para a API*
#' value. The API call starts with "/t" (see the examples).
#'
#' @param years A [`integerish`][checkmate::check_integerish()] vector with the
#'   years to download.
#' @param api_start A string with the start of the API URL.
#' @param api_end A string with the end of the API URL. It's important to note
#'   that the year will be pasted after `api_start` and before `api_end`.
#' @param year_col A string with the name of the column that contains the year.
#'
#' @return A [tibble][tibble::tibble()] with data from the SIDRA API.
#'
#' @family other functions.
#' @export
#'
#' @examples
#' \dontrun{
#'   sidrar_aggregator(
#'     years = 2010:2011,
#'     api_start = "/t/1612/n6/all/v/109/p/",
#'     api_end = "/c81/2692"
#'   )
#' }
get_and_aggregate_sidra_by_year <- function( #nolint
    years, #nolint
    api_start,
    api_end,
    year_col = "Ano"
  ) {
  prettycheck::assert_internet()
  checkmate::assert_integerish(
    years,
    lower = 1900,
    upper = lubridate::year(Sys.time()) + 1
  )
  checkmate::assert_string(api_start)
  checkmate::assert_string(api_start)
  checkmate::assert_string(year_col)

  # R CMD Check variable bindings fix
  # nolint start
  . <- NULL
  # nolint end

  out <- list()

  for (i in years) {
    cli::cli_progress_step(
      msg = paste0("Downloading data from ", i, "."),
      spinner = TRUE
    )

    data_i <-
      paste0(api_start, i, api_end) %>% # Don't change the pipe.
      sidrar::get_sidra(api = .) |>
      try(silent = TRUE) |>
      shush()

    if (inherits(data_i, "try-error")) {
      error_message <- attributes(data_i)$condition$message #nolint

      cli::cli_alert_warning(paste0(
        "Failed to get data for year ",
        "{.strong {cli::col_red(i)}}.\n\n",
        "{.strong Error message}: ",
        "{cli::col_grey(error_message)}"
      ))
    } else {
      out[[paste("year_", i)]] <- data_i |> dplyr::as_tibble()
    }
  }

  out |>
    dplyr::bind_rows() %>%
    dplyr::arrange(.[[year_col]])
}
