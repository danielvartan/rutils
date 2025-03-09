#' Convert a color name to hexadecimal format
#'
#' @description
#'
#' `r lifecycle::badge("stable")`
#'
#' `col2hex()` converts a color name present in
#' [`grDevices::colors()`][grDevices::colors] to hexadecimal format.
#'
#' @details
#'
#' Adapted from Mikael Jagan's contribution in a
#' [Stack Overflow discussion](https://stackoverflow.com/a/70121688/8258804).
#'
#' @param x A character vector of color names present in
#'   [`grDevices::colors()`][grDevices::colors]. Hex colors are returned
#'   as is.
#'
#' @return A [`character`][base::character] vector of hexadecimal color codes.
#'
#' @family color functions
#' @export
#'
#' @examples
#' col2hex("red")
#' #> [1] "#FF0000"
#'
#' col2hex(c("red", "green", "blue"))
#' #> [1] "#FF0000" "#00FF00" "#0000FF"
#'
#' col2hex(c("red", "#000"))
#' #> [1] "#FF0000" "#000000"
col2hex <- function(x) {
  checkmate::assert_character(x)
  # prettycheck::assert_color(x, any_missing = TRUE)

  dplyr::case_when(
    grepl("(?i)^#[a-f0-9]{8}$", x) ~ x,
    is.na(x) ~ NA_character_,
    TRUE ~
      x |>
        grDevices::col2rgb() |>
        t() |>
        as.data.frame() |>
        c(list(names = x, maxColorValue = 255)) |>
        do.call(grDevices::rgb, args = _) |>
        unname()
  )
}
