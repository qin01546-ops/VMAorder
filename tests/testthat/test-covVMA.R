test_that("covVMA computes lagged covariance matrix", {
  x <- matrix(
    c(
      1, 2,
      3, 4,
      5, 6
    ),
    ncol = 2,
    byrow = TRUE
  )

  out <- covVMA(x, lag = 1)

  expected <- crossprod(x[1:2, ], x[2:3, ]) / nrow(x)

  expect_type(out, "double")
  expect_equal(dim(out), c(2, 2))
  expect_equal(out, expected)
})

test_that("covVMA handles lag zero", {
  x <- matrix(1:12, nrow = 4)

  out <- covVMA(x, lag = 0)
  expected <- crossprod(x, x) / nrow(x)

  expect_equal(out, expected)
})

test_that("covVMA accepts data frames", {
  x <- data.frame(
    a = c(1, 2, 3, 4),
    b = c(2, 3, 4, 5)
  )

  out <- covVMA(x, lag = 1)

  expect_equal(dim(out), c(2, 2))
  expect_true(is.matrix(out))
})

test_that("covVMA rejects invalid lags", {
  x <- matrix(1:12, nrow = 4)

  expect_error(covVMA(x, lag = -1), "lag must satisfy")
  expect_error(covVMA(x, lag = 4), "lag must satisfy")
})
