test_that("stationVMA returns stationarity summary", {
  set.seed(123)
  x <- matrix(rnorm(100), ncol = 2)

  out <- stationVMA(x)

  expect_type(out, "list")
  expect_true(all(c("non_stationary", "table") %in% names(out)))
  expect_type(out$non_stationary, "integer")
  expect_s3_class(out$table, "data.frame")
  expect_equal(names(out$table), c("variable", "p_value", "result"))
  expect_equal(nrow(out$table), 2)
})

test_that("stationVMA accepts data frames and preserves variable names", {
  set.seed(123)
  x <- data.frame(
    a = rnorm(50),
    b = rnorm(50)
  )

  out <- stationVMA(x)

  expect_equal(out$table$variable, c("a", "b"))
  expect_true(all(out$table$result %in% c("stationary", "non-stationary")))
  expect_true(all(is.finite(out$table$p_value)))
})

test_that("stationVMA respects alpha threshold", {
  set.seed(123)
  x <- matrix(rnorm(100), ncol = 2)

  out_low <- stationVMA(x, alpha = 0.01)
  out_high <- stationVMA(x, alpha = 0.99)

  expect_lte(out_low$non_stationary, 2)
  expect_gte(out_low$non_stationary, 0)
  expect_lte(out_high$non_stationary, 2)
  expect_gte(out_high$non_stationary, 0)
})
