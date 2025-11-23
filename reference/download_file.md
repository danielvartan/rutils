# Download files from the internet to a local directory

`download_file()` downloads files from the internet to a local
directory. It can handle multiple files at once and provides progress
updates during the download process.

The function also checks for broken links and can return a list of any
broken links encountered during the download.

## Usage

``` r
download_file(url, dir = ".", broken_links = FALSE)
```

## Arguments

- url:

  A [`character`](https://rdrr.io/r/base/character.html) vector of URLs
  pointing to files.

- dir:

  (optional) A string specifying the directory where the files should be
  downloaded (default: ".").

- broken_links:

  (optional) A [`logical`](https://rdrr.io/r/base/logical.html) flag
  indicating whether to return a list of broken links (default:
  `FALSE`).

## Value

If `broken_links` is `TRUE`, an invisible
[`character`](https://rdrr.io/r/base/character.html) vector of broken
links. Otherwise, a invisible
[`character`](https://rdrr.io/r/base/character.html) vector of file
paths where the files were downloaded.

## See also

Other file functions:
[`get_file_size()`](https://danielvartan.github.io/rutils/reference/get_file_size.md)

## Examples

``` r
library(curl)
#> Using libcurl 8.5.0 with OpenSSL/3.0.13

if (has_internet()) {
  urls <- paste0(
    "ftp://ftp.datasus.gov.br/dissemin/publicos/IBGE/POPSVS/",
     c("POPSBR00.zip", "POPSBR01.zip")
  )

  dir <- tempfile("dir")
  dir.create(dir)

  download_file(urls, dir)
}
#> ℹ Downloading 2 files to /tmp/RtmpUzw0mr/dir22c7754dcf6f
#> 
#> ℹ The file POPSBR00.zip could not be downloaded.
#> Downloading data ■■■■■■■■■■■■■■■■                  50% | ETA: 10s
#> Downloading data ■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■  100% | ETA:  0s
#> 
```
