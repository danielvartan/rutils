#' Remove outliers from a numeric vector
#'
#' @description
#'
#' `r lifecycle::badge("stable")`
#'
#' `remove_outliers()` removes outliers from a numeric vector using either the
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
#' @param x A [`numeric`][base::numeric] vector from which to remove outliers.
#'
#' @return A [`numeric`][base::numeric] vector with outliers removed.
#'
#' @inheritParams test_outlier
#' @family statistical functions
#' @export
#'
#' @examples
#' remove_outliers(c(1, 2, 3, 4, 5), method = "iqr")
#' #> [1] 1 2 3 4 5 # Expected
#'
#' remove_outliers(c(1, 2, 3, 4, 10), method = "iqr")
#' #> [1] 1 2 3 4 # Expected
#'
#' remove_outliers(c(1, 5, 6, 7, 10), method = "iqr", iqr_mult = 1)
#' #> [1] 5 6 7 # Expected
#'
#' remove_outliers(c(1, 2, 3, 4, 5), method = "sd", sd_mult = 1)
#' #> [1] 2 3 4 # Expected
#'
#' remove_outliers(c(1, 2, 3, 4, 100), method = "sd", sd_mult = 1)
#' #> [1] 1 2 3 4 # Expected
remove_outliers <- function(
    x, #nolint
    method = "iqr",
    iqr_mult = 1.5,
    sd_mult = 3
  ) {
  checkmate::assert_numeric(x)
  checkmate::assert_choice(method, c("iqr", "sd"))
  checkmate::assert_number(iqr_mult, lower = 1)
  checkmate::assert_number(sd_mult, lower = 1)

  # R CMD Check variable bindings fix
  # nolint start
  . <- NULL
  # nolint end

  x |>
    test_outlier(
      method = method,
      iqr_mult = iqr_mult,
      sd_mult = sd_mult
    ) %>% # Don't change the pipe.
    `!`() %>% # Don't change the pipe.
    magrittr::extract(x, .)
}
