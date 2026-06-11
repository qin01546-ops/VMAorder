# Plot VMA Statistic Curves

Plots mean statistic curves from repeated VMA simulations.

## Usage

``` r
plotVMA(
  order = c(2, 5),
  settings = NULL,
  R = 100,
  lag = 1:10,
  seed = 123,
  nonzero_ratio = 1/60,
  min = -0.4,
  max = 0.6,
  same_lag_matrix = FALSE
)
```

## Arguments

- order:

  A numeric vector of VMA orders.

- settings:

  A data frame with columns `p`, `n`, and optionally `label`.

- R:

  Number of replications.

- lag:

  A numeric vector of lags.

- seed:

  An optional random seed.

- nonzero_ratio:

  Proportion of non-zero entries in each coefficient matrix.

- min:

  Lower bound for generated non-zero coefficients.

- max:

  Upper bound for generated non-zero coefficients.

- same_lag_matrix:

  Logical. If `TRUE`, use the same coefficient matrix for all lags.

## Value

A list with plot data, order frequencies, and the plot object.

## Examples

``` r
if (FALSE) { # \dontrun{
settings <- data.frame(p = c(5, 8), n = c(80, 100))
out <- plotVMA(order = c(2, 3), settings = settings, R = 5, lag = 1:6)
out$plot
} # }
```
