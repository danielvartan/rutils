# Compute summary statistics

`stats_summary()` computes summary statistics for a specified column in
a data frame.

## Usage

``` r
stats_summary(
  data,
  col,
  name = NULL,
  na_rm = TRUE,
  remove_outliers = FALSE,
  iqr_mult = 1.5,
  hms_format = TRUE,
  threshold = hms::parse_hms("12:00:00"),
  as_list = FALSE
)
```

## Arguments

- data:

  A [`data.frame`](https://rdrr.io/r/base/data.frame.html).

- col:

  A [`character`](https://rdrr.io/r/base/character.html) `string`
  specifying the column name in `data` for which to compute summary
  statistics.

- name:

  (optional) A [`character`](https://rdrr.io/r/base/character.html)
  `string` with a name to include in the summary statistics (default:
  `NULL`).

- na_rm:

  A [`logical`](https://rdrr.io/r/base/logical.html) flag indicating
  whether to remove `NA` values when computing statistics (default:
  `TRUE`).

- remove_outliers:

  A [`logical`](https://rdrr.io/r/base/logical.html) flag indicating
  whether to remove outliers using the IQR method (default: `FALSE`).

- iqr_mult:

  A [`numeric`](https://rdrr.io/r/base/numeric.html) value specifying
  the Interquartile Range (IQR) multiplier for outlier detection
  (default: `1.5`).

- hms_format:

  A [`logical`](https://rdrr.io/r/base/logical.html) flag indicating
  whether to format temporal statistics as
  [`hms`](https://hms.tidyverse.org/reference/hms.html) objects
  (default: `TRUE`).

- threshold:

  A [`hms`](https://hms.tidyverse.org/reference/hms.html) object
  specifying the threshold time for linking times to a timeline when
  computing temporal statistics. See
  [`link_to_timeline()`](https://danielvartan.github.io/lubritime/reference/link_to_timeline.html)
  to learn more (default: `hms::parse_hms("12:00:00")`).

- as_list:

  A [`logical`](https://rdrr.io/r/base/logical.html) flag indicating
  whether to return the summary statistics as a
  [`list`](https://rdrr.io/r/base/list.html) (default: `FALSE`).

## Value

If `as_list` is `TRUE`, a [`list`](https://rdrr.io/r/base/list.html)
with the summary statistics. Otherwise, a one-row
[`tibble`](https://tibble.tidyverse.org/reference/tibble.html) with the
summary statistics.

## See also

Other statistical functions.:
[`cohens_d()`](https://danielvartan.github.io/rutils/reference/cohens_d.md),
[`mode()`](https://danielvartan.github.io/rutils/reference/mode.md)

## Examples

``` r
library(dplyr)
#> 
#> Attaching package: ‘dplyr’
#> The following objects are masked from ‘package:stats’:
#> 
#>     filter, lag
#> The following objects are masked from ‘package:base’:
#> 
#>     intersect, setdiff, setequal, union
library(hms)

rnorm(1000) |>
  as_tibble() |>
  stats_summary("value") |>
  print(n = Inf)
#> # A tibble: 16 × 2
#>    name     value              
#>    <chr>    <chr>              
#>  1 class    numeric            
#>  2 n        1000               
#>  3 n_rm_na  1000               
#>  4 n_na     0                  
#>  5 mean     0.00415779520813434
#>  6 var      0.989635961402831  
#>  7 sd       0.994804484008205  
#>  8 min      -3.70984946627182  
#>  9 q_1      -0.691392247383182 
#> 10 median   0.0289577747834712 
#> 11 q_3      0.675476195395744  
#> 12 max      3.39150881898844   
#> 13 iqr      1.36686844277893   
#> 14 range    7.10135828526026   
#> 15 skewness -0.0496126045969755
#> 16 kurtosis 2.99809892189888   

letters |>
  as_tibble() |>
  stats_summary("value") |>
  print(n = Inf)
#> # A tibble: 32 × 2
#>    name     value    
#>    <chr>    <chr>    
#>  1 class    character
#>  2 n        26       
#>  3 n_rm_na  26       
#>  4 n_na     0        
#>  5 n_unique 26       
#>  6 mode     NA       
#>  7 'a'      1        
#>  8 'b'      1        
#>  9 'c'      1        
#> 10 'd'      1        
#> 11 'e'      1        
#> 12 'f'      1        
#> 13 'g'      1        
#> 14 'h'      1        
#> 15 'i'      1        
#> 16 'j'      1        
#> 17 'k'      1        
#> 18 'l'      1        
#> 19 'm'      1        
#> 20 'n'      1        
#> 21 'o'      1        
#> 22 'p'      1        
#> 23 'q'      1        
#> 24 'r'      1        
#> 25 's'      1        
#> 26 't'      1        
#> 27 'u'      1        
#> 28 'v'      1        
#> 29 'w'      1        
#> 30 'x'      1        
#> 31 'y'      1        
#> 32 'z'      1        

sample(0:86399, 1000) |>
  as_hms() |>
  as_tibble() |>
  stats_summary("value") |>
  print(n = Inf)
#> # A tibble: 16 × 2
#>    name     value              
#>    <chr>    <chr>              
#>  1 class    hms                
#>  2 n        1000               
#>  3 n_rm_na  1000               
#>  4 n_na     0                  
#>  5 mean     23:55:26.109       
#>  6 var      02:09:59.672792    
#>  7 sd       06:53:29.70374     
#>  8 min      12:00:14           
#>  9 q_1      18:00:45.75        
#> 10 median   23:44:11           
#> 11 q_3      05:58:27.25        
#> 12 max      11:59:01           
#> 13 iqr      11:57:41.5         
#> 14 range    23:58:47           
#> 15 skewness -0.0105501531038544
#> 16 kurtosis 1.81463198446254   
```
