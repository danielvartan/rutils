# library(checkmate)

inbetween_integers <- function(x, y) {
  checkmate::assert_number(x)
  checkmate::assert_number(y)

  lower_int <- min(x, y) |> floor()
  upper_int <- max(x, y) |> ceiling()

  setdiff(lower_int:upper_int, sort(c(x, y)))
}
