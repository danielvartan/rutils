# Return a `NA` value of the same type of an R object

`na_as()` returns an `NA` value with the same class and attributes as a
given R object.

This function is useful for dynamically assigning `NA` values that
preserve the type and attributes of the original object.

## Usage

``` r
na_as(x)

# S3 method for class 'logical'
na_as(x)

# S3 method for class 'character'
na_as(x)

# S3 method for class 'integer'
na_as(x)

# S3 method for class 'numeric'
na_as(x)

# S3 method for class 'Duration'
na_as(x)

# S3 method for class 'Period'
na_as(x)

# S3 method for class 'difftime'
na_as(x)

# S3 method for class 'hms'
na_as(x)

# S3 method for class 'Date'
na_as(x)

# S3 method for class 'hms'
na_as(x)

# S3 method for class 'POSIXct'
na_as(x)

# S3 method for class 'POSIXlt'
na_as(x)

# S3 method for class 'Interval'
na_as(x)
```

## Arguments

- x:

  An
  [atomic](https://mllg.github.io/checkmate/reference/checkAtomic.html)
  vector.

## Value

A `NA` value with the same class and attributes of `x`.

## Examples

``` r
na_as(TRUE)
#> [1] NA
#> [1] NA # Expected

class(na_as(TRUE))
#> [1] "logical"
#> [1] "logical" # Expected

na_as(as.Date("2020-01-01"))
#> [1] NA
#> [1] NA # Expected

class(na_as(as.Date("2020-01-01")))
#> [1] "Date"
#> [1] "Date"  # Expected
```
