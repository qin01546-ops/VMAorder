#' Compute VMA Statistics
#'
#' Computes lag-wise statistics for VMA order selection.
#'
#' @details
#' For each lag \eqn{\tau}, the statistic is
#' \deqn{
#' S_n(\tau) = F_n(\tau) / F_n(\tau + 1),
#' }
#' where
#' \deqn{
#' F_n(\tau) = \operatorname{tr}
#' \left\{\widehat{\Gamma}(\tau)\widehat{\Gamma}(\tau)^\top / p\right\}.
#' }
#'
#' @param x A numeric matrix or data frame.
#' @param lag A numeric vector of lags.
#' @param center Logical. If `TRUE`, center each column.
#'
#' @return A data frame with `lag` and `Sn`.
#' @export
#'
#' @examples
#' fit <- simVMA(n = 100, p = 5, order = 2, seed = 123)
#' statVMA(fit$x, lag = 1:5)
statVMA <- function(x, lag = 1:10, center = FALSE) {
  x <- as.matrix(x)
  n <- nrow(x)
  p <- ncol(x)
  lags <- as.numeric(lag)

  if (max(lags) + 1 >= n) {
    stop("max(lag) + 1 must be smaller than sample size n.")
  }
  if (center) {
    x <- scale(x, center = TRUE, scale = FALSE)
  }

  f_value <- function(k) {
    matt <- covVMA(x, k)
    gamma <- (matt %*% t(matt)) / p
    sum(diag(gamma))
  }

  fn_tau <- sapply(lags, f_value)
  fn_tau_next <- sapply(lags + 1, f_value)

  stat <- fn_tau / fn_tau_next

  result_table <- data.frame(
    lag = lags,
    Sn = as.numeric(stat)
  )

  return(result_table)
}
