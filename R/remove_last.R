remove_last <- function(x) {
  # prettycheck::assert_length(x, 2)

  x[-length(x)]
}
