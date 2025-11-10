# Remove outliers from a numeric vector

`remove_outliers()` removes outliers from a numeric vector using either
the interquartile range (IQR) method or the standard deviation (SD)
method.

## Usage

``` r
remove_outliers(x, method = "iqr", iqr_mult = 1.5, sd_mult = 3)
```

## Arguments

- x:

  A [`numeric`](https://rdrr.io/r/base/numeric.html) vector from which
  to remove outliers.

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

A [`numeric`](https://rdrr.io/r/base/numeric.html) vector with outliers
removed.

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
[`std_error()`](https://danielvartan.github.io/rutils/reference/std_error.md),
[`test_outlier()`](https://danielvartan.github.io/rutils/reference/test_outlier.md)

## Examples

``` r
remove_outliers(c(1, 2, 3, 4, 5), method = "iqr")
#> [1] 1 2 3 4 5
#> [1] 1 2 3 4 5 # Expected

remove_outliers(c(1, 2, 3, 4, 10), method = "iqr")
#> [1] 1 2 3 4
#> [1] 1 2 3 4 # Expected

remove_outliers(c(1, 5, 6, 7, 10), method = "iqr", iqr_mult = 1)
#> [1] 5 6 7
#> [1] 5 6 7 # Expected

remove_outliers(c(1, 2, 3, 4, 5), method = "sd", sd_mult = 1)
#> [1] 2 3 4
#> [1] 2 3 4 # Expected

remove_outliers(c(1, 2, 3, 4, 100), method = "sd", sd_mult = 1)
#> [1] 1 2 3 4
#> [1] 1 2 3 4 # Expected
```
