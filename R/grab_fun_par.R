#' Grab all the parameters in a function
#'
#' @description
#'
#' `grab_fun_par()` grabs all parameters defined in a function. It's
#' particularly useful when you need to pass all parameters from one function
#' to another (e.g., using [`do.call()`][base::do.call]).
#'
#' Credits: Function adapted from B. Christian Kamgang's contribution in a
#' [Stack Overflow discussion](https://bit.ly/3QD48Wy).
#'
#' @return A [`list`][base::list] containing the parameters of the function
#'   from which it was called.
#'
#' @family scoping functions.
#' @export
#'
#' @examples
#' foo <- function(a = 1) grab_fun_par()
#'
#' foo()
#' #> $a # Expected
#' #> [1] 1
grab_fun_par <- function() {
  args_names <- ls(envir = parent.frame(), all.names = TRUE, sorted = FALSE)

  if ("..." %in% args_names) {
    dots <- eval(quote(list(...)), envir = parent.frame())
  } else {
    dots <- list()
  }

  args_names <- setdiff(args_names, "...") |> lapply(as.name)
  names(args_names) <- setdiff(args_names, "...")

  if (!length(args_names) == 0) {
    not_dots <- lapply(args_names, eval, envir = parent.frame())
  } else {
    not_dots <- list()
  }

  out <- c(not_dots, dots)

  out[names(out) != ""]
}
