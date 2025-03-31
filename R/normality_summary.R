normality_summary <- function(
    data, #nolint
    col,
    round = FALSE,
    digits = 5,
    ...
  ) {
  checkmate::assert_tibble(data)
  checkmate::assert_choice(col, names(data))
  prettycheck::assert_numeric(data[[col]])
  checkmate::assert_flag(round)
  checkmate::assert_number(digits)

  stats <-
    data |>
    rutils:::test_normality(col = col, print = FALSE, ...)

  out <- dplyr::tibble(
    test = c(
      "Anderson-Darling",
      "Bonett-Seier",
      "Cramer-von Mises",
      "D'Agostino Omnibus Test",
      "D'Agostino Skewness Test",
      "D'Agostino Kurtosis Test",
      "Jarque-Bera",
      "Lilliefors (K-S)",
      "Pearson chi-square",
      "Shapiro-Francia",
      "Shapiro-Wilk"
    ),
    statistic_1 = c(
      stats$ad$statistic,
      stats$bonett$statistic[1],
      stats$cvm$statistic,
      attr(stats$dagostino, "test")$statistic[1],
      attr(stats$dagostino, "test")$statistic[2],
      attr(stats$dagostino, "test")$statistic[3],
      stats$jarque_bera$statistic,
      stats$lillie_ks$statistic,
      stats$pearson$statistic,
      ifelse(is.null(stats$shapiro), NA, stats$shapiro$statistic),
      ifelse(is.null(stats$sf), NA, stats$sf$statistic)
    ),
    statistic_2 = c(
      as.numeric(NA),
      stats$bonett$statistic[2],
      as.numeric(NA),
      as.numeric(NA),
      as.numeric(NA),
      as.numeric(NA),
      stats$jarque_bera$parameter,
      as.numeric(NA),
      as.numeric(NA),
      as.numeric(NA),
      as.numeric(NA)
    ),
    p_value = c(
      stats$ad$p.value,
      stats$bonett$p.value,
      stats$cvm$p.value,
      attr(stats$dagostino, "test")$p.value[1],
      attr(stats$dagostino, "test")$p.value[2],
      attr(stats$dagostino, "test")$p.value[3],
      stats$jarque_bera$p.value,
      stats$lillie_ks$p.value,
      stats$pearson$p.value,
      ifelse(is.null(stats$shapiro), NA, stats$shapiro$p.value),
      ifelse(is.null(stats$sf), NA, stats$sf$p.value)
    )
  )

  if (isTRUE(round)) {
    out |>
      dplyr::mutate(
        dplyr::across(
          .cols = dplyr::where(is.numeric),
          .fns = ~ round(.x, digits)
        )
      )
  } else {
    out
  }
}
