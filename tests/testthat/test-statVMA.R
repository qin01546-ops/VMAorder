test_that("statVMA returns a statistic table", {
  fit <- simVMA(n = 60, p = 4, order = 2, seed = 123)
  out <- statVMA(fit$x, lag = 1:4)

  expect_s3_class(out, "data.frame")
  expect_equal(names(out), c("lag", "Sn"))
  expect_equal(out$lag, 1:4)
  expect_equal(nrow(out), 4)
  expect_true(all(is.finite(out$Sn)))
})

test_that("statVMA rejects too large lags", {
  x <- matrix(rnorm(20), nrow = 10)

  expect_error(
    statVMA(x, lag = 9),
    "sample size"
  )
})
