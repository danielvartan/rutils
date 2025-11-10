# Compute the standard error of the sample mean

`std_error()` computes the [standard
error](https://en.wikipedia.org/wiki/Standard_error) of the sample mean.

## Usage

``` r
std_error(x)
```

## Arguments

- x:

  A [`numeric`](https://rdrr.io/r/base/numeric.html) vector with the
  sample data.

## Value

A number representing the standard error.

## Details

The [standard error](https://en.wikipedia.org/wiki/Standard_error) can
be estimated by the standard deviation of the sample
(\\\sigma\_{\bar{x}}\\) divided by the square root of the sample size
(\\\sqrt{n}\\).

\$\$\sigma\_{\bar{x}} = \frac{\sigma}{\sqrt{n}} \approx
\frac{s}{\sqrt{n}}\$\$

## See also

Other statistical functions:
[`cut_interval_mean()`](https://danielvartan.github.io/rutils/reference/cut_interval_mean.md),
[`prop()`](https://danielvartan.github.io/rutils/reference/prop.md),
[`remove_outliers()`](https://danielvartan.github.io/rutils/reference/remove_outliers.md),
[`test_outlier()`](https://danielvartan.github.io/rutils/reference/test_outlier.md)

## Examples

``` r
1:100 |> std_error() |> round(5)
#> [1] 2.90115
#> [1] 2.90115 # Expected
```
