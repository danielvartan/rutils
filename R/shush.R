#' Suppress messages and warnings
#'
#' @description
#'
#' `shush()` is a wrapper around `suppressMessages()` and `suppressWarnings()`
#' that allows you to suppress messages and warnings in a single function call.
#' It was designed to be used with pipes.
#'
#' @param x Any expression, usually a function call.
#' @param quiet (optional) A [logical][base::as.logical()] flag value indicating
#'   whether to suppress messages and warnings. This is can be used for
#'   condition messages and warnings inside functions (Default: `TRUE`).
#'
#' @return The same object as `x` with messages and warnings suppressed.
#'
#' @family dialog functions.
#' @export
#'
#' @examples
#' message("test") |> shush()
#' message("test") |> shush(quiet = FALSE)
#' #> test # Expected
#'
#' warning("test") |> shush()
#' warning("test") |> shush(quiet = FALSE)
#' #> Warning: test # Expected
shush <- function(x, quiet = TRUE) {
  if (isTRUE(quiet)) {
    suppressMessages(suppressWarnings(x))
  } else {
    x
  }
}
