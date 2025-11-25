# Convert a `list` to a `tibble` in long format

`list_as_tibble()` converts a [`list`](https://rdrr.io/r/base/list.html)
to a [`tibble`](https://tibble.tidyverse.org/reference/tibble.html),
pivoting it to long format.

## Usage

``` r
list_as_tibble(list)
```

## Arguments

- list:

  A [`list`](https://rdrr.io/r/base/list.html) to be converted.

## Value

A [`tibble`](https://tibble.tidyverse.org/reference/tibble.html) with
two columns: `name` and `value`, where `name` corresponds to the
original [`list`](https://rdrr.io/r/base/list.html) element names and
`value` to their respective values as
[`character`](https://rdrr.io/r/base/character.html)\` strings.

## See also

Other parsing/conversion functions.:
[`vector_to_c()`](https://danielvartan.github.io/rutils/reference/vector_to_c.md)

## Examples

``` r
list(a = 1, b = "a", c = TRUE) |>
  list_as_tibble()
#> # A tibble: 3 × 2
#>   name  value
#>   <chr> <chr>
#> 1 a     1    
#> 2 b     a    
#> 3 c     TRUE 
```
