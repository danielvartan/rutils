# Remove `NA` values from an atomic object

`drop_na()` remove all `NA` values from an atomic object.

## Usage

``` r
drop_na(x)
```

## Arguments

- x:

  An
  [`atomic`](https://mllg.github.io/checkmate/reference/checkAtomic.html)
  object of any type.

## Value

An object of the same type as `x` with all `NA` values removed.

## See also

Other vector functions.:
[`count_na()`](https://danielvartan.github.io/rutils/reference/count_na.md),
[`inbetween_integers()`](https://danielvartan.github.io/rutils/reference/inbetween_integers.md)

## Examples

``` r
drop_na(c(1, NA, 2, 3, NA, 4))
#> [1] 1 2 3 4
#> [1] 1 2 3 4 # Expected

drop_na(c("a", NA, "b", "c"))
#> [1] "a" "b" "c"
#> [1] "a" "b" "c" # Expected
```
