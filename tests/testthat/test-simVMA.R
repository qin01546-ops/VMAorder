test_that("simVMAcoef returns coefficient array", {
  coef <- simVMAcoef(p = 4, order = 2, nonzero_ratio = 0.5)

  expect_equal(dim(coef), c(4, 4, 2))
  expect_true(is.array(coef))
  expect_true(all(is.finite(coef)))
})

test_that("simVMAcoef sparsity per lag is not affected by order", {
  p <- 30
  expected_nonzero <- round((1 / 60) * p * p)

  coef_order2 <- simVMAcoef(p = p, order = 2)
  coef_order7 <- simVMAcoef(p = p, order = 7)

  count_nonzero <- function(coef) {
    vapply(seq_len(dim(coef)[3]), function(h) {
      sum(coef[, , h] != 0)
    }, integer(1))
  }

  expect_equal(count_nonzero(coef_order2), rep(expected_nonzero, 2))
  expect_equal(count_nonzero(coef_order7), rep(expected_nonzero, 7))
})

test_that("simVMA returns simulated data", {
  fit <- simVMA(n = 50, p = 3, order = 2, seed = 123)

  expect_type(fit, "list")
  expect_true("x" %in% names(fit))
  expect_equal(dim(fit$x), c(50, 3))
  expect_true(all(is.finite(fit$x)))
})

test_that("simVMA is reproducible with the same seed", {
  fit1 <- simVMA(n = 30, p = 3, order = 2, seed = 123)
  fit2 <- simVMA(n = 30, p = 3, order = 2, seed = 123)

  expect_equal(fit1$x, fit2$x)
})

test_that("simVMA vectorized simulation matches the model definition", {
  p <- 2
  n <- 5
  order <- 2
  coeff <- array(0, dim = c(p, p, order))
  coeff[, , 1] <- diag(c(0.2, -0.1))
  coeff[, , 2] <- matrix(c(0, 0.3, -0.4, 0), nrow = p)
  innov <- matrix(seq_len((n + order) * p) / 10, nrow = n + order, ncol = p)

  fit <- simVMA(n = n, p = p, order = order, coeff = coeff, innov = innov)

  expected <- matrix(NA_real_, nrow = n, ncol = p)
  for (t in seq_len(n)) {
    expected[t, ] <- innov[t + order, ] +
      as.numeric(coeff[, , 1] %*% innov[t + order - 1, ]) +
      as.numeric(coeff[, , 2] %*% innov[t + order - 2, ])
  }

  expect_equal(unname(fit$x), expected)
})
