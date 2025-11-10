# Set the system locale to English (United States)

`set_en_us_locale()` sets the system locale to English (United States)
trying to overcome OS-dependent differences in locale handling.

## Usage

``` r
set_en_us_locale()
```

## Value

An invisible `NULL`. This function is called for its side effects.

## See also

Other system functions.:
[`get_locale()`](https://danielvartan.github.io/rutils/reference/get_locale.md)

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

set_en_us_locale()

get_locale()
#> → The current system locale is:
#> 
#> LC_CTYPE=en_US.utf8;LC_NUMERIC=C;LC_TIME=en_US.utf8;LC_COLLATE=en_US.utf8;LC_MONETARY=en_US.utf8;LC_MESSAGES=en_US.utf8;LC_PAPER=en_US.utf8;LC_NAME=C;LC_ADDRESS=C;LC_TELEPHONE=C;LC_MEASUREMENT=en_US.utf8;LC_IDENTIFICATION=C
#> 
#> → The current values for the locale environment variables are:
#> 
#> LC_COLLATE=en_US.utf8;LC_CTYPE=en_US.utf8;LC_MONETARY=en_US.utf8;LC_NUMERIC=en_US.utf8;LC_TIME=en_US.utf8;LC_MESSAGES=en_US.utf8;LC_PAPER=en_US.utf8;LC_MEASUREMENT=en_US.utf8;LC_NAME=en_US.utf8;LC_ADDRESS=en_US.utf8;LC_TELEPHONE=en_US.utf8;LC_IDENTIFICATION=en_US.utf8
```
