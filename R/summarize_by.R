summarize_by <- function(data, col, col_group, col_n = NULL) {
  checkmate::assert_tibble(data)
  checkmate::assert_string(col)
  checkmate::assert_choice(col, names(data))
  prettycheck::assert_length(col_group, len = 1)
  checkmate::assert_multi_class(col_group, c("character", "factor"))
  checkmate::assert_choice(col_group, names(data))
  checkmate::assert_string(col_n, null.ok = TRUE)
  checkmate::assert_choice(col_n, names(data), null.ok = TRUE)

  # R CMD Check variable bindings fix
  # nolint start
  . <- name <- NULL
  # nolint end

  col_group <- col_group |> as.character()

  out <-
    data |>
    dplyr::select(dplyr::all_of(c(col, col_group, col_n))) %>%
    {
      if (!is.null(col_n)) {
        tidyr::uncount(., !!as.symbol(col_n))
      } else {
        .
      }
    } |>
    tidyr::drop_na(!!as.symbol(col_group)) |>
    dplyr::arrange(!!as.symbol(col_group)) |>
    dplyr::group_by(!!as.symbol(col_group)) |>
    dplyr::group_split() |>
    purrr::map_dfr(
      .f = ~ .x |>
        rutils:::stats_summary(
          col = col,
          name = unique(.x[[col_group]]) |> as.character(),
          as_list = TRUE
        ) |>
        dplyr::as_tibble()
    ) |>
    dplyr::rename(!!as.symbol(col_group) := name)

  if (data[[col]] |> hms::is_hms()) {
    out |>
      dplyr::mutate(
        dplyr::across(
          .cols = dplyr::where(hms::is_hms),
          .fns = lubritime::round_time
        )
      )
  } else {
    out
  }
}
