# Get file names without the extension

`get_file_name_without_ext()` returns file names without the extension
part.

## Usage

``` r
get_file_name_without_ext(file)
```

## Arguments

- file:

  A [`character`](https://rdrr.io/r/base/character.html) vector with
  file paths.

## Value

A [`character`](https://rdrr.io/r/base/character.html) vector containing
file names without the extension part.

## See also

Other string functions:
[`get_file_ext()`](https://danielvartan.github.io/rutils/reference/get_file_ext.md)

## Examples

``` r
get_file_name_without_ext("example.txt")
#> [1] "example"
#> [1] "example" # Expected

get_file_name_without_ext("/path/to/file.tar.gz")
#> [1] "file.tar"
#> [1] "file.tar"  # Expected

get_file_name_without_ext("no-extension")
#> [1] "no-extension"
#> [1] "no-extension" # Expected

get_file_name_without_ext(c("data.csv", "data.rds"))
#> [1] "data" "data"
#> [1] "data" "data" # Expected
```
