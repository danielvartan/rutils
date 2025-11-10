# Put a vector into `c()`

`vector_to_c()` put a vector into the
[`c()`](https://rdrr.io/r/base/c.html) function.

This function is useful when you want to assign values in a vector while
programming in R.

## Usage

``` r
vector_to_c(x, quote = TRUE, clipboard = TRUE)
```

## Arguments

- x:

  An
  [`atomic`](https://mllg.github.io/checkmate/reference/checkAtomic.html)
  vector.

- quote:

  A [`logical`](https://rdrr.io/r/base/logical.html) flag indicating if
  the values should be wrapped in double quotes (Default: `TRUE`).

- clipboard:

  A [`logical`](https://rdrr.io/r/base/logical.html) flag indicating if
  the output should be copied to the clipboard (Default: `TRUE`).

## Value

A [`character`](https://rdrr.io/r/base/character.html) string with all
values from `x` inside the [`c()`](https://rdrr.io/r/base/c.html)
function.

## Examples

``` r
vector_to_c(letters[1:5], clipboard = FALSE)
#> c("a", "b", "c", "d", "e")
#> [1] "c(\"a\", \"b\", \"c\", \"d\", \"e\")"
#> c("a", "b", "c", "d", "e") # Expected

vector_to_c(1:5, quote = FALSE, clipboard = FALSE)
#> c(1, 2, 3, 4, 5)
#> [1] "c(1, 2, 3, 4, 5)"
#> c(1, 2, 3, 4, 5) # Expected
```
