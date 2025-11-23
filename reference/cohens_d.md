# Compute Cohen's d statistic

`cohens_d()` computes Cohen's d statistic for two independent samples.

This function is based on Cohen (1988) and Frey (2022) calculations for
samples with equal and unequal sizes.

## Usage

``` r
cohens_d(x, y, t = NULL, abs = TRUE)
```

## Arguments

- x:

  A [`numeric`](https://rdrr.io/r/base/numeric.html) vector.

- y:

  A [`numeric`](https://rdrr.io/r/base/numeric.html) vector.

- t:

  (optional) A [`numeric`](https://rdrr.io/r/base/numeric.html) value
  for the t statistic (Default: `NULL`).

- abs:

  (optional) A [`logical`](https://rdrr.io/r/base/logical.html) flag
  indicating whether to return the absolute value of the Cohen's d
  statistic (Default: `TRUE`).

## Value

A [`numeric`](https://rdrr.io/r/base/numeric.html) value representing
the Cohen's d statistic.

## References

Cohen, J. (1988). *Statistical power analysis for the behavioral
sciences* (2nd ed.). Lawrence Erlbaum Associates.

Frey, B. B. (Ed.). (2022). \_The SAGE encyclopedia of research design
(2. ed.). SAGE Publications.
[doi:10.4135/9781071812082](https://doi.org/10.4135/9781071812082)

## See also

Other statistical functions.:
[`mode()`](https://danielvartan.github.io/rutils/reference/mode.md),
[`stats_summary()`](https://danielvartan.github.io/rutils/reference/stats_summary.md)

## Examples

``` r
cohens_d(c(1, 2, 3, 4, 5), c(6, 7, 8, 9, 10))
#> [1] 3.162278
#> [1] 3.162278 # Expected
```
