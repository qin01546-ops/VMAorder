
<!-- README.md is generated from README.Rmd. Please edit that file -->

# VMAorder

<!-- badges: start -->

<!-- badges: end -->

VMAorder provides tools for simulating vector moving-average models,
computing VMA statistics, estimating model order, and visualizing
statistic curves.

## Installation

You can install the development version of VMAorder from
[GitHub](https://github.com/) with:

``` r
# install.packages("pak")
pak::pak("qin01546-ops/VMAorder")
```

## Example

``` r
library(VMAorder)

fit <- simVMA(n = 100, p = 5, order = 2, seed = 123)
statVMA(fit$x, lag = 1:5)
#>   lag        Sn
#> 1   1 0.2802450
#> 2   2 1.8580184
#> 3   3 1.0111102
#> 4   4 1.0631176
#> 5   5 0.9273607
```
