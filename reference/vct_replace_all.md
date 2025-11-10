# Replace values in a vector

`vct_replace_all()` replaces values in a vector with a specified value.

## Usage

``` r
vct_replace_all(x, replacement = na_as(x), except = NULL, preserve_nas = FALSE)
```

## Arguments

- x:

  An
  [`atomic`](https://mllg.github.io/checkmate/reference/checkAtomic.html)
  vector.

- replacement:

  (optional) A single value to replace the values in `x` (Default:
  `na_as(x)`).

- except:

  (optional) A vector of values to exclude from replacement.

- preserve_nas:

  (optional) A [`logical`](https://rdrr.io/r/base/logical.html) flag to
  indicating if the function must preserve `NA` values in `x` (Default:
  `FALSE`).

## Value

The same type of object in `x` with the values replaced.

## See also

Other conditional functions:
[`swap_if()`](https://danielvartan.github.io/rutils/reference/swap_if.md)

## Examples

``` r
vct_replace_all(1:10)
#>  [1] NA NA NA NA NA NA NA NA NA NA
#> [1] NA NA NA NA NA NA NA NA NA NA

vct_replace_all(1:10, replacement = 0L, except = 5:7)
#>  [1] 0 0 0 0 5 6 7 0 0 0
#> [1] 0 0 0 0 5 6 7 0 0 0

vct_replace_all(c("a", "b", NA, "c"), replacement = "d", preserve_nas = TRUE)
#> [1] "d" "d" NA  "d"
#> [1] "d" "d" NA  "d"
```
