# Get the sizes of local files or files from URLs

`get_file_size()` returns the sizes of files in bytes. It works with
local files and URLs.

## Usage

``` r
get_file_size(file)
```

## Arguments

- file:

  A [`character`](https://rdrr.io/r/base/character.html) vector of file
  paths. The function also works with URLs.

## Value

A [`fs_bytes`](https://fs.r-lib.org/reference/fs_bytes.html) vector of
file sizes.

## See also

Other file functions:
[`download_file()`](https://danielvartan.github.io/rutils/reference/download_file.md)

## Examples

``` r
library(fs)
library(readr)
#> 
#> Attaching package: ‘readr’
#> The following object is masked from ‘package:curl’:
#> 
#>     parse_date

files <- c("file1.txt", "file2.txt", "file3.txt")

dir <- tempfile("dir")
dir.create(dir)

for (i in files) {
  write_lines(rep(letters, sample(1000:10000, 1)), file.path(dir, i))
}

urls <- c(
  paste0(
    "https://geodata.ucdavis.edu/climate/worldclim/2_1/base/",
    "wc2.1_2.5m_tavg.zip"
  ),
  paste0(
    "https://geodata.ucdavis.edu/climate/worldclim/2_1/base/",
    "wc2.1_10m_prec.zip"
  )
)

c(urls, path(dir, files)) |> get_file_size()
#> 422.69M   6.92M 221.96K 151.33K 154.68K
```
