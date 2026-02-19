# Download files

`download_file()` is a wrapper around the `httr2` package that provides
a user-friendly interface for downloading files, with built-in error
handling and progress reporting.

## Usage

``` r
download_file(
  url,
  connection_timeout = 10,
  max_tries = 3,
  retry_on_failure = TRUE,
  backoff = function(attempt) 5^attempt,
  dir = tempdir()
)
```

## Arguments

- url:

  A [`character`](https://rdrr.io/r/base/character.html) vector of URLs
  pointing to remote files.

- connection_timeout:

  (optional) A [`numeric`](https://rdrr.io/r/base/numeric.html) value
  specifying the connection timeout in seconds for HTTP requests
  (default: `10`).

- max_tries:

  (optional) A [`numeric`](https://rdrr.io/r/base/numeric.html) value
  specifying the maximum number of retry attempts (default: `3`).

- retry_on_failure:

  (optional) A [`logical`](https://rdrr.io/r/base/logical.html) value
  indicating whether to retry on failure (default: `TRUE`).

- backoff:

  (optional) A [`function`](https://rdrr.io/r/base/function.html) that
  takes the current attempt number as input and returns the number of
  seconds to wait before the next attempt (default:
  `\(attempt) 5^attempt`).

- dir:

  (optional) A string specifying the directory where the files should be
  downloaded (default:
  [`tempdir()`](https://rdrr.io/r/base/tempfile.html)).

## Value

A invisible [`character`](https://rdrr.io/r/base/character.html) vector
of file paths where the files were downloaded.

## See also

Other file functions:
[`get_file_size()`](https://danielvartan.github.io/rutils/reference/get_file_size.md)

## Examples

``` r
library(httr2)

if (is_online()) {
  urls <- file.path(
    "ftp://ftp.datasus.gov.br/dissemin/publicos/IBGE/POPSVS",
     c("POPSBR00.zip", "POPSBR01.zip")
  )

  download_file(urls)
}
#> Waiting 2s for retry backoff ■■■■■■■■■■■■■■■                 
#> Waiting 2s for retry backoff ■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■  
#> ℹ Downloading 2 files to /tmp/RtmpVuPNeO
#> Downloading files ■■■■■■■■■■■■■■■■                  50% | ETA:  6s
#> Downloading files ■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■  100% | ETA:  0s
#> 
```
