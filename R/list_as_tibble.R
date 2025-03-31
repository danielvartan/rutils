list_as_tibble <- function(list) {
  checkmate::assert_list(list)

  list |>
    dplyr::as_tibble() |>
    dplyr::mutate(
      dplyr::across(
        .cols = dplyr::everything(),
        .fns = as.character
      )
    ) |>
    tidyr::pivot_longer(cols = dplyr::everything())
}
