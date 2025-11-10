# Get paths to `[INSERT PACKAGE NAME]` raw data

`raw_data_2()` returns the raw data paths of the `[INSERT PACKAGE NAME]`
package.

## Usage

``` r
raw_data_2(type = NULL, file = NULL, package = NULL)
```

## Arguments

- type:

  (optional) A [`character`](https://rdrr.io/r/base/character.html)
  string indicating the file type of the raw data (Default: `NULL`).

- file:

  (optional) A [`character`](https://rdrr.io/r/base/character.html)
  vector indicating the file name(s) of the raw data (Default: `NULL`).

- package:

  (optional) A [`character`](https://rdrr.io/r/base/character.html)
  string indicating the package with the database data. If `NULL`, the
  function will try to use the basename of the working directory
  (Default: `NULL`).

## Value

- If `type = NULL`, a `character` vector with all file type names
  available.

- If `type != NULL` and `file = NULL`, a `character` vector with all
  file names available from type.

- If `type != NULL` and `file != NULL`, a `character` vector with the
  file name(s) path.

## See also

Other R package functions:
[`raw_data_1()`](https://danielvartan.github.io/rutils/reference/raw_data_1.md),
[`update_pkg_versions()`](https://danielvartan.github.io/rutils/reference/update_pkg_versions.md),
[`update_pkg_year()`](https://danielvartan.github.io/rutils/reference/update_pkg_year.md)

## Examples

``` r
if (interactive()) {
  raw_data_2()
}
```
