test_that("orderVMA returns an estimated order", {
  fit <- simVMA(n = 60, p = 4, order = 2, seed = 123)
  out <- orderVMA(fit$x, lag = 1:6, draw = FALSE)

  expect_type(out, "list")
  expect_true("order" %in% names(out))
  expect_true(is.numeric(out$order))
})

test_that("orderVMA uses the tail-amplified rule", {
  x <- matrix(0, nrow = 30, ncol = 4)
  out <- orderVMA(x, lag = 1:5, draw = FALSE, c0 = 1)

  expect_equal(out$order, 0)
  expect_equal(out$criterion$K, 0:5)
  expect_equal(tail(out$criterion$Gn, 1), 1)
  expect_true(all(out$table$inside_interval))
})

test_that("orderVMA requires consecutive lags", {
  x <- matrix(rnorm(80), nrow = 20, ncol = 4)

  expect_error(
    orderVMA(x, lag = c(1, 2, 4), draw = FALSE),
    "consecutive"
  )
})
