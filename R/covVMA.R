#' Estimate Lagged Cross-Covariance Matrix
#'
#' Computes the lagged cross-covariance matrix for a multivariate time series.
#'
#' @details
#' For an `n` by `p` observation matrix \eqn{X}, this function computes
#' \deqn{\widehat{\Gamma}(k) =
#'       \frac{1}{n}\sum_{t = 1}^{n-k} X_t X_{t+k}^{\top},}
#' where \eqn{k} is the requested lag.
#'
#' @param x Numeric matrix or data frame. Rows are time points and columns are variables.
#' @param lag Non-negative integer lag.
#'
#' @returns A `p` by `p` matrix containing the estimated lagged cross-covariances.
#' @export
#'
#' @examples
#' x <- matrix(rnorm(100 * 4), nrow = 100, ncol = 4)
#' covVMA(x, lag = 1)
covVMA <- function(x, lag) {
  x <- as.matrix(x)
  n <- nrow(x)
  if (lag < 0 || lag >= n) {
    stop("lag must satisfy 0 <= lag <= n - 1.")
  }
  X1 <- x[1:(n - lag), , drop = FALSE]
  X2 <- x[(1 + lag):n, , drop = FALSE]
  gamma <- crossprod(X1, X2) / n
  return(gamma)
}
