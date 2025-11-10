# Grab all the parameters in a function

`grab_fun_par()` grabs all parameters defined in a function. It's
particularly useful when you need to pass all parameters from one
function to another (e.g., using
[`do.call()`](https://rdrr.io/r/base/do.call.html)).

Credits: Function adapted from B. Christian Kamgang's contribution in a
[Stack Overflow discussion](https://bit.ly/3QD48Wy).

## Usage

``` r
grab_fun_par()
```

## Value

A [`list`](https://rdrr.io/r/base/list.html) containing the parameters
of the function from which it was called.

## Examples

``` r
foo <- function(a = 1) grab_fun_par()

foo()
#> $a
#> [1] 1
#> 
#> $a # Expected
#> [1] 1
```
