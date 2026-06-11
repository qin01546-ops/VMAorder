# Test Stationarity

Performs the Augmented Dickey-Fuller test for each variable in a
multivariate time series.

## Usage

``` r
stationVMA(x, alpha = 0.05)
```

## Arguments

- x:

  A numeric matrix or data frame.

- alpha:

  Significance level for the test.

## Value

A list with the number of non-stationary variables and a result table.

## Details

Each column is tested with
[`tseries::adf.test`](https://rdrr.io/pkg/tseries/man/adf.test.html). A
variable is labeled stationary when its p-value is smaller than `alpha`.

## Examples

``` r
if (FALSE) { # \dontrun{
fit <- simVMA(n = 100, p = 4, order = 2, seed = 123)
stationVMA(fit$x)
} # }
```
