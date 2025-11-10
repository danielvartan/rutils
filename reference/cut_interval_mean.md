# Compute the interval means of a cut factor

`cut_interval_mean()` computes the interval means of a
[`cut`](https://rdrr.io/r/base/cut.html) factor, regardless of the their
open or closed nature.

## Usage

``` r
cut_interval_mean(x, round = FALSE, names = FALSE)
```

## Arguments

- x:

  A [`factor`](https://rdrr.io/r/base/factor.html) or
  [`character`](https://rdrr.io/r/base/character.html) vector with
  [`cut`](https://rdrr.io/r/base/cut.html) intervals.

- round:

  A [`logical`](https://rdrr.io/r/base/logical.html) flag indicating
  whether to round the means to
  ``` 0`` decimal places (Default:  ```FALSE\`).

- names:

  A [`logical`](https://rdrr.io/r/base/logical.html) flag indicating
  whether to name the output vector with the original intervals
  (Default: `FALSE`).

## Value

A [`numeric`](https://rdrr.io/r/base/numeric.html) vector with the
interval means.

## See also

Other statistical functions:
[`prop()`](https://danielvartan.github.io/rutils/reference/prop.md),
[`remove_outliers()`](https://danielvartan.github.io/rutils/reference/remove_outliers.md),
[`std_error()`](https://danielvartan.github.io/rutils/reference/std_error.md),
[`test_outlier()`](https://danielvartan.github.io/rutils/reference/test_outlier.md)

## Examples

``` r
cut(1:5, breaks = 3)
#> [1] (0.996,2.33] (0.996,2.33] (2.33,3.67]  (3.67,5]     (3.67,5]    
#> Levels: (0.996,2.33] (2.33,3.67] (3.67,5]
#> [1] (0.996,2.33] (0.996,2.33] (2.33,3.67]  (3.67,5] # Expected
#> [5] (3.67,5]
#> Levels: (0.996,2.33] (2.33,3.67] (3.67,5]

cut(1:5, breaks = 3) |> cut_interval_mean()
#> [1] 1.663 1.663 3.000 4.335 4.335
#> [1] 1.663 1.663 3.000 4.335 4.335 # Expected

cut(1:5, breaks = 3) |> cut_interval_mean(names = TRUE)
#> (0.996,2.33] (0.996,2.33]  (2.33,3.67]     (3.67,5]     (3.67,5] 
#>        1.663        1.663        3.000        4.335        4.335 
#> # Expected
#> (0.996,2.33] (0.996,2.33]  (2.33,3.67]     (3.67,5]     (3.67,5]
#>       1.663        1.663        3.000        4.335        4.335

cut(1:5, breaks = 3) |> cut_interval_mean(round = TRUE)
#> [1] 2 2 3 4 4
#> [1] 2 2 3 4 4 # Expected
```
