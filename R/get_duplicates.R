get_duplicates <- function(x, rm_na = TRUE) {
  if (anyDuplicated(x) == 0) {
    NULL
  } else {
    out <- x[duplicated(x)]

    if (isTRUE(rm_na)) {
      rm_na(out)
    } else {
      x[duplicated(x)]
    }
  }
}
