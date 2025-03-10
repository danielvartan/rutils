lm_str_fun <- function(
    model, #nolint
    digits = 3,
    latex2exp = TRUE,
    fix_all_but = NULL, # Ignore the intercept coefficient.
    fix_fun = "Mean",
    coef_names = NULL # Ignore the intercept coefficient.
  ) {
  checkmate::assert_class(model, "lm")
  checkmate::assert_number(digits)
  checkmate::assert_flag(latex2exp)

  checkmate::assert_number(
    fix_all_but,
    lower = 1,
    upper = length(stats::coef(model)) - 1,
    null.ok = TRUE
  )

  checkmate::assert_string(fix_fun)

  checkmate::assert_character(
    coef_names,
    any.missing = FALSE,
    len = length(names(stats::coef(model))) - 1,
    null.ok = TRUE
  )

  if (is.null(coef_names)) coef_names <- names(stats::coef(model))[-1]

  coef <- list()

  for (i in seq_along(coef_names)) {
    coef[[coef_names[i]]] <-
      stats::coef(model) |>
      magrittr::extract(i + 1) |>
      clear_names() |>
      round(digits)
  }

  coef_names <-
    coef_names |>
    stringr::str_replace_all("\\_|\\.", " ") |>
    stringr::str_to_title() |>
    stringr::str_replace(" ", "")

  if (!is.null(fix_all_but)) {
    for (i in seq_along(coef_names)[-fix_all_but]) {
      coef_names[i] <- paste0(fix_fun, "(", coef_names[i], ")")
    }
  }

  out <- paste0(
    "$", "y =", " ",
    round(stats::coef(model)[1], digits), " + ",
    paste0(coef, " \\times ", coef_names, collapse = " + "),
    "$"
  )

  out <- out |> stringr::str_replace("\\+ \\-", "\\- ")

  if (isTRUE(latex2exp)) {
    out |> latex2exp::TeX()
  } else {
    out
  }
}
