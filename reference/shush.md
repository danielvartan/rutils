# Suppress messages and warnings

`shush()` is a wrapper around
[`suppressMessages()`](https://rdrr.io/r/base/message.html) and
[`suppressWarnings()`](https://rdrr.io/r/base/warning.html) that allows
you to suppress messages and warnings in a single function call. It was
designed to be used with pipes.

## Usage

``` r
shush(x, quiet = TRUE)
```

## Arguments

- x:

  Any expression, usually a function call.

- quiet:

  (optional) A [logical](https://rdrr.io/r/base/logical.html) flag value
  indicating whether to suppress messages and warnings. This is can be
  used for condition messages and warnings inside functions (Default:
  `TRUE`).

## Value

The same object as `x` with messages and warnings suppressed.

## Examples

``` r
message("test") |> shush()
message("test") |> shush(quiet = FALSE)
#> test
#> test # Expected

warning("test") |> shush()
warning("test") |> shush(quiet = FALSE)
#> Warning: test
#> Warning: test # Expected
```
