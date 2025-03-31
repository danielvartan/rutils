# See <https://doi.org/10.1037/0033-2909.112.1.155> and
# <https://doi.org/10.3389/fpsyg.2012.00111> to learn more.

cohens_f_squared <- function(base_r_squared, new_r_squared = NULL) {
  checkmate::assert_number(base_r_squared, lower = 0, upper = 1)
  checkmate::assert_number(
    new_r_squared, lower = 0, upper = 1, null.ok = TRUE
  )

  if (is.null(new_r_squared)) {
    base_r_squared / (1 - base_r_squared)
  } else {
    (new_r_squared - base_r_squared) / (1 - new_r_squared)
  }
}

cohens_f_squared_effect_size <- function(f_squared) {
  checkmate::assert_number(f_squared, lower = 0)

  dplyr::case_when(
    f_squared >= 0.35 ~ "Large",
    f_squared >= 0.15 ~ "Medium",
    f_squared >= 0.02 ~ "Small",
    TRUE ~ "Negligible"
  )
}

cohens_f_squared_summary <- function(
    base_r_squared, #nolint
    new_r_squared = NULL
  ) {
  if (is.atomic(base_r_squared)) {
    checkmate::assert_number(base_r_squared, lower = 0, upper = 1)
    checkmate::assert_number(
      new_r_squared, lower = 0, upper = 1, null.ok = TRUE
    )

    f_squared <- cohens_f_squared(base_r_squared, new_r_squared)

    list(
      f_squared = f_squared,
      effect_size = cohens_f_squared_effect_size(f_squared)
    )
  } else {
    # psychometric::CI.Rsq()
    col_check <- c("R2", "SE", "Lower CI", "Upper CI")

    checkmate::assert_data_frame(base_r_squared)
    checkmate::assert_set_equal(base_r_squared[[1]], col_check)
    checkmate::assert_data_frame(new_r_squared)
    checkmate::assert_set_equal(new_r_squared[[1]], col_check)

    f_values <- c(
      cohens_f_squared(base_r_squared$value[4], new_r_squared$value[4]),
      cohens_f_squared(base_r_squared$value[4], new_r_squared$value[3]),
      cohens_f_squared(base_r_squared$value[3], new_r_squared$value[[4]]),
      cohens_f_squared(base_r_squared$value[3], new_r_squared$value[3])
    )

    min_f <- ifelse(min(f_values) < 0, 0, min(f_values))
    max_f <- ifelse(max(f_values) < 0, 0, max(f_values))

    list(
      f_squared = cohens_f_squared(
        base_r_squared$value[1],
        new_r_squared$value[1]
      ),
      lower_ci_limit = min_f,
      upper_ci_limit = max_f,
      effect_size = cohens_f_squared_effect_size(min_f)
    )
  }
}
