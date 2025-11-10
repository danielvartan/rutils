# Find the most frequent value in a vector

`mode()` returns the most frequent value in a vector.

If there are more than one mode, it returns all of them. If all values
are unique, it returns `NA`.

## Usage

``` r
mode(x)
```

## Arguments

- x:

  An [`atomic`](https://rdrr.io/r/base/is.recursive.html) vector.

## Value

An [`atomic`](https://rdrr.io/r/base/is.recursive.html) vector
containing the mode(s) of `x`.

## See also

Other statistical functions.:
[`cohens_d()`](https://danielvartan.github.io/rutils/reference/cohens_d.md)

## Examples

``` r
mode(c(1, 2, 3, 4, 5, 6))
#> [1] NA
#> [1] NA # Expected

mode(c(1, 2, 3, 4, 5, 5, 6))
#> [1] 5
#> [1] 5 # Expected

mode(c(1, 2, 3, 4, 5, 5, 6, NA))
#> [1] 5
#> [1] 5 # Expected

mode(c(1, 2, 3, 4, 5, 5, 6, 6))
#> [1] 5 6
#> [1] 5 6 # Expected
```
