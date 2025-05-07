#' Compute Cohen's d statistic
#'
#' @description
#'
#' `cohens_d()` computes Cohen's d statistic for two independent samples.
#'
#'  This function is based on Cohen (1988) and Frey (2022) calculations
#'  for samples with equal and unequal sizes.
#'
#' @param x A [`numeric`][base::numeric] vector.
#' @param y A [`numeric`][base::numeric] vector.
#' @param t (optional) A [`numeric`][base::numeric] value for the t statistic
#'   (Default: `NULL`).
#' @param abs (optional) A [`logical`][base::logical] flag indicating whether
#'   to return the absolute value of the Cohen's d statistic (Default: `TRUE`).
#'
#' @return A [`numeric`][base::numeric] value representing the Cohen's d
#'   statistic.
#'
#' @family statistical functions.
#' @export
#'
#' @references
#'
#' Cohen, J. (1988). _Statistical power analysis for the behavioral sciences_
#' (2nd ed.). Lawrence Erlbaum Associates.
#'
#' Frey, B. B. (Ed.). (2022). _The SAGE encyclopedia of research design
#' (2. ed.). SAGE Publications. \doi{10.4135/9781071812082}
#'
#' @examples
#' cohens_d(c(1, 2, 3, 4, 5), c(6, 7, 8, 9, 10))
#' #> [1] 3.162278 # Expected
cohens_d <- function(x, y, t = NULL, abs = TRUE) {
  checkmate::assert_numeric(x)
  checkmate::assert_numeric(y)
  checkmate::assert_number(t, null.ok = TRUE)
  checkmate::assert_flag(abs)

  x_n <- length(x)
  y_n <- length(y)
  df <- x_n + y_n - 2

  if (!is.null(t)) {
    # Frey (2022) | Equation 9
    out <- (t * (x_n + y_n)) / (sqrt(df) * sqrt(x_n * y_n))
  } else {
    # Frey (2022) | Equation 7
    # Only when sample sizes are equal.
    sd_pooled <- sqrt(
      (stats::var(x, na.rm = TRUE) + stats::var(y, na.rm = TRUE)) / 2
    )

    out <- (mean(x, na.rm = FALSE) - mean(y, na.rm = FALSE)) / sd_pooled
  }

  if (isTRUE(abs)) {
    abs(out)
  } else {
    out
  }
}
