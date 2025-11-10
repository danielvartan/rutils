# Swap two values if a condition is met

`swap_if()` swaps two values if a condition is met.

## Usage

``` r
swap_if(x, y, condition = TRUE)
```

## Arguments

- x:

  Any type of R object.

- y:

  An R object of the same class and length as `x`.

- condition:

  A [`logical`](https://rdrr.io/r/base/logical.html) flag indicating if
  the values should be swapped (Default: `TRUE`).

## Value

A [`list`](https://rdrr.io/r/base/list.html) with the swapped values.

## See also

Other conditional functions:
[`vct_replace_all()`](https://danielvartan.github.io/rutils/reference/vct_replace_all.md)

## Examples

``` r
swap_if(1, 2)
#> $x
#> [1] 2
#> 
#> $y
#> [1] 1
#> 
#> $x # Expected
#> [1] 2
#>
#> $y
#> [1] 1

swap_if(1, 2, condition = FALSE)
#> $x
#> [1] 1
#> 
#> $y
#> [1] 2
#> 
#> $x # Expected
#> [1] 1
#>
#> $y
#> [1] 2

swap_if(letters, LETTERS, c(rep(TRUE, 13), rep(FALSE, 13)))
#> $x
#>  [1] "A" "B" "C" "D" "E" "F" "G" "H" "I" "J" "K" "L" "M" "n" "o" "p" "q" "r" "s"
#> [20] "t" "u" "v" "w" "x" "y" "z"
#> 
#> $y
#>  [1] "a" "b" "c" "d" "e" "f" "g" "h" "i" "j" "k" "l" "m" "N" "O" "P" "Q" "R" "S"
#> [20] "T" "U" "V" "W" "X" "Y" "Z"
#> 
#> $x
#>  [1] "A" "B" "C" "D" "E" "F" "G" "H" "I" "J" "K" "L" "M" "n"
#> [15] "o" "p" "q" "r" "s" "t" "u" "v" "w" "x" "y" "z"
#>
#> $y
#>  [1] "a" "b" "c" "d" "e" "f" "g" "h" "i" "j" "k" "l" "m" "N"
#> [15] "O" "P" "Q" "R" "S" "T" "U" "V" "W" "X" "Y" "Z"
```
