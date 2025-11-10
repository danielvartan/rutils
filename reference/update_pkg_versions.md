# Update package versions in the `DESCRIPTION` file

`update_pkg_versions()` updates the version of packages listed in the
`DESCRIPTION` file of an R package with their installed versions.

If the package comes with an typical installation of R (e.g., base,
utils), the function will update the version to the previous minor
version of the current R version. This is made to avoid errors with
CI/CD.

## Usage

``` r
update_pkg_versions(
  file = here::here("DESCRIPTION"),
  old_r_version = bump_back_r_version()
)
```

## Arguments

- file:

  (optional) A string indicating the path to the `DESCRIPTION` file.

- old_r_version:

  (optional) A string indicating the previous minor version of the
  current R version.

## Value

An invisible `NULL`. This function is used for its side effect.

## See also

Other R package functions:
[`raw_data_1()`](https://danielvartan.github.io/rutils/reference/raw_data_1.md),
[`raw_data_2()`](https://danielvartan.github.io/rutils/reference/raw_data_2.md),
[`update_pkg_year()`](https://danielvartan.github.io/rutils/reference/update_pkg_year.md)
