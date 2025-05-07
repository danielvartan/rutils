#' Test for outliers in a numeric vector
#'
#' @description
#'
#' `test_outlier()` identifies outliers in a numeric vector using either the
#' interquartile range (IQR) method or the standard deviation (SD) method.
#'
#' @details
#'
#' When using the `"iqr"` method, values are considered outliers if they are
#' below `Q1 - (iqr_mult * IQR)` or above `Q3 + (iqr_mult * IQR)`, where `Q1`
#' is the first quartile, `Q3` is the third quartile, and `IQR` is the
#' interquartile range.
#'
#' When using the `"sd"` method, values are considered outliers if they are
#' below `mean - (sd_mult * SD)` or above `mean + (sd_mult * SD)`, where `SD`
#' is the standard deviation.
#'
#' @param x A [`numeric`][base::numeric] vector to test for outliers.
#' @param method (optional) A [`character`][base::character] string specifying
#'   the outlier detection method. Must be either `"iqr"` for interquartile
#'   range method or `"sd"` for standard deviation method (Default: `"iqr"`).
#' @param iqr_mult (optional) A [`numeric`][base::numeric] multiplier for the
#'   IQR threshold (Default: `1.5`).
#' @param sd_mult (optional) A [`numeric`][base::numeric] multiplier for the
#'   standard deviation threshold (Default: `3`).
#'
#' @return A [`logical`][base::logical] vector of the same length as `x` with
#'   `TRUE` for outliers and `FALSE` for non-outliers.
#'
#' @family statistical functions
#' @export
#'
#' @examples
#' test_outlier(c(1, 2, 3, 4, 5), method = "iqr")
#' #> [1] FALSE FALSE FALSE FALSE FALSE # Expected
#'
#' test_outlier(c(1, 2, 3, 4, 10), method = "iqr")
#' #> [1] FALSE FALSE FALSE FALSE  TRUE # Expected
#'
#' test_outlier(c(1, 5, 6, 7, 10), method = "iqr", iqr_mult = 1)
#' #> [1]  TRUE FALSE FALSE FALSE  TRUE # Expected
#'
#' test_outlier(c(1, 2, 3, 4, 5), method = "sd", sd_mult = 1)
#' #> [1] TRUE FALSE FALSE FALSE  TRUE # Expected
#'
#' test_outlier(c(1, 2, 3, 4, 100), method = "sd", sd_mult = 1)
#' #> [1] FALSE FALSE FALSE FALSE  TRUE # Expected
test_outlier <- function(
  x,
  method = "iqr",
  iqr_mult = 1.5,
  sd_mult = 3
) {
  checkmate::assert_numeric(x)
  checkmate::assert_choice(method, c("iqr", "sd"))
  checkmate::assert_number(iqr_mult, lower = 1)
  checkmate::assert_number(sd_mult, lower = 1)

  if (length(unique(x)) == 1) {
    rep(FALSE, length(x))
  } else {
    if (method == "iqr") {
      iqr <- stats::IQR(x, na.rm = TRUE)
      min <- stats::quantile(x, 0.25, na.rm = TRUE) - (iqr_mult * iqr)
      max <- stats::quantile(x, 0.75, na.rm = TRUE) + (iqr_mult * iqr)
    } else if (method == "sd") {
      min <- mean(x, na.rm = TRUE) - (sd_mult * stats::sd(x, na.rm = TRUE))
      max <- mean(x, na.rm = TRUE) + (sd_mult * stats::sd(x, na.rm = TRUE))
    }

    dplyr::if_else(x > min & x < max, FALSE, TRUE, missing = FALSE)
  }
}
