test_that("orderVMA returns an estimated order", {
  fit <- simVMA(n = 60, p = 4, order = 2, seed = 123)
  out <- orderVMA(fit$x, lag = 1:6, draw = FALSE)

  expect_type(out, "list")
  expect_true("order" %in% names(out))
  expect_true(is.numeric(out$order))
})
