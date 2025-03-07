# library(checkmate)

extract_initials <- function(x, sep = ". ") {
  checkmate::assert_string(x)

  if (!grepl(" ", x)) {
    substr(x, 1, 1)
  } else {
    x <- gsub("(?<=[A-Z])[^A-Z]+", sep, x, perl = TRUE)
    trimws(x)
  }
}
