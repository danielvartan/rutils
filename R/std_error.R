#' Compute the standard error of the sample mean
#'
#' @description
#'
#' `std_error()` computes the
#' [standard error](https://en.wikipedia.org/wiki/Standard_error)
#' of the sample mean.
#'
#' @details
#'
#' The [standard error](https://en.wikipedia.org/wiki/Standard_error)
#' can be estimated by the standard deviation of the sample
#' (\eqn{\sigma_{\bar{x}}}) divided by the square root of the sample size
#' (\eqn{\sqrt{n}}).
#'
#' \deqn{\sigma_{\bar{x}} = \frac{\sigma}{\sqrt{n}} \approx
#' \frac{s}{\sqrt{n}}}
#'
#' @param x A [`numeric`][base::numeric] vector with the sample data.
#'
#' @return A number representing the standard error.
#'
#' @family statistical functions
#' @export
#'
#' @examples
#' 1:100 |> std_error() |> round(5)
#' #> [1] 2.90115 # Expected
std_error <- function(x) {
  checkmate::assert_numeric(x)

  stats::sd(x, na.rm = TRUE) / sqrt(length(x))
}
