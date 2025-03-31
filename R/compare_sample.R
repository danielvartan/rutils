compare_sample <- function(sample_data, pop_data, by) {
  checkmate::assert_tibble(sample_data)
  checkmate::assert_tibble(pop_data)
  checkmate::assert_string(by)
  checkmate::assert_choice(by, names(sample_data))
  checkmate::assert_choice(by, names(pop_data))

  # R CMD Check variable bindings fix
  # nolint start
  n <- n_rel_sample <- n_rel_pop <- n_rel_diff <- diff_rel <- NULL
  # nolint end

  sample_data |>
    dplyr::summarize(n = dplyr::n(), .by = !!as.symbol(by)) |>
    dplyr::mutate(
      n_rel = n / sum(n)
    ) |>
    dplyr::full_join(
      pop_data |>
        dplyr::summarize(n = sum(n), .by = !!as.symbol(by))  |>
        dplyr::mutate(
          n_rel = n / sum(n)
        ),
      by = by,
      suffix = c("_sample", "_pop")
    ) |>
    dplyr::mutate(
      n_rel_sample = ifelse(is.na(n_rel_sample), 0, n_rel_sample),
      n_rel_diff = n_rel_sample - n_rel_pop,
      diff_rel = n_rel_diff / n_rel_pop
    ) |>
    dplyr::select(
      !!as.symbol(by),
      n_rel_sample, n_rel_pop,
      n_rel_diff, diff_rel
    ) |>
    janitor::adorn_totals(
      where = "row",
      fill = "-",
      na.rm = TRUE,
      name = "Total"
    ) |>
    janitor::adorn_pct_formatting(
      digits = 3,
      rounding = "half to even",
      affix_sign = TRUE,
      -dplyr::all_of(by)
    ) |>
    dplyr::as_tibble()
}
