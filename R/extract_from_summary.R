extract_from_summary <- function(x, element = "r.squared") {
  checkmate::assert_list(x)
  checkmate::assert_string(element)

  summary <- summary(x)

  if (is.null(names(summary))) {
    cli::cli_abort(paste0(
      "{.strong {cli::col_red('summary(x)')}} has no names."
    ))
  }

  if (!element %in% names(summary)) {
    cli::cli_abort(paste0(
      "There is no element named {.strong {cli::col_red(element)}} in ",
      "{.strong summary(x)}."
    ))
  }

  summary[[element]]
}
