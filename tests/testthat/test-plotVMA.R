test_that("plotVMA returns plot output", {
  settings <- data.frame(p = 3, n = 40)

  out <- plotVMA(
    order = 2,
    settings = settings,
    R = 2,
    lag = 1:5,
    seed = 123
  )

  expect_type(out, "list")
  expect_true(all(c("data", "order_table", "plot") %in% names(out)))
  expect_s3_class(out$plot, "ggplot")
})
