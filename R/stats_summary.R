stats_summary <- function( #nolint
    data, #nolint
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
    if (lubridate::is.POSIXt(x)) {
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

  if (prettycheck::test_temporal(x_sample) && isTRUE(hms_format)) {
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
        magrittr::set_names(i$x) |>
        as.list() %>%
        c(out, .)
    }
  }

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
