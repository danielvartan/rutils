library(checkmate)
library(glue)
library(magrittr)

collapse_names <- function(
  ...,
  deparsed = FALSE,
  color = "red",
  last = "or",
  names = NULL
) {
  checkmate::assert_flag(deparsed)
  checkmate::assert_choice(color, cli_color_choices())
  checkmate::assert_choice(last, c("and", "or"))
  checkmate::assert_character(names, null.ok = TRUE)

  # R CMD Check variable bindings fix
  # nolint start
  . <- NULL
  # nolint end

  last <- paste0(" ", last, " ")

  if (isTRUE(deparsed)) {
    fun <- get_names
  } else {
    fun <- get_values
  }

  if (is.null(names)) {
    if (length(fun(...)) > 5) {
      names <- utils::head(fun(...), 5)
    } else {
      names <- fun(...)
    }
  }

  glue::glue_collapse(
    names |>
      glue::single_quote() %>%
      paste0(
        "{.strong {",
        cli_color_function(color),
        "(", ., ")}}"
      ),
    sep = ", ",
    last = last
  )
}
