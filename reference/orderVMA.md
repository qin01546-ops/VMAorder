# Estimate VMA Order

Estimates the VMA order using a stable-interval rule based on the
statistic curve.

## Usage

``` r
orderVMA(
  x,
  lag = 1:10,
  center = FALSE,
  draw = TRUE,
  tail = 3,
  c = 3,
  min_width = 0.02,
  min_prop_after = 1,
  consecutive = 1
)
```

## Arguments

- x:

  A numeric matrix or data frame.

- lag:

  A numeric vector of candidate lags.

- center:

  Logical. If `TRUE`, center each column.

- draw:

  Logical. If `TRUE`, draw the statistic curve.

- tail:

  Number of tail lags used to estimate the interval width.

- c:

  Multiplier for the tail standard deviation.

- min_width:

  Minimum half-width of the stable interval.

- min_prop_after:

  Required proportion of later lags inside the interval.

- consecutive:

  Required number of consecutive lags inside the interval.

## Value

A list with the estimated order, interval result, and table.

## Details

The order is selected from the statistics computed by
[`statVMA`](https://qin01546-ops.github.io/VMAorder/reference/statVMA.md).
The selected order is one lag before the statistic enters a stable
interval around 1.

## Examples

``` r
fit <- simVMA(n = 120, p = 5, order = 2, seed = 123)
orderVMA(fit$x, lag = 1:8, draw = FALSE)
#> $order
#> [1] 2
#> 
#> $interval
#> $interval$q_hat
#> [1] 2
#> 
#> $interval$stable_start
#> [1] 3
#> 
#> $interval$lower
#> [1] -0.7010508
#> 
#> $interval$upper
#> [1] 2.701051
#> 
#> $interval$tail_mean
#> [1] 1.375998
#> 
#> $interval$tail_sd
#> [1] 0.5670169
#> 
#> $interval$width
#> [1] 1.701051
#> 
#> $interval$inside
#> [1]  TRUE FALSE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE
#> 
#> 
#> $table
#>   lag        Sn inside_interval   lower  upper  width tail_mean tail_sd
#> 1   1 0.3658179            TRUE -0.7011 2.7011 1.7011     1.376   0.567
#> 2   2 3.8216018           FALSE -0.7011 2.7011 1.7011     1.376   0.567
#> 3   3 0.4625264            TRUE -0.7011 2.7011 1.7011     1.376   0.567
#> 4   4 1.5549028            TRUE -0.7011 2.7011 1.7011     1.376   0.567
#> 5   5 0.8004772            TRUE -0.7011 2.7011 1.7011     1.376   0.567
#> 6   6 1.3808891            TRUE -0.7011 2.7011 1.7011     1.376   0.567
#> 7   7 0.8065515            TRUE -0.7011 2.7011 1.7011     1.376   0.567
#> 8   8 1.9405537            TRUE -0.7011 2.7011 1.7011     1.376   0.567
#>   stable_start q_hat_interval
#> 1            3              2
#> 2            3              2
#> 3            3              2
#> 4            3              2
#> 5            3              2
#> 6            3              2
#> 7            3              2
#> 8            3              2
#> 
```
