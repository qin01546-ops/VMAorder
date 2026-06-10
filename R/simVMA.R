#' Generate VMA Coefficients
#'
#' Generates sparse coefficient matrices for a vector moving-average model.
#'
#' @details
#' The returned array stores the coefficient matrices in
#' \deqn{x_t = z_t + \sum_{h=1}^q A_h z_{t-h}.}
#' The slice `coef[, , h]` corresponds to `A_h`.
#'
#' @param p A positive integer dimension.
#' @param order A positive integer VMA order.
#' @param nonzero_ratio Proportion of non-zero entries. Must be in `(0, 1]`.
#' @param min Lower bound for non-zero coefficients.
#' @param max Upper bound for non-zero coefficients.
#' @param same_lag_matrix Logical. If `TRUE`, use the same matrix for all lags.
#'
#' @return A numeric array with dimension `c(p, p, order)`.
#' @export
#'
#' @examples
#' set.seed(123)
#' coef <- simVMAcoef(p = 5, order = 2)
#' dim(coef)
simVMAcoef <- function(p, order, nonzero_ratio = 1 / 60,
                       min = -0.4, max = 0.6,
                       same_lag_matrix = FALSE) {
  if (length(p) != 1 || is.na(p) || p <= 0 || p != floor(p)) {
    stop("p must be a positive integer.")
  }
  if (length(order) != 1 || is.na(order) || order <= 0 || order != floor(order)) {
    stop("order must be a positive integer.")
  }
  if (length(nonzero_ratio) != 1 || is.na(nonzero_ratio) ||
    nonzero_ratio <= 0 || nonzero_ratio > 1) {
    stop("nonzero_ratio must be in (0, 1].")
  }
  if (min >= max) {
    stop("min must be smaller than max.")
  }

  p <- as.integer(p)
  order <- as.integer(order)
  coeff <- array(0, dim = c(p, p, order))
  num_nonzero <- max(1, round(nonzero_ratio * p * p))

  make_one_matrix <- function() {
    A <- matrix(0, nrow = p, ncol = p)
    nonzero_id <- sample.int(p * p, num_nonzero)
    A[nonzero_id] <- stats::runif(num_nonzero, min = min, max = max)
    A
  }

  if (same_lag_matrix) {
    A <- make_one_matrix()
    for (h in seq_len(order)) {
      coeff[, , h] <- A
    }
  } else {
    for (h in seq_len(order)) {
      coeff[, , h] <- make_one_matrix()
    }
  }

  dimnames(coeff) <- list(
    paste0("X", seq_len(p)),
    paste0("X", seq_len(p)),
    paste0("lag", seq_len(order))
  )

  coeff
}

#' Simulate a Vector Moving-Average Process
#'
#' Simulates a multivariate VMA process with optional user-specified coefficients.
#'
#' @details
#' The simulated process is
#' \deqn{
#' x_t = z_t + \sum_{h=1}^q A_h z_{t-h},
#' }
#' where `z_t` is white noise and `A_h` is the coefficient matrix at lag `h`.
#'
#' @param n A positive integer sample size.
#' @param p A positive integer dimension.
#' @param order A positive integer VMA order.
#' @param coeff An optional coefficient array with dimension `c(p, p, order)`.
#' @param nonzero_ratio Proportion of non-zero entries used when `coeff = NULL`.
#' @param min Lower bound for generated coefficients.
#' @param max Upper bound for generated coefficients.
#' @param same_lag_matrix Logical. If `TRUE`, use the same coefficient matrix
#'   for all lags.
#' @param innov An optional innovation matrix.
#' @param innov_cov Covariance matrix for generated Gaussian innovations.
#' @param burnin Number of initial observations to discard.
#' @param seed An optional random seed.
#'
#' @return A list containing the simulated data, coefficients, innovations,
#'   order, dimension, and sample size.
#' @export
#'
#' @examples
#' set.seed(123)
#' fit <- simVMA(n = 100, p = 5, order = 2)
#' head(fit$x)
simVMA <- function(n, p, order, coeff = NULL, nonzero_ratio = 1 / 60, min = -0.4, max = 0.6,
                   same_lag_matrix = FALSE, innov = NULL, innov_cov = diag(p), burnin = 0, seed = NULL) {
  if (!is.null(seed)) {
    set.seed(seed)
  }
  if (length(n) != 1 || is.na(n) || n <= 0 || n != floor(n)) {
    stop("n must be a positive integer.")
  }
  if (length(p) != 1 || is.na(p) || p <= 0 || p != floor(p)) {
    stop("p must be a positive integer.")
  }
  if (length(order) != 1 || is.na(order) || order <= 0 || order != floor(order)) {
    stop("order must be a positive integer.")
  }
  if (length(burnin) != 1 || is.na(burnin) || burnin < 0 || burnin != floor(burnin)) {
    stop("burnin must be a non-negative integer.")
  }

  n <- as.integer(n)
  p <- as.integer(p)
  order <- as.integer(order)
  burnin <- as.integer(burnin)

  if (is.null(coeff)) {
    coeff <- simVMAcoef(
      p = p, order = order, nonzero_ratio = nonzero_ratio,
      min = min, max = max, same_lag_matrix = same_lag_matrix
    )
  } else {
    coeff <- as.array(coeff)
    if (!all(dim(coeff) == c(p, p, order))) {
      stop("coeff must be an array with dim c(p, p, order).")
    }
  }

  total_n <- n + burnin
  innov_n <- total_n + order

  if (is.null(innov)) {
    innov_cov <- as.matrix(innov_cov)
    if (!all(dim(innov_cov) == c(p, p))) {
      stop("innov_cov must be a p by p covariance matrix.")
    }
    R <- tryCatch(
      chol(innov_cov),
      error = function(e) stop("innov_cov must be positive definite.")
    )
    z <- matrix(stats::rnorm(innov_n * p), nrow = innov_n, ncol = p)
    z <- z %*% R
  } else {
    z <- as.matrix(innov)
    if (nrow(z) < innov_n || ncol(z) != p) {
      stop("innov must have at least n + burnin + order rows and p columns.")
    }
    z <- z[seq_len(innov_n), , drop = FALSE]
  }

  x_all <- matrix(0, nrow = total_n, ncol = p)
  for (t in seq_len(total_n)) {
    xt <- z[t + order, ]
    for (h in seq_len(order)) {
      xt <- xt + as.numeric(coeff[, , h] %*% z[t + order - h, ])
    }
    x_all[t, ] <- xt
  }

  keep_id <- seq.int(burnin + 1, total_n)
  x <- x_all[keep_id, , drop = FALSE]
  colnames(x) <- paste0("X", seq_len(p))
  colnames(z) <- paste0("Z", seq_len(p))

  list(
    x = x,
    coef = coeff,
    coeff = coeff,
    innovations = z,
    order = order,
    p = p,
    n = n
  )
}
