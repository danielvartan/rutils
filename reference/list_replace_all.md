# Replace matches in a list

`list_replace_all()` replaces matches in
[`atomic`](https://rdrr.io/r/base/is.recursive.html) vectors inside a
list with a replacement value. If the list is nested, the function will
recursively apply the replacement to all nested lists.

## Usage

``` r
list_replace_all(list, pattern = "^$", replacement = NULL)
```

## Arguments

- list:

  A [`list`](https://rdrr.io/r/base/list.html) or
  [`pairlist`](https://rdrr.io/r/base/list.html) object.

- pattern:

  A [`character`](https://rdrr.io/r/base/character.html) string
  containing a regular expression to be matched in the list.

- replacement:

  An [`atomic`](https://rdrr.io/r/base/is.recursive.html) value to
  replace the matches with.

## Value

A [`list`](https://rdrr.io/r/base/list.html) with matches replaced with
the replacement value.

## Details

If there is a match, but the replacement value is not the same class as
the original value, the function will return the replacement value as
is.

If the replacement value is the same class as the original value, the
function will return a vector with the replacement value in the same
position as the match.

## Examples

``` r
list_replace_all(list(a = "", b = "b", c = list(d = "", e = "e")))
#> $a
#> NULL
#> 
#> $b
#> [1] "b"
#> 
#> $c
#> $c$d
#> NULL
#> 
#> $c$e
#> [1] "e"
#> 
#> 
#> $a # Expected
#> NULL
#>
#> $b
#> [1] "b"
#>
#> $c
#> $c$d
#> NULL
#>
#> $c$e
#> [1] "e"
```
