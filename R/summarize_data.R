summarize_data <- function(data, by) {
  checkmate::assert_tibble(data)
  checkmate::assert_string(by)
  checkmate::assert_subset(c(by, "n"), names(data))

  # R CMD Check variable bindings fix
  # nolint start
  n <- n_cum <- n_per <- n_per_cum <- NULL
  # nolint end

  data |>
    dplyr::summarize(n = sum(n), .by = !!as.symbol(by)) |>
    dplyr::mutate(
      n_cum = cumsum(n),
      n_per = (n / sum(n)),
      n_per_cum = cumsum(n_per * 100),
      n_per_cum =
        n_per_cum |>
        round(3) |>
        format(nsmall = 3) |>
        paste0("%")
    ) |>
    janitor::adorn_totals(
      where = "row",
      fill = "-",
      na.rm = TRUE,
      name = "Total",
      -n_cum,
      -n_per_cum
    ) |>
    janitor::adorn_pct_formatting(
      digits = 3,
      rounding = "half to even",
      affix_sign = TRUE,
      n_per
    ) |>
    dplyr::as_tibble()
}
