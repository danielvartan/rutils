# Get paths to `[INSERT PACKAGE NAME]` raw data

`raw_data_1()` returns the raw data paths of the `[INSERT PACKAGE NAME]`
package.

## Usage

``` r
raw_data_1(file = NULL, package = NULL)
```

## Arguments

- file:

  (optional) A [`character`](https://rdrr.io/r/base/character.html)
  vector indicating the file name(s) of the raw data. If `NULL`, all raw
  data file names will be returned (Default: `NULL`).

- package:

  (optional) A [`character`](https://rdrr.io/r/base/character.html)
  string indicating the package with the database data. If `NULL`, the
  function will try to use the basename of the working directory
  (Default: `NULL`).

## Value

If `file == NULL`, a
[`character`](https://rdrr.io/r/base/character.html) vector with all
file names available. Else, a string with the file name path.

## See also

Other R package functions:
[`raw_data_2()`](https://danielvartan.github.io/rutils/reference/raw_data_2.md),
[`update_pkg_versions()`](https://danielvartan.github.io/rutils/reference/update_pkg_versions.md),
[`update_pkg_year()`](https://danielvartan.github.io/rutils/reference/update_pkg_year.md)

## Examples

``` r
if (interactive()) {
## To list all raw data file names available

  raw_data_1()

## To get the file path from a specific raw data

  raw_data_1(raw_data()[1])
}
```
