# Convert a color name to hexadecimal format

`col2hex()` converts a color name present in
[`grDevices::colors()`](https://rdrr.io/r/grDevices/colors.html) to
hexadecimal format.

## Usage

``` r
col2hex(x)
```

## Arguments

- x:

  A character vector of color names present in
  [`grDevices::colors()`](https://rdrr.io/r/grDevices/colors.html). Hex
  colors are returned as is.

## Value

A [`character`](https://rdrr.io/r/base/character.html) vector of
hexadecimal color codes.

## Details

Adapted from Mikael Jagan's contribution in a [Stack Overflow
discussion](https://stackoverflow.com/a/70121688/8258804).

## Examples

``` r
col2hex("red")
#> [1] "#FF0000"
#> [1] "#FF0000"

col2hex(c("red", "green", "blue"))
#> [1] "#FF0000" "#00FF00" "#0000FF"
#> [1] "#FF0000" "#00FF00" "#0000FF"

col2hex(c("red", "#000"))
#> [1] "#FF0000" "#000000"
#> [1] "#FF0000" "#000000"
```
