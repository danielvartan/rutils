# Update the year in system files of a package

`update_pkg_year()` updates the year in system files of a package.

## Usage

``` r
update_pkg_year(
  file = c(here::here("LICENSE"), here::here("LICENSE.md"), here::here("inst",
    "CITATION"))
)
```

## Arguments

- file:

  (optional) A [`character`](https://rdrr.io/r/base/character.html)
  vector indicating the path of the files that must be updated. Default
  to `LICENSE`, `LICENSE.md`, and `inst/CITATION`.

## Value

An invisible `NULL`. This function is used for its side effect.

## See also

Other R package functions:
[`raw_data_1()`](https://danielvartan.github.io/rutils/reference/raw_data_1.md),
[`raw_data_2()`](https://danielvartan.github.io/rutils/reference/raw_data_2.md),
[`update_pkg_versions()`](https://danielvartan.github.io/rutils/reference/update_pkg_versions.md)
