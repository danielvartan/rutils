# Get file extensions

`get_file_ext()` is similar to `file_ext()`, the difference is that it
returns the file extension with the dot separator (e.g., `.csv`).

## Usage

``` r
get_file_ext(file)
```

## Arguments

- file:

  A [`character`](https://rdrr.io/r/base/character.html) vector with
  file paths.

## Value

A [`character`](https://rdrr.io/r/base/character.html) vector containing
the file extension of the files.

## See also

Other string functions:
[`get_file_name_without_ext()`](https://danielvartan.github.io/rutils/reference/get_file_name_without_ext.md)

## Examples

``` r
get_file_ext("example.txt")
#> [1] ".txt"
#> [1] ".txt" # Expected

get_file_ext("/path/to/file.tar.gz")
#> [1] ".gz"
#> [1] ".gz"  # Expected

get_file_ext("no-extension")
#> [1] NA
#> [1] NA # Expected

get_file_ext(c("data.csv", "data.rds"))
#> [1] ".csv" ".rds"
#> [1] ".csv" ".rds" # Expected
```
