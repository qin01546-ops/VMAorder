# Estimate VMA Order

Estimates the VMA order using a tail-amplified ratio rule.

## Usage

``` r
orderVMA(x, lag = 1:10, center = FALSE, draw = TRUE, c0 = 1)
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

- c0:

  Positive threshold constant for the tail-amplified rule.

## Value

A list with the estimated order, threshold information, candidate
criterion table, and lag-wise statistic table.

## Details

The order is selected from the adjacent-lag ratios computed by
[`statVMA`](https://qin01546-ops.github.io/VMAorder/reference/statVMA.md).
For candidate lags \\1,\ldots,M\\, the rule computes \$\$ G_n(K) = 1 +
\sqrt{p}\max\_{K \< \tau \le M}\|S_n(\tau)-1\|, \quad K = 0,\ldots,M.
\$\$ The estimated order is the smallest \\K\\ such that \\G_n(K) \le
1 + c_0\\. Equivalently, all later ratios must lie in the deterministic
interval \\1 \pm c_0 / \sqrt{p}\\.

## Examples

``` r
fit <- simVMA(n = 120, p = 5, order = 2, seed = 123)
orderVMA(fit$x, lag = 1:8, draw = FALSE)
#> $order
#> [1] 8
#> 
#> $interval
#> $interval$q_hat
#> [1] 8
#> 
#> $interval$lower
#> [1] 0.5527864
#> 
#> $interval$upper
#> [1] 1.447214
#> 
#> $interval$width
#> [1] 0.4472136
#> 
#> $interval$c0
#> [1] 1
#> 
#> $interval$inside
#> [1]  TRUE FALSE FALSE  TRUE  TRUE  TRUE  TRUE FALSE
#> 
#> $interval$abs_deviation
#> [1] 0.42985189 1.05108082 0.46606860 0.42241005 0.01679600 0.08452416 0.17862708
#> [8] 0.91177511
#> 
#> $interval$criterion
#>   K tail_max_abs       Gn  pass
#> 1 0    1.0510808 3.350288 FALSE
#> 2 1    1.0510808 3.350288 FALSE
#> 3 2    0.9117751 3.038791 FALSE
#> 4 3    0.9117751 3.038791 FALSE
#> 5 4    0.9117751 3.038791 FALSE
#> 6 5    0.9117751 3.038791 FALSE
#> 7 6    0.9117751 3.038791 FALSE
#> 8 7    0.9117751 3.038791 FALSE
#> 9 8    0.0000000 1.000000  TRUE
#> 
#> 
#> $criterion
#>   K tail_max_abs       Gn  pass
#> 1 0    1.0510808 3.350288 FALSE
#> 2 1    1.0510808 3.350288 FALSE
#> 3 2    0.9117751 3.038791 FALSE
#> 4 3    0.9117751 3.038791 FALSE
#> 5 4    0.9117751 3.038791 FALSE
#> 6 5    0.9117751 3.038791 FALSE
#> 7 6    0.9117751 3.038791 FALSE
#> 8 7    0.9117751 3.038791 FALSE
#> 9 8    0.0000000 1.000000  TRUE
#> 
#> $table
#>   lag        Sn inside_interval abs_deviation  lower  upper  width c0
#> 1   1 0.5701481            TRUE        0.4299 0.5528 1.4472 0.4472  1
#> 2   2 2.0510808           FALSE        1.0511 0.5528 1.4472 0.4472  1
#> 3   3 0.5339314           FALSE        0.4661 0.5528 1.4472 0.4472  1
#> 4   4 1.4224100            TRUE        0.4224 0.5528 1.4472 0.4472  1
#> 5   5 0.9832040            TRUE        0.0168 0.5528 1.4472 0.4472  1
#> 6   6 1.0845242            TRUE        0.0845 0.5528 1.4472 0.4472  1
#> 7   7 0.8213729            TRUE        0.1786 0.5528 1.4472 0.4472  1
#> 8   8 1.9117751           FALSE        0.9118 0.5528 1.4472 0.4472  1
#>   q_hat_interval
#> 1              8
#> 2              8
#> 3              8
#> 4              8
#> 5              8
#> 6              8
#> 7              8
#> 8              8
#> 
```
