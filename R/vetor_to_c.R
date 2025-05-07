#' Put a vector into `c()`
#'
#' @description
#'
#' `vector_to_c()` put a vector into the [`c()`][base::c] function.
#'
#' This function is useful when you want to assign values in a vector
#' while programming in R.
#'
#' @param x An [`atomic`][checkmate::test_atomic] vector.
#' @param quote A [`logical`][base::logical] flag indicating if the values
#'   should be wrapped in double quotes (Default: `TRUE`).
#' @param clipboard A [`logical`][base::logical] flag indicating if the output
#'   should be copied to the clipboard (Default: `TRUE`).
#'
#' @return A [`character`][base::character] string with all values from `x`
#'   inside the [`c()`][base::c] function.
#'
#' @family parsing/conversion functions.
#' @export
#'
#' @examples
#' vector_to_c(letters[1:5], clipboard = FALSE)
#' #> c("a", "b", "c", "d", "e") # Expected
#'
#' vector_to_c(1:5, quote = FALSE, clipboard = FALSE)
#' #> c(1, 2, 3, 4, 5) # Expected
vector_to_c <- function(x, quote = TRUE, clipboard = TRUE) {
  checkmate::assert_atomic(x)

  if (isTRUE(quote)) x <- paste0('"', x, '"')

  out <- paste0("c(", paste(x, collapse = ", "), ")")

  if (isTRUE(clipboard)) {
    cli::cli_alert_info("Copied to clipboard.")

    out |> clipr::write_clip()
  }

  cat(out)

  out
}
