# Estimate Lagged Cross-Covariance Matrix

Computes the lagged cross-covariance matrix for a multivariate time
series.

## Usage

``` r
covVMA(x, lag)
```

## Arguments

- x:

  Numeric matrix or data frame. Rows are time points and columns are
  variables.

- lag:

  Non-negative integer lag.

## Value

A `p` by `p` matrix containing the estimated lagged cross-covariances.

## Details

For an `n` by `p` observation matrix \\X\\, this function computes
\$\$\widehat{\Gamma}(k) = \frac{1}{n}\sum\_{t = 1}^{n-k} X_t
X\_{t+k}^{\top},\$\$ where \\k\\ is the requested lag.

## Examples

``` r
x <- matrix(rnorm(100 * 4), nrow = 100, ncol = 4)
covVMA(x, lag = 1)
#>             [,1]        [,2]        [,3]         [,4]
#> [1,] -0.09138032 -0.01620429 -0.02344429 -0.176566378
#> [2,]  0.09618746  0.13913531  0.18690322  0.027403475
#> [3,] -0.12914804  0.07676332 -0.18160144 -0.003903643
#> [4,] -0.08047578 -0.10856167 -0.06475181 -0.046627651
```
