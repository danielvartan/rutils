# Get all the integers between two integers

`inbetween_integers()` returns all the integers between two integers.
This is useful while subsetting a vector.

## Usage

``` r
inbetween_integers(x, y)
```

## Arguments

- x:

  An integer number.

- y:

  An integer number.

## Value

An [`integer`](https://rdrr.io/r/base/integer.html) vector with all the
integers between `x` and `y`.

## See also

Other vector functions.:
[`count_na()`](https://danielvartan.github.io/rutils/reference/count_na.md),
[`drop_na()`](https://danielvartan.github.io/rutils/reference/drop_na.md)

## Examples

``` r
inbetween_integers(1, 5)
#> [1] 2 3 4
#> [1] 2 3 4 # Expected

inbetween_integers(5, 1)
#> [1] 2 3 4
#> [1] 2 3 4 # Expected
```
