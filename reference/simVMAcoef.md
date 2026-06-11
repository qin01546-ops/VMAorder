# Generate VMA Coefficients

Generates sparse coefficient matrices for a vector moving-average model.

## Usage

``` r
simVMAcoef(
  p,
  order,
  nonzero_ratio = 1/60,
  min = -0.4,
  max = 0.6,
  same_lag_matrix = FALSE
)
```

## Arguments

- p:

  A positive integer dimension.

- order:

  A positive integer VMA order.

- nonzero_ratio:

  Proportion of non-zero entries. Must be in `(0, 1]`.

- min:

  Lower bound for non-zero coefficients.

- max:

  Upper bound for non-zero coefficients.

- same_lag_matrix:

  Logical. If `TRUE`, use the same matrix for all lags.

## Value

A numeric array with dimension `c(p, p, order)`.

## Details

The returned array stores the coefficient matrices in \$\$x_t = z_t +
\sum\_{h=1}^q A_h z\_{t-h}.\$\$ The slice `coef[, , h]` corresponds to
`A_h`.

## Examples

``` r
set.seed(123)
coef <- simVMAcoef(p = 5, order = 2)
dim(coef)
#> [1] 5 5 2
```
