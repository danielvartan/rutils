# Get the current locale settings

`get_locale()` prints the current locale settings in system and local
environments.

## Usage

``` r
get_locale()
```

## Value

An invisible `NULL`. This function is called for its side effects.

## See also

Other system functions.:
[`set_en_us_locale()`](https://danielvartan.github.io/rutils/reference/set_en_us_locale.md)

## Examples

``` r
get_locale()
#> → The current system locale is:
#> 
#> LC_CTYPE=C.UTF-8;LC_NUMERIC=C;LC_TIME=C.UTF-8;LC_COLLATE=C;LC_MONETARY=C.UTF-8;LC_MESSAGES=C.UTF-8;LC_PAPER=C.UTF-8;LC_NAME=C;LC_ADDRESS=C;LC_TELEPHONE=C;LC_MEASUREMENT=C.UTF-8;LC_IDENTIFICATION=C
#> 
#> → The current values for the locale environment variables are:
#> 
#> LC_COLLATE=C;LC_CTYPE=;LC_MONETARY=;LC_NUMERIC=;LC_TIME=;LC_MESSAGES=;LC_PAPER=;LC_MEASUREMENT=;LC_NAME=;LC_ADDRESS=;LC_TELEPHONE=;LC_IDENTIFICATION=
```
