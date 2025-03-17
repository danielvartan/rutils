change_name <- function(x, new_name) {
  checkmate::assert_character(new_name, min.len = 1)
  # assert_identical(names(x), new_name, type = "length")

  names(x) <- new_name

  x
}
