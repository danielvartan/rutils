# Generate a QR code

`qr_code()` creates a QR code from a given link and saves it as a
[PNG](https://en.wikipedia.org/wiki/PNG) file.

The QR code has a fixed size: 500 px without a frame, and 450 px when a
frame is included.

## Usage

``` r
qr_code(link, file, logo = NULL, frame = NULL, offset = "+50+50")
```

## Arguments

- link:

  A [`character`](https://rdrr.io/r/base/character.html) string
  containing the link to encode.

- file:

  A [`character`](https://rdrr.io/r/base/character.html) string
  indicating the path to the output file.

- logo:

  (optional) A [`character`](https://rdrr.io/r/base/character.html)
  string indicating the path to a logo image file.

- frame:

  (optional) A [`character`](https://rdrr.io/r/base/character.html)
  string indicating the path to a frame file.

- offset:

  (optional) A [`character`](https://rdrr.io/r/base/character.html)
  string indicating the offset for positioning the QR code within the
  frame.

## Value

An invisible `NULL`. This function is called for its side effects.

## Examples

``` r
library(ggplot2)
library(magick)
#> Linking to ImageMagick 6.9.12.98
#> Enabled features: fontconfig, freetype, fftw, heic, lcms, pango, raw, webp, x11
#> Disabled features: cairo, ghostscript, rsvg
#> Using 4 threads

file <- tempfile()

qr_code(
  link = "https://linktr.ee/danielvartan",
  file = file,
  logo = raw_data_1("linktree-icon.svg", "rutils"),
  frame = raw_data_1("qr-code-frame.svg", "rutils")
)
#> Warning: ImageMagick was built without librsvg which causes poor quality of SVG rendering.
#> For better results use image_read_svg() which uses the rsvg package.
#> Warning: ImageMagick was built without librsvg which causes poor quality of SVG rendering.
#> For better results use image_read_svg() which uses the rsvg package.

file |>
  image_read() |>
  image_ggplot()
#> Warning: `aes_string()` was deprecated in ggplot2 3.0.0.
#> ℹ Please use tidy evaluation idioms with `aes()`.
#> ℹ See also `vignette("ggplot2-in-packages")` for more information.
#> ℹ The deprecated feature was likely used in the magick package.
#>   Please report the issue at <https://github.com/ropensci/magick/issues>.


qr_code(
  link = "https://github.com/danielvartan",
  file = file,
  logo = raw_data_1("github-icon.svg", "rutils"),
  frame = raw_data_1("qr-code-frame.svg", "rutils")
)
#> Warning: ImageMagick was built without librsvg which causes poor quality of SVG rendering.
#> For better results use image_read_svg() which uses the rsvg package.
#> Warning: ImageMagick was built without librsvg which causes poor quality of SVG rendering.
#> For better results use image_read_svg() which uses the rsvg package.

file |>
  image_read() |>
  image_ggplot()
```
