# Extract initials from a character vector

`extract_initials()` extracts the initials of names in a character
vector.

## Usage

``` r
extract_initials(x, sep = ". ")
```

## Arguments

- x:

  A [`character`](https://rdrr.io/r/base/character.html) vector with
  names.

- sep:

  A [`character`](https://rdrr.io/r/base/character.html) string to
  separate initials (Default: ". ").

## Value

A [`character`](https://rdrr.io/r/base/character.html) vector with the
initials of names in `x`.

## Examples

``` r
extract_initials(c("John Doe", "Jane Doe", "John Smith"))
#> [1] "J. D." "J. D." "J. S."
#> [1] "J. D." "J. D." "J. S." # Expected

extract_initials(c("John Doe", "Jane Doe", "John Smith"), sep = ".")
#> [1] "J.D." "J.D." "J.S."
#> [1] "J.D." "J.D." "J.S." # Expected
```
