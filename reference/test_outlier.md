# Test for outliers in a numeric vector

`test_outlier()` identifies outliers in a numeric vector using either
the interquartile range (IQR) method or the standard deviation (SD)
method.

## Usage

``` r
test_outlier(x, method = "iqr", iqr_mult = 1.5, sd_mult = 3)
```

## Arguments

- x:

  A [`numeric`](https://rdrr.io/r/base/numeric.html) vector to test for
  outliers.

- method:

  (optional) A [`character`](https://rdrr.io/r/base/character.html)
  string specifying the outlier detection method. Must be either `"iqr"`
  for interquartile range method or `"sd"` for standard deviation method
  (Default: `"iqr"`).

- iqr_mult:

  (optional) A [`numeric`](https://rdrr.io/r/base/numeric.html)
  multiplier for the IQR threshold (Default: `1.5`).

- sd_mult:

  (optional) A [`numeric`](https://rdrr.io/r/base/numeric.html)
  multiplier for the standard deviation threshold (Default: `3`).

## Value

A [`logical`](https://rdrr.io/r/base/logical.html) vector of the same
length as `x` with `TRUE` for outliers and `FALSE` for non-outliers.

## Details

When using the `"iqr"` method, values are considered outliers if they
are below `Q1 - (iqr_mult * IQR)` or above `Q3 + (iqr_mult * IQR)`,
where `Q1` is the first quartile, `Q3` is the third quartile, and `IQR`
is the interquartile range.

When using the `"sd"` method, values are considered outliers if they are
below `mean - (sd_mult * SD)` or above `mean + (sd_mult * SD)`, where
`SD` is the standard deviation.

## See also

Other statistical functions:
[`cut_interval_mean()`](https://danielvartan.github.io/rutils/reference/cut_interval_mean.md),
[`prop()`](https://danielvartan.github.io/rutils/reference/prop.md),
[`remove_outliers()`](https://danielvartan.github.io/rutils/reference/remove_outliers.md),
[`std_error()`](https://danielvartan.github.io/rutils/reference/std_error.md)

## Examples

``` r
test_outlier(c(1, 2, 3, 4, 5), method = "iqr")
#> [1] FALSE FALSE FALSE FALSE FALSE
#> [1] FALSE FALSE FALSE FALSE FALSE # Expected

test_outlier(c(1, 2, 3, 4, 10), method = "iqr")
#> [1] FALSE FALSE FALSE FALSE  TRUE
#> [1] FALSE FALSE FALSE FALSE  TRUE # Expected

test_outlier(c(1, 5, 6, 7, 10), method = "iqr", iqr_mult = 1)
#> [1]  TRUE FALSE FALSE FALSE  TRUE
#> [1]  TRUE FALSE FALSE FALSE  TRUE # Expected

test_outlier(c(1, 2, 3, 4, 5), method = "sd", sd_mult = 1)
#> [1]  TRUE FALSE FALSE FALSE  TRUE
#> [1] TRUE FALSE FALSE FALSE  TRUE # Expected

test_outlier(c(1, 2, 3, 4, 100), method = "sd", sd_mult = 1)
#> [1] FALSE FALSE FALSE FALSE  TRUE
#> [1] FALSE FALSE FALSE FALSE  TRUE # Expected
```
