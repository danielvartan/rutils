# Count the amount of `NA` values in a vector

`count_na()` counts the amount of `NA` values in a vector.

## Usage

``` r
count_na(x)
```

## Arguments

- x:

  An
  [`atomic`](https://mllg.github.io/checkmate/reference/checkAtomic.html)
  object of any type.

## Value

An [`integer`](https://rdrr.io/r/base/integer.html) number with the
amount of `NA` values in `x`.

## See also

Other vector functions.:
[`drop_na()`](https://danielvartan.github.io/rutils/reference/drop_na.md),
[`inbetween_integers()`](https://danielvartan.github.io/rutils/reference/inbetween_integers.md)

## Examples

``` r
count_na(c(1, 2, NA, 4, 5))
#> [1] 1
#> [1] 1 # Expected

count_na(c(1, 2, 3, 4, 5))
#> [1] 0
#> [1] 0 # Expected

count_na(c(NA, NA, NA, NA, NA))
#> [1] 5
#> [1] 5 # Expected
```
