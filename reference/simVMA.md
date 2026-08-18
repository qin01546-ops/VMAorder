# Simulate a Vector Moving-Average Process

Simulates a multivariate VMA process with optional user-specified
coefficients.

## Usage

``` r
simVMA(
  n,
  p,
  order,
  coeff = NULL,
  nonzero_ratio = 1/60,
  min = -0.4,
  max = 0.6,
  same_lag_matrix = FALSE,
  scale_by_sqrt_p = TRUE,
  innov = NULL,
  innov_cov = diag(p),
  burnin = 0,
  seed = NULL
)
```

## Arguments

- n:

  A positive integer sample size.

- p:

  A positive integer dimension.

- order:

  A positive integer VMA order.

- coeff:

  An optional coefficient array with dimension `c(p, p, order)`.

- nonzero_ratio:

  Proportion of non-zero entries used when `coeff = NULL`.

- min:

  Lower bound for generated coefficients.

- max:

  Upper bound for generated coefficients.

- same_lag_matrix:

  Logical. If `TRUE`, use the same coefficient matrix for all lags.

- scale_by_sqrt_p:

  Logical. If `TRUE`, divide generated non-zero coefficients by
  \\\sqrt{p}\\ when `coeff = NULL`.

- innov:

  An optional innovation matrix.

- innov_cov:

  Covariance matrix for generated Gaussian innovations.

- burnin:

  Number of initial observations to discard.

- seed:

  An optional random seed.

## Value

A list containing the simulated data, coefficients, innovations, order,
dimension, and sample size.

## Details

The simulated process is \$\$ x_t = z_t + \sum\_{h=1}^q A_h z\_{t-h},
\$\$ where `z_t` is white noise and `A_h` is the coefficient matrix at
lag `h`.

## Examples

``` r
set.seed(123)
fit <- simVMA(n = 100, p = 5, order = 2)
head(fit$x)
#>              X1         X2         X3         X4         X5
#> [1,] -0.1089660  0.4520302 -0.4628790  1.1041295 -1.4369972
#> [2,] -0.1172420  0.5268557 -1.9111513 -0.5242478 -1.6133441
#> [3,]  0.1830826 -0.2302622  0.3698160 -0.4585726  0.6171376
#> [4,]  1.2805549  1.3974267 -0.4622881  0.5765070  0.7466347
#> [5,] -1.7272706  1.7636530  0.3219559 -0.4221787  0.5834838
#> [6,]  1.6901844  0.4856014 -0.2840014  0.9027912  0.1829487
```
