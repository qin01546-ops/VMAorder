test_that("simVMAcoef returns coefficient array", {
  coef <- simVMAcoef(p = 4, order = 2, nonzero_ratio = 0.5)

  expect_equal(dim(coef), c(4, 4, 2))
  expect_true(is.array(coef))
  expect_true(all(is.finite(coef)))
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
