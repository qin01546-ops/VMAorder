# Compute VMA Statistics

Computes lag-wise statistics for VMA order selection.

## Usage

``` r
statVMA(x, lag = 1:10, center = FALSE)
```

## Arguments

- x:

  A numeric matrix or data frame.

- lag:

  A numeric vector of lags.

- center:

  Logical. If `TRUE`, center each column.

## Value

A data frame with `lag` and `Sn`.

## Details

For each lag \\\tau\\, the statistic is \$\$ S_n(\tau) = F_n(\tau) /
F_n(\tau + 1), \$\$ where \$\$ F_n(\tau) = \operatorname{tr}
\left\\\widehat{\Gamma}(\tau)\widehat{\Gamma}(\tau)^\top / p\right\\.
\$\$

## Examples

``` r
fit <- simVMA(n = 100, p = 5, order = 2, seed = 123)
statVMA(fit$x, lag = 1:5)
#>   lag        Sn
#> 1   1 0.2802450
#> 2   2 1.8580184
#> 3   3 1.0111102
#> 4   4 1.0631176
#> 5   5 0.9273607
```
