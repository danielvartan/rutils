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
#' @param round A [`logical`][base::logical] flag indicating whether to round
#'   the summary statistics (default: `FALSE`).
#' @param digits An integer number specifying the number of decimal places to
#'   round to if `round` is `TRUE` (default: `2`).
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
#' library(lubridate)
#'
#' ## `character` Example
#'
#' sample(letters, 1000, replace = TRUE) |>
#'   as_tibble() |>
#'   stats_summary("value") |>
#'   print(n = Inf)
#'
#' ## `factor` Example
#'
#' sample(letters, 1000, replace = TRUE) |>
#'   as.factor() |>
#'   as_tibble() |>
#'   stats_summary("value") |>
#'   print(n = Inf)
#'
#' ## `numeric` Example
#'
#' rnorm(1000) |>
#'   as_tibble() |>
#'   stats_summary("value") |>
#'   print(n = Inf)
#'
#' ## `duration` Examples
#'
#' sample(seq_len(86399), 1000) |>
#'   as.duration() |>
#'   as_tibble() |>
#'   stats_summary("value") |>
#'   print(n = Inf)
#'
#' sample(seq_len(86399), 1000) |>
#'   as.duration() |>
#'   as_tibble() |>
#'   stats_summary(
#'     col = "value",
#'     hms_format = FALSE
#'   ) |>
#'   print(n = Inf)
#'
#' ## `hms` Examples
#'
#' sample(seq_len(86399), 1000) |>
#'   as_hms() |>
#'   as_tibble() |>
#'   stats_summary("value") |>
#'   print(n = Inf)
#'
#' sample(seq_len(86399), 1000) |>
#'   as_hms() |>
#'   as_tibble() |>
#'   stats_summary(
#'     col = "value",
#'     threshold = hms::parse_hm("12:00")
#'   ) |>
#'   print(n = Inf)
#'
#' ## `Date` Example
#'
#' sample(seq_len(20415), 1000) |>
#'   as.Date() |>
#'   as_tibble() |>
#'   stats_summary("value") |>
#'   print(n = Inf)
#'
#' ## `POSIXct` Example
#'
#' sample(seq_len(Sys.time()), 1000) |>
#'   as.POSIXct() |>
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
    round = FALSE,
    digits = 3,
    hms_format = TRUE,
    threshold = NULL, # hms::parse_hms("12:00:00")
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
  checkmate::assert_flag(round)
  checkmate::assert_int(digits, lower = 0)
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

    if (isTRUE(round)) {
      out <-
        out |>
        purrr::map(
          .f = \(x) ifelse(is.numeric(x), round(x, digits = digits), x)
        )
    }
  }

  if (
    (lubridate::is.Date(x_sample) || lubridate::is.POSIXt(x_sample)) &&
      !test_timeline_link(x)
  ) {
    if (lubridate::is.Date(x_sample)) {
    out <- purrr::map(
      .x = out,
      .f = ~ lubridate::as_date(.x)
    )

      duration_fun <- lubridate::ddays
    } else {
    out <- purrr::map(
      .x = out,
      .f = ~ lubridate::as_datetime(.x)
    )

      duration_fun <- lubridate::dseconds
    }

    out$n <- length(x)
    out$n_rm_na <- length(x[!is.na(x)])
    out$n_na <- length(x[is.na(x)])
    out$var <-
      stats::var(x, na.rm = na_rm) |>
      duration_fun()
    out$sd <-
      stats::sd(x, na.rm = na_rm) |>
      duration_fun()
    out$iqr <-
      stats::IQR(x, na.rm = na_rm) |>
      duration_fun()
    out$range <-
      max(x, na.rm = na_rm) |>
      magrittr::subtract(min(x, na.rm = na_rm)) |>
      duration_fun()
    out$skewness <- moments::skewness(x, na.rm = na_rm)
    out$kurtosis <- moments::kurtosis(x, na.rm = na_rm)

    if (isTRUE(round)) {
      out$var <- out$var |> round(digits = digits)
      out$sd <- out$sd |> round(digits = digits)
      out$iqr <- out$iqr |> round(digits = digits)
      out$range <- out$range |> round(digits = digits)
      out$skewness <- out$skewness |> round(digits = digits)
      out$kurtosis <- out$kurtosis |> round(digits = digits)
    }
  } else if ( prettycheck::test_temporal(x_sample, rm = "Date")) {
    if (test_timeline_link(x)) {
      out <- purrr::map(
        .x = out,
        .f = ~ hms::as_hms(lubridate::as_datetime(.x))
      )
    } else if (hms::is_hms(x_sample) || isTRUE(hms_format)) {
      out <- purrr::map(.x = out, .f = hms::hms)
    } else if (lubridate::is.duration(x_sample)) {
      out <- purrr::map(.x = out, .f = lubridate::as.duration)
    }

    out$n <- length(x)
    out$n_rm_na <- length(x[!is.na(x)])
    out$n_na <- length(x[is.na(x)])
    out$skewness <- moments::skewness(x, na.rm = na_rm)
    out$kurtosis <- moments::kurtosis(x, na.rm = na_rm)

    if (isTRUE(round)) {
      out$skewness <- out$skewness |> round(digits = digits)
      out$kurtosis <- out$kurtosis |> round(digits = digits)
    }
  } else if (!is.numeric(x_sample) && !prettycheck::test_temporal(x_sample)) {
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
  prettycheck::assert_length(threshold, len = 1)

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
