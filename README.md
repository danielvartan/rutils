
<!-- README.md is generated from README.Rmd. Please edit that file -->

# gutils <a href='https://gipso.github.io/gutils'><img src='man/figures/logo.png' align="right" height="139" /></a>

<!-- badges: start -->

[![Project Status: WIP – Initial development is in progress, but there
has not yet been a stable, usable release suitable for the
public.](https://www.repostatus.org/badges/latest/wip.svg)](https://www.repostatus.org/#wip)
[![Lifecycle:
experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://lifecycle.r-lib.org/articles/stages.html#experimental)
[![R-CMD-check](https://github.com/gipso/gutils/workflows/R-CMD-check/badge.svg)](https://github.com/gipso/gutils/actions)
[![Codecov test
coverage](https://codecov.io/gh/gipso/gutils/branch/main/graph/badge.svg)](https://codecov.io/gh/gipso/gutils?branch=main)
[![License:
MIT](https://img.shields.io/badge/license-MIT-green)](https://choosealicense.com/licenses/mit/)
<!-- badges: end -->

`gutils` is an R package to store and to organize utility functions
created by the GIPSO developer team.

Please note that some utility functions are not documented. Access the
source code to see them all.

See also other utility or extension packages created by the GIPSO
developer team:

-   [`encryptrpak`](https://github.com/gipso/encryptrpak): an R package
    to encrypt/decrypt files of R packages.
-   [`lubritime`](https://github.com/gipso/lubritime): an extension for
    the [lubridate](https://github.com/tidyverse/lubridate) package to
    deal with time in R.

## Installation

`gutils` will be always at the
[experimental](https://lifecycle.r-lib.org/articles/stages.html#experimental)
stage of development. We don’t intend to publish this package to CRAN.

You can install `gutils` from GitHub with:

``` r
# install.packages("remotes")
remotes::install_github("gipso/gutils")
```

## Citation

If you use `gutils` in your research, please consider citing it. We put
a lot of work to build and maintain a free and open-source R package.
You can find the `gutils` citation below.

``` r
citation("gutils")
#> 
#> To cite {gutils} in publications use:
#> 
#>   Vartanian, D., Pedrazzoli, M. (2021). {gutils}: an R package with
#>   utility functions created by the GIPSO developer team.
#>   https://gipso.github.io/gutils/.
#> 
#> A BibTeX entry for LaTeX users is
#> 
#>   @Unpublished{,
#>     title = {{gutils}: an R package with utility functions created by the GIPSO developer team},
#>     author = {Daniel Vartanian and Mario Pedrazzoli},
#>     year = {2021},
#>     url = {https://gipso.github.io/gutils/},
#>     note = {Lifecycle: experimental},
#>   }
```
