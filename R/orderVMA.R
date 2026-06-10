#' Estimate VMA Order
#'
#' Estimates the VMA order using a stable-interval rule based on the statistic curve.
#'
#' @details
#' The order is selected from the statistics computed by \code{\link{statVMA}}.
#' The selected order is one lag before the statistic enters a stable interval
#' around 1.
#'
#' @param x A numeric matrix or data frame.
#' @param lag A numeric vector of candidate lags.
#' @param center Logical. If `TRUE`, center each column.
#' @param draw Logical. If `TRUE`, draw the statistic curve.
#' @param tail Number of tail lags used to estimate the interval width.
#' @param c Multiplier for the tail standard deviation.
#' @param min_width Minimum half-width of the stable interval.
#' @param min_prop_after Required proportion of later lags inside the interval.
#' @param consecutive Required number of consecutive lags inside the interval.
#'
#' @return A list with the estimated order, interval result, and table.
#' @export
#'
#' @examples
#' fit <- simVMA(n = 120, p = 5, order = 2, seed = 123)
#' orderVMA(fit$x, lag = 1:8, draw = FALSE)
orderVMA <- function(x, lag = 1:10, center = FALSE, draw = TRUE,
                     tail = 3, c = 3, min_width = 0.02, min_prop_after = 1,consecutive = 1) {

  x <- as.matrix(x); lags <- as.numeric(lag)

  interval_order <- function(s, lag) {
    s <- as.numeric(s)
    lag <- as.numeric(lag)

    if (length(s) != length(lag)) {stop("length(s) must be equal to length(lag).")}
    L <- length(s)

    if (tail >= L) {stop("tail must be smaller than length(s).")}
    if (min_prop_after <= 0 || min_prop_after > 1) {stop("min_prop_after must be in (0, 1].")}
    if (consecutive < 1) {stop("consecutive must be at least 1.")}

    tail_id <- (L - tail + 1):L
    tail_value <- s[tail_id]

    tail_mean <- mean(tail_value, na.rm = TRUE)
    tail_sd <- sd(tail_value, na.rm = TRUE)
    if (is.na(tail_sd)) {tail_sd <- 0}
    width <- max(c * tail_sd, min_width)
    lower <- 1 - width; upper <- 1 + width
    inside <- (s >= lower) & (s <= upper)

    stable_start <- NA
    for (j in 2:L) {
      after_inside <- inside[j:L]
      enough_after <- mean(after_inside, na.rm = TRUE) >= min_prop_after
      enough_consecutive <- if (j + consecutive - 1 <= L) {
        all(inside[j:(j + consecutive - 1)])
      } else {
        FALSE
      }

      if (enough_after && enough_consecutive) {
        stable_start <- lag[j]
        break
      }
    }

    if (is.na(stable_start)) {q_hat <- lag[which.max(s)]}
    else {q_hat <- stable_start - 1}

    list(
      q_hat = q_hat,
      stable_start = stable_start,
      lower = lower,
      upper = upper,
      tail_mean = tail_mean,
      tail_sd = tail_sd,
      width = width,
      inside = inside
    )
  }

  result_table <- statVMA(x = x, lag = lags, center = center)

  interval_fit <- interval_order(s = result_table$Sn, lag = lags)
  q_hat <- interval_fit$q_hat

  result_table$inside_interval <- interval_fit$inside
  result_table$lower <- round(interval_fit$lower, 4)
  result_table$upper <- round(interval_fit$upper, 4)
  result_table$width <- round(interval_fit$width, 4)
  result_table$tail_mean <- round(interval_fit$tail_mean, 4)
  result_table$tail_sd <- round(interval_fit$tail_sd, 4)
  result_table$stable_start <- interval_fit$stable_start
  result_table$q_hat_interval <- q_hat

  if (draw) {
    plot(
      result_table$lag,
      result_table$Sn,
      type = "b", pch = 15, lwd = 2,  xaxt = "n",
      xlab = "Tau", ylab = expression(S[n](tau))
    )
    axis(1, at = result_table$lag, labels = result_table$lag)
    abline(v = q_hat, col = "red", lty = 2, lwd = 2)
  }

  return(
    list(
      order = q_hat,
      interval = interval_fit,
      table = result_table
    )
  )
}
