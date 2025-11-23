# library(checkmate)
# library(cli)
# library(dplyr)
# library(hms)
# library(lubridate)
# library(lubritime)
# library(magrittr)
# library(moments)
# library(prettycheck)
# library(purrr)
# library(stats)
# library(tibble)

#' Compute summary statistics
#'
#' @description
#'
#' `stats_summary()` computes summary statistics for a specified column in a
#' data frame.
#'
#' @param data A [`data.frame`][base::data.frame].
#' @param col A [`character`][base::character] `string` specifying the column
#'   name in `data` for which to compute summary statistics.
#' @param name (optional) A [`character`][base::character] `string` with a
#'   name to include in the summary statistics (default: `NULL`).
#' @param na_rm A [`logical`][base::logical] flag indicating whether to remove
#'   `NA` values when computing statistics (default: `TRUE`).
#' @param remove_outliers A [`logical`][base::logical] flag indicating whether
#'   to remove outliers using the IQR method (default: `FALSE`).
#' @param iqr_mult A [`numeric`][base::numeric] value specifying the
#'   Interquartile Range (IQR) multiplier for outlier detection
#'   (default: `1.5`).
#' @param hms_format A [`logical`][base::logical] flag indicating whether to
#'   format temporal statistics as [`hms`][hms::hms] objects (default: `TRUE`).
#' @param threshold A [`hms`][hms::hms] object specifying the threshold time
#'   for linking times to a timeline when computing temporal statistics.
#'   See [`link_to_timeline()`][lubritime::link_to_timeline()] to learn more
#'   (default: `hms::parse_hms("12:00:00")`).
#' @param as_list A [`logical`][base::logical] flag indicating whether to
#'   return the summary statistics as a [`list`][base::list] (default: `FALSE`).
#'
#' @return If `as_list` is `TRUE`, a [`list`][base::list]  with the summary
#'   statistics. Otherwise, a one-row [`tibble`][tibble::tibble] with the
#'   summary statistics.
#'
#' @family statistical functions.
#' @export
#'
#' @examples
#' library(dplyr)
#' library(hms)
#'
#' rnorm(1000) |>
#'   as_tibble() |>
#'   stats_summary("value") |>
#'   print(n = Inf)
#'
#' letters |>
#'   as_tibble() |>
#'   stats_summary("value") |>
#'   print(n = Inf)
#'
#' sample(0:86399, 1000) |>
#'   as_hms() |>
#'   as_tibble() |>
#'   stats_summary("value") |>
#'   print(n = Inf)
#'
#' sample(0:20415, 1000) |>
#'   as.Date() |>
#'   as_tibble() |>
#'   stats_summary("value") |>
#'   print(n = Inf)
stats_summary <- function(
    data,
    col,
    name = NULL,
    na_rm = TRUE,
    remove_outliers = FALSE,
    iqr_mult = 1.5,
    hms_format = TRUE,
    threshold = hms::parse_hms("12:00:00"),
    as_list = FALSE
  ) {
  checkmate::assert_data_frame(data)
  checkmate::assert_string(col)
  checkmate::assert_choice(col, names(data))
  checkmate::assert_atomic(data[[col]])
  checkmate::assert_string(name, null.ok = TRUE)
  checkmate::assert_flag(na_rm)
  checkmate::assert_flag(remove_outliers)
  checkmate::assert_number(iqr_mult, lower = 1)
  checkmate::assert_flag(hms_format)

  prettycheck::assert_hms(
    threshold, lower = hms::hms(0), upper = hms::parse_hms("23:59:59"),
    null_ok = TRUE
  )

  checkmate::assert_flag(as_list)

  # R CMD Check variable bindings fix
  # nolint start
  . <- NULL
  # nolint end

  x <- data |> dplyr::pull(col)
  x_sample <- x[1]

  if (is.factor(x)) {
    x <- as.character(x)
    x_sample <- as.character(x)
  }

  if (prettycheck::test_temporal(x)) {
    if (lubridate::is.Date(x) || lubridate::is.POSIXt(x)) {
      x <- x |> as.numeric()
    } else if (hms::is_hms(x)) {
      x <-
        x |>
        lubritime::link_to_timeline(threshold = threshold) |>
        as.numeric()
    } else {
      x <- x |> lubritime::extract_seconds()
    }
  }

  if (isTRUE(remove_outliers)) {
    x <- x |> remove_outliers(method = "iqr", iqr_mult = iqr_mult)
  }

  out <- list(
    n = length(x),
    n_rm_na = length(x[!is.na(x)]),
    n_na = length(x[is.na(x)])
  )

  if (is.numeric(x)) {
    out <-
      out |>
      append(list(
        mean = mean(x, na.rm = na_rm),
        var = stats::var(x, na.rm = na_rm),
        sd = stats::sd(x, na.rm = na_rm),
        min = unname(stats::quantile(x, 0, na.rm = na_rm)),
        q_1 = unname(stats::quantile(x, 0.25, na.rm = na_rm)),
        median = unname(stats::quantile(x, 0.5, na.rm = na_rm)),
        q_3 = unname(stats::quantile(x, 0.75, na.rm = na_rm)),
        max = unname(stats::quantile(x, 1, na.rm = na_rm)),
        iqr = stats::IQR(x, na.rm = na_rm),
        range = max(x, na.rm = na_rm) - min(x, na.rm = na_rm),
        skewness = moments::skewness(x, na.rm = na_rm),
        kurtosis = moments::kurtosis(x, na.rm = na_rm)
      ))
  }

  if (
    prettycheck::test_temporal(x_sample, rm = "Date") &&
      isTRUE(hms_format)
  ) {
    if (test_timeline_link(x)) {
      out <- purrr::map(
        .x = out,
        .f = ~ hms::as_hms(lubridate::as_datetime(.x))
      )
    } else {
      out <- purrr::map(.x = out, .f = hms::hms)
    }

    out$n <- length(x)
    out$n_rm_na <- length(x[!is.na(x)])
    out$n_na <- length(x[is.na(x)])
    out$skewness <- moments::skewness(x, na.rm = na_rm)
    out$kurtosis <- moments::kurtosis(x, na.rm = na_rm)
  }

  if (lubridate::is.Date(x_sample)) {
    out <- purrr::map(
      .x = out,
      .f = ~ lubridate::as_date(.x)
    )

    out$n <- length(x)
    out$n_rm_na <- length(x[!is.na(x)])
    out$n_na <- length(x[is.na(x)])
    out$var <-
      stats::var(x, na.rm = na_rm) |>
      lubridate::ddays()
    out$sd <-
      stats::sd(x, na.rm = na_rm) |>
      lubridate::ddays()
    out$iqr <-
      stats::IQR(x, na.rm = na_rm) |>
      lubridate::ddays()
    out$range <-
      max(x, na.rm = na_rm) |>
      magrittr:::subtract(min(x, na.rm = na_rm)) |>
      lubridate::ddays()
    out$skewness <- moments::skewness(x, na.rm = na_rm)
    out$kurtosis <- moments::kurtosis(x, na.rm = na_rm)
  }

  if (!is.numeric(x_sample) && !prettycheck::test_temporal(x_sample)) {
    out <- c(
      out,
      list(
        n_unique = length(unique(x)),
        mode = mode(x)
      )
    )

    data_count <-
      dplyr::tibble(x = x) |>
      dplyr::count(x) |>
      dplyr::group_by(row = dplyr::row_number()) |>
      dplyr::group_split()

    for (i in data_count) {
      out <-
        i$n |>
        magrittr::set_names( paste0("'", i$x, "'")) |>
        as.list() %>%
        c(out, .)
    }
  }

  out <- append(out, list(class = class(x_sample)[1]), after = 0)

  if (!is.null(name)) out <- append(out, list(name = name), after = 0)

  if (isTRUE(as_list)) {
    out
  } else {
    out |> list_as_tibble()
  }
}

test_timeline_link <- function(x, threshold = hms::parse_hm("12:00")) {
  checkmate::assert_multi_class(x, c("numeric", "POSIXt"))
  prettycheck::assert_hms(
    threshold,
    lower = hms::hms(0),
    upper = hms::parse_hms("23:59:59")
  )

  if (is.numeric(x)) x <- x |> lubridate::as_datetime()

  int <- lubridate::interval(
    start = lubridate::as_datetime(
      paste0("1970-01-01", as.character(threshold))
    ),
    end = lubridate::as_datetime(
      paste0("1970-01-02", as.character(threshold))
    )
  )

  if (all(x %within% int, na.rm = TRUE)) {
    TRUE
  } else {
    FALSE
  }
}
