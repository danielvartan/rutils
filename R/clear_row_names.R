# library(checkmate)

clear_row_names <- function(x) {
  checkmate::assert_data_frame(x, min.rows = 1)

  rownames(x) <- NULL

  x
}
