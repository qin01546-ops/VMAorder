#' Estimate VMA Order
#'
#' Estimates the VMA order using a tail-amplified ratio rule.
#'
#' @details
#' The order is selected from the adjacent-lag ratios computed by
#' \code{\link{statVMA}}. For candidate lags \eqn{1,\ldots,M}, the rule computes
#' \deqn{
#' G_n(K) = 1 + \sqrt{p}\max_{K < \tau \le M}|S_n(\tau)-1|,
#' \quad K = 0,\ldots,M.
#' }
#' The estimated order is the smallest \eqn{K} such that
#' \eqn{G_n(K) \le 1 + c_0}. Equivalently, all later ratios must lie in the
#' deterministic interval \eqn{1 \pm c_0 / \sqrt{p}}.
#'
#' @param x A numeric matrix or data frame.
#' @param lag A numeric vector of candidate lags.
#' @param center Logical. If `TRUE`, center each column.
#' @param draw Logical. If `TRUE`, draw the statistic curve.
#' @param c0 Positive threshold constant for the tail-amplified rule.
#'
#' @return A list with the estimated order, threshold information, candidate
#'   criterion table, and lag-wise statistic table.
#' @importFrom graphics axis abline
#' @export
#'
#' @examples
#' fit <- simVMA(n = 120, p = 5, order = 2, seed = 123)
#' orderVMA(fit$x, lag = 1:8, draw = FALSE)
orderVMA <- function(x, lag = 1:10, center = FALSE, draw = TRUE, c0 = 1) {
  x <- as.matrix(x)
  p <- ncol(x)
  lags <- as.numeric(lag)

  if (length(c0) != 1 || is.na(c0) || c0 <= 0) {
    stop("c0 must be a positive number.")
  }
  if (length(lags) < 1 || anyNA(lags) || any(lags <= 0) || any(lags != floor(lags))) {
    stop("lag must contain positive integers.")
  }

  lags <- as.integer(lags)
  M <- max(lags)
  if (!identical(lags, seq_len(M))) {
    stop("lag must be consecutive integers 1:M.")
  }

  tail_order <- function(s, lag, p, c0) {
    s <- as.numeric(s)
    lag <- as.integer(lag)

    if (length(s) != length(lag)) {
      stop("length(s) must be equal to length(lag).")
    }
    if (any(!is.finite(s))) {
      stop("Sn must be finite for all candidate lags.")
    }

    M <- max(lag)
    K <- 0:M
    abs_deviation <- abs(s - 1)
    tail_max_abs <- vapply(K, function(k) {
      tail_id <- which(lag > k & lag <= M)
      if (length(tail_id) == 0L) {
        return(0)
      }
      max(abs_deviation[tail_id])
    }, numeric(1))
    Gn <- 1 + sqrt(p) * tail_max_abs
    passing <- Gn <= 1 + c0
    q_hat <- K[which(passing)[1L]]

    width <- c0 / sqrt(p)
    lower <- 1 - width
    upper <- 1 + width
    inside <- s >= lower & s <= upper

    criterion <- data.frame(
      K = K,
      tail_max_abs = tail_max_abs,
      Gn = Gn,
      pass = passing
    )

    list(
      q_hat = q_hat,
      lower = lower,
      upper = upper,
      width = width,
      c0 = c0,
      inside = inside,
      abs_deviation = abs_deviation,
      criterion = criterion
    )
  }

  result_table <- statVMA(x = x, lag = lags, center = center)

  interval_fit <- tail_order(s = result_table$Sn, lag = lags, p = p, c0 = c0)
  q_hat <- interval_fit$q_hat

  result_table$inside_interval <- interval_fit$inside
  result_table$abs_deviation <- round(interval_fit$abs_deviation, 4)
  result_table$lower <- round(interval_fit$lower, 4)
  result_table$upper <- round(interval_fit$upper, 4)
  result_table$width <- round(interval_fit$width, 4)
  result_table$c0 <- interval_fit$c0
  result_table$q_hat_interval <- q_hat

  if (draw) {
    graphics::plot(
      result_table$lag,
      result_table$Sn,
      type = "b", pch = 15, lwd = 2, xaxt = "n",
      xlab = "Tau", ylab = expression(S[n](tau))
    )
    graphics::axis(1, at = result_table$lag, labels = result_table$lag)
    graphics::abline(h = c(interval_fit$lower, interval_fit$upper), col = "grey50", lty = 3)
    graphics::abline(v = q_hat, col = "red", lty = 2, lwd = 2)
  }

  return(
    list(
      order = q_hat,
      interval = interval_fit,
      criterion = interval_fit$criterion,
      table = result_table
    )
  )
}
