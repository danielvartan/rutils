# Compute the proportion of values in a vector

`prop()` computes the proportion of specified values in a vector.

## Usage

``` r
prop(x, value, na_rm = TRUE)
```

## Arguments

- x:

  An [`atomic`](https://rdrr.io/r/base/vector.html) vector.

- value:

  An [`atomic`](https://rdrr.io/r/base/vector.html) vector containing
  values for which to compute proportions.

- na_rm:

  A [`logical`](https://rdrr.io/r/base/logical.html) flag indicating
  whether to remove `NA` values from `x` before computing proportions
  (default: `TRUE`).

## Value

A [`numeric`](https://rdrr.io/r/base/numeric.html) vector with the
proportions of each value in `value` relative to the total number of
values in `x`.

## See also

Other statistical functions:
[`cut_interval_mean()`](https://danielvartan.github.io/rutils/reference/cut_interval_mean.md),
[`remove_outliers()`](https://danielvartan.github.io/rutils/reference/remove_outliers.md),
[`std_error()`](https://danielvartan.github.io/rutils/reference/std_error.md),
[`test_outlier()`](https://danielvartan.github.io/rutils/reference/test_outlier.md)

## Examples

``` r
prop(c("a", "b", "a", "c", "b", "a"), c("a", "b"))
#> [1] 0.5000000 0.3333333
#> [1] 0.500000 0.3333333 # Expected

prop(c(1, 2, 1, 2, 1), c(1, 2, 5))
#> [1] 0.6 0.4 0.0
#> [1] 0.6 0.4 NA # Expected

prop(c(TRUE, TRUE, TRUE, FALSE), c(TRUE, FALSE))
#> [1] 0.75 0.25
#> [1] 0.75 0.25 # Expected
```
