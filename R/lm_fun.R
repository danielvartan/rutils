lm_fun <- function(model, fix_all_but = NULL, data = NULL) {
  checkmate::assert_class(model, "lm")

  checkmate::assert_number(
    fix_all_but,
    lower = 1,
    upper = length(stats::coef(model)) - 1,
    null.ok = TRUE
  )

  coef <- broom::tidy(model)
  vars <- letters[seq_len((nrow(coef) - 1))]

  fixed_vars <- vars

  if (!is.null(fix_all_but)) {
    checkmate::assert_data_frame(data)
    # checkmate::assert_subset(coef$term[-1], names(data))

    for (i in seq_along(fixed_vars)[-fix_all_but]) {
      fixed_vars[i] <- mean(data[[coef$term[i + 1]]], na.rm = TRUE)
    }

    vars <- vars[fix_all_but]
  }

  fun_exp <- str2expression(
    glue::glue(
      "function({paste0(vars, collapse = ', ')}) {{", "\n",
      "  {paste0('checkmate::assert_numeric(', vars, ')', collapse = '\n')}",
      "\n\n",
      "  {coef$estimate[1]} +",
      "{paste0(coef$estimate[-1], ' * ', fixed_vars, collapse = ' + ')}",
      "\n",
      "}}"
    )
  )

  out <- eval(fun_exp)

  out
}
