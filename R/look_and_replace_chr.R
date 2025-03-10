# x <- c("BRT", "EST", "BRT")
# paired_vector <- c("EST" = "EST", "BRT" = "America/Sao_Paulo")
# look_and_replace_chr(x, paired_vector)
look_and_replace_chr <- function(x, paired_vector) {
  checkmate::assert_atomic(x)
  checkmate::assert_atomic(paired_vector)
  checkmate::assert_character(names(paired_vector), null.ok = FALSE)

  x <- stringr::str_squish(x)

  dplyr::case_when(
    x %in% names(paired_vector) ~
      paired_vector[match(x, names(paired_vector))],
    TRUE ~ NA
  ) |>
    unname()
}
