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
  round = FALSE,
  digits = 3,
  hms_format = TRUE,
  threshold = NULL,
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

- round:

  A [`logical`](https://rdrr.io/r/base/logical.html) flag indicating
  whether to round the summary statistics (default: `FALSE`).

- digits:

  An integer number specifying the number of decimal places to round to
  if `round` is `TRUE` (default: `2`).

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
library(lubridate)
#> 
#> Attaching package: ‘lubridate’
#> The following object is masked from ‘package:hms’:
#> 
#>     hms
#> The following objects are masked from ‘package:base’:
#> 
#>     date, intersect, setdiff, union

## `character` Example

sample(letters, 1000, replace = TRUE) |>
  as_tibble() |>
  stats_summary("value") |>
  print(n = Inf)
#> # A tibble: 64 × 2
#>    name     value    
#>    <chr>    <chr>    
#>  1 class    character
#>  2 n        1000     
#>  3 n_rm_na  1000     
#>  4 n_na     0        
#>  5 n_unique 26       
#>  6 mode     a        
#>  7 'a'      49       
#>  8 'b'      39       
#>  9 'c'      35       
#> 10 'd'      34       
#> 11 'e'      40       
#> 12 'f'      39       
#> 13 'g'      40       
#> 14 'h'      37       
#> 15 'i'      38       
#> 16 'j'      49       
#> 17 'k'      43       
#> 18 'l'      47       
#> 19 'm'      32       
#> 20 'n'      38       
#> 21 'o'      32       
#> 22 'p'      36       
#> 23 'q'      35       
#> 24 'r'      36       
#> 25 's'      39       
#> 26 't'      37       
#> 27 'u'      32       
#> 28 'v'      36       
#> 29 'w'      38       
#> 30 'x'      37       
#> 31 'y'      36       
#> 32 'z'      46       
#> 33 class    character
#> 34 n        1000     
#> 35 n_rm_na  1000     
#> 36 n_na     0        
#> 37 n_unique 26       
#> 38 mode     j        
#> 39 'a'      49       
#> 40 'b'      39       
#> 41 'c'      35       
#> 42 'd'      34       
#> 43 'e'      40       
#> 44 'f'      39       
#> 45 'g'      40       
#> 46 'h'      37       
#> 47 'i'      38       
#> 48 'j'      49       
#> 49 'k'      43       
#> 50 'l'      47       
#> 51 'm'      32       
#> 52 'n'      38       
#> 53 'o'      32       
#> 54 'p'      36       
#> 55 'q'      35       
#> 56 'r'      36       
#> 57 's'      39       
#> 58 't'      37       
#> 59 'u'      32       
#> 60 'v'      36       
#> 61 'w'      38       
#> 62 'x'      37       
#> 63 'y'      36       
#> 64 'z'      46       

## `factor` Example

sample(letters, 1000, replace = TRUE) |>
  as.factor() |>
  as_tibble() |>
  stats_summary("value") |>
  print(n = Inf)
#> # A tibble: 32 × 2
#>    name     value    
#>    <chr>    <chr>    
#>  1 class    character
#>  2 n        1000     
#>  3 n_rm_na  1000     
#>  4 n_na     0        
#>  5 n_unique 26       
#>  6 mode     i        
#>  7 'a'      47       
#>  8 'b'      36       
#>  9 'c'      41       
#> 10 'd'      40       
#> 11 'e'      33       
#> 12 'f'      35       
#> 13 'g'      41       
#> 14 'h'      35       
#> 15 'i'      55       
#> 16 'j'      44       
#> 17 'k'      32       
#> 18 'l'      30       
#> 19 'm'      32       
#> 20 'n'      42       
#> 21 'o'      37       
#> 22 'p'      44       
#> 23 'q'      44       
#> 24 'r'      28       
#> 25 's'      31       
#> 26 't'      50       
#> 27 'u'      37       
#> 28 'v'      31       
#> 29 'w'      43       
#> 30 'x'      32       
#> 31 'y'      41       
#> 32 'z'      39       

## `numeric` Example

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
#>  5 mean     0.00882103199869792
#>  6 var      0.916157801739654  
#>  7 sd       0.957161324824428  
#>  8 min      -2.94908378424355  
#>  9 q_1      -0.652478558272966 
#> 10 median   -0.0222078965814481
#> 11 q_3      0.667215146071814  
#> 12 max      3.00809273739028   
#> 13 iqr      1.31969370434478   
#> 14 range    5.95717652163384   
#> 15 skewness 0.032714596279281  
#> 16 kurtosis 2.83812827363449   

## `duration` Examples

sample(seq_len(86399), 1000) |>
  as.duration() |>
  as_tibble() |>
  stats_summary("value") |>
  print(n = Inf)
#> # A tibble: 16 × 2
#>    name     value              
#>    <chr>    <chr>              
#>  1 class    Duration           
#>  2 n        1000               
#>  3 n_rm_na  1000               
#>  4 n_na     0                  
#>  5 mean     12:03:15.724       
#>  6 var      162508:39:07.629453
#>  7 sd       06:43:07.417134    
#>  8 min      00:04:06           
#>  9 q_1      06:13:20.75        
#> 10 median   12:14:13.5         
#> 11 q_3      17:42:24.25        
#> 12 max      23:59:54           
#> 13 iqr      11:29:03.5         
#> 14 range    23:55:48           
#> 15 skewness 0.00921503015087464
#> 16 kurtosis 1.81970971422038   

sample(seq_len(86399), 1000) |>
  as.duration() |>
  as_tibble() |>
  stats_summary(
    col = "value",
    hms_format = FALSE
  ) |>
  print(n = Inf)
#> # A tibble: 16 × 2
#>    name     value                           
#>    <chr>    <chr>                           
#>  1 class    Duration                        
#>  2 n        1000                            
#>  3 n_rm_na  1000                            
#>  4 n_na     0                               
#>  5 mean     43328.929s (~12.04 hours)       
#>  6 var      614793868.644604s (~19.48 years)
#>  7 sd       24795.0371777217s (~6.89 hours) 
#>  8 min      8s                              
#>  9 q_1      22103s (~6.14 hours)            
#> 10 median   42948.5s (~11.93 hours)         
#> 11 q_3      64350.5s (~17.88 hours)         
#> 12 max      86396s (~24 hours)              
#> 13 iqr      42247.5s (~11.74 hours)         
#> 14 range    86388s (~24 hours)              
#> 15 skewness 0.00739270223785435             
#> 16 kurtosis 1.79346270718159                

## `hms` Examples

sample(seq_len(86399), 1000) |>
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
#>  5 mean     11:28:06.288       
#>  6 var      169802:02:58.241297
#>  7 sd       06:52:04.226545    
#>  8 min      00:00:42           
#>  9 q_1      05:41:43.75        
#> 10 median   11:05:19.5         
#> 11 q_3      17:20:15.5         
#> 12 max      23:59:19           
#> 13 iqr      11:38:31.75        
#> 14 range    23:58:37           
#> 15 skewness 0.107281125691469  
#> 16 kurtosis 1.84102649790014   

sample(seq_len(86399), 1000) |>
  as_hms() |>
  as_tibble() |>
  stats_summary(
    col = "value",
    threshold = hms::parse_hm("12:00")
  ) |>
  print(n = Inf)
#> # A tibble: 16 × 2
#>    name     value             
#>    <chr>    <chr>             
#>  1 class    hms               
#>  2 n        1000              
#>  3 n_rm_na  1000              
#>  4 n_na     0                 
#>  5 mean     23:46:32.93       
#>  6 var      10:23:38.209309   
#>  7 sd       06:53:54.665655   
#>  8 min      12:00:28          
#>  9 q_1      18:02:41          
#> 10 median   23:38:37.5        
#> 11 q_3      05:59:57.25       
#> 12 max      11:59:43          
#> 13 iqr      11:57:16.25       
#> 14 range    23:59:15          
#> 15 skewness 0.0200625840500226
#> 16 kurtosis 1.82635100590631  

## `Date` Example

sample(seq_len(20415), 1000) |>
  as.Date() |>
  as_tibble() |>
  stats_summary("value") |>
  print(n = Inf)
#> # A tibble: 16 × 2
#>    name     value                              
#>    <chr>    <chr>                              
#>  1 class    Date                               
#>  2 n        1000                               
#>  3 n_rm_na  1000                               
#>  4 n_na     0                                  
#>  5 mean     1998-03-09                         
#>  6 var      3083334102303.05s (~97704.96 years)
#>  7 sd       516139580.384011s (~16.36 years)   
#>  8 min      1970-01-04                         
#>  9 q_1      1983-11-13                         
#> 10 median   1998-08-01                         
#> 11 q_3      2012-01-07                         
#> 12 max      2025-11-17                         
#> 13 iqr      888408000s (~28.15 years)          
#> 14 range    1763078400s (~55.87 years)         
#> 15 skewness -0.016469922094564                 
#> 16 kurtosis 1.79479612698249                   

## `POSIXct` Example

sample(seq_len(Sys.time()), 1000) |>
  as.POSIXct() |>
  as_tibble() |>
  stats_summary("value") |>
  print(n = Inf)
#> # A tibble: 16 × 2
#>    name     value                                     
#>    <chr>    <chr>                                     
#>  1 class    POSIXct                                   
#>  2 n        1000                                      
#>  3 n_rm_na  1000                                      
#>  4 n_na     0                                         
#>  5 mean     1998-11-10 21:08:51.096                   
#>  6 var      257713360628507136s (~8166443602.44 years)
#>  7 sd       507654765.198267s (~16.09 years)          
#>  8 min      1970-01-21 14:40:13                       
#>  9 q_1      1985-04-24 15:47:10.25                    
#> 10 median   1999-02-08 21:08:54.5                     
#> 11 q_3      2012-06-28 05:16:20.5                     
#> 12 max      2025-11-15 16:42:20                       
#> 13 iqr      857654950.25s (~27.18 years)              
#> 14 range    1761444127s (~55.82 years)                
#> 15 skewness -0.060698797874797                        
#> 16 kurtosis 1.84974587052492                          
```
