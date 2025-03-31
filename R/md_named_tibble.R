md_named_tibble <- function(data, col_names = NULL, row_names = NULL) {
  checkmate::assert_data_frame(data, min.cols = 2)
  checkmate::assert_character(data[[1]])

  if (is.null(col_names)) {
    col_names <-
      data[-1] |>
      names() |>
      stringr::str_replace_all("\\_", " ") |>
      stringr::str_to_title()
  }

  if (is.null(row_names)) row_names <- data[[1]]

  data[-1] |>
    as.data.frame() |>
    magrittr::set_colnames(col_names) |>
    magrittr::set_rownames(row_names) |>
    pal::pipe_table(label = NA, digits = 10) |>
    pal::cat_lines() |>
    shush()
}
