# library(checkmate)
# library(here)
# library(magick)
# library(qrcode)
# library(rsvg)

#' Generate a QR code
#'
#' @description
#'
#' `qr_code()` creates a QR code from a given link and saves it as a
#' [PNG](https://en.wikipedia.org/wiki/PNG) file.
#'
#' The QR code has a fixed size: 500 px without a frame, and 450 px when a
#' frame is included.
#'
#' @param link A [`character`][base::character] string containing the link to
#'   encode.
#' @param file A [`character`][base::character] string indicating the path to
#'   the output file.
#' @param logo (optional) A [`character`][base::character] string indicating
#'   the path to a logo image file.
#' @param frame (optional) A [`character`][base::character] string indicating
#'   the path to a frame file.
#' @param offset (optional) A [`character`][base::character] string indicating
#'   the offset for positioning the QR code within the frame.
#'
#' @return An invisible `NULL`. This function is called for its side effects.
#'
#' @family image functions
#' @export
#'
#' @examples
#' library(ggplot2)
#' library(magick)
#'
#' file <- tempfile()
#'
#' qr_code(
#'   link = "https://linktr.ee/danielvartan",
#'   file = file,
#'   logo = raw_data_1("linktree-icon.svg", "rutils"),
#'   frame = raw_data_1("qr-code-frame.svg", "rutils")
#' )
#'
#' file |>
#'   image_read() |>
#'   image_ggplot()
#'
#' qr_code(
#'   link = "https://github.com/danielvartan",
#'   file = file,
#'   logo = raw_data_1("github-icon.svg", "rutils"),
#'   frame = raw_data_1("qr-code-frame.svg", "rutils")
#' )
#'
#' file |>
#'   image_read() |>
#'   image_ggplot()
qr_code <- function(
  link,
  file,
  logo = NULL,
  frame = NULL,
  offset = "+50+50"
) {
  checkmate::assert_string(link)
  checkmate::assert_string(file)
  checkmate::assert_path_for_output(file, overwrite = TRUE)
  checkmate::assert_string(logo, null.ok = TRUE)
  checkmate::assert_string(frame, null.ok = TRUE)
  checkmate::assert_string(offset)

  rsvg::librsvg_version() # For R CMD Check

  qr_code_file <- tempfile()

  qr_code <- link |>  qrcode::qr_code(ecl = "H")

  if (!is.null(logo)) {
    checkmate::assert_file_exists(logo)

    qr_code <-
      qr_code |>
      qrcode::add_logo(
        logo = logo,
        ecl = "L"
      )
  }

  qr_code |>
    qrcode::generate_svg(
      filename = qr_code_file,
      size = 530,
      show = FALSE
    )

  if (!is.null(frame)) {
    checkmate::assert_file_exists(frame)

    qr_code <-
      qr_code_file |>
      magick::image_read() |>
      magick::image_trim() |>
      magick::image_resize("450x450!")

    # magick::image_info(qr_code)
    # magick::image_display(qr_code)

    frame <- frame |> magick::image_read()

    # magick::image_info(frame)
    # magick::image_display(frame)

    composite <- magick::image_composite(
      image = frame,
      composite_image = qr_code,
      offset = offset
    )

    # magick::image_info(composite)
    # magick::image_display(composite)

    composite |>
      magick::image_write(
        path = file,
        format = "png",
        quality = 100,
        flatten = TRUE
      )
  } else {
    qr_code_file |>
      magick::image_read() |>
      magick::image_write(
        path = file,
        format = "png",
        quality = 100,
        flatten = TRUE
      )
  }

  invisible()
}
