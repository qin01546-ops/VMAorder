#' Test Stationarity
#'
#' Performs the Augmented Dickey-Fuller test for each variable in a multivariate time series.
#'
#' @details
#' Each column is tested with \code{tseries::adf.test}. A variable is labeled
#' stationary when its p-value is smaller than `alpha`.
#'
#' @param x A numeric matrix or data frame.
#' @param alpha Significance level for the test.
#'
#' @returns A list with the number of non-stationary variables and a result table.
#' @export
#'
#' @examples
#' \dontrun{
#' fit <- simVMA(n = 100, p = 4, order = 2, seed = 123)
#' stationVMA(fit$x)
#' }
stationVMA <- function(x, alpha = 0.05) {
  x <- as.matrix(x); n <- nrow(x); p <- ncol(x)

  if (!requireNamespace("tseries", quietly = TRUE)) {
    stop("Package 'tseries' is required. Please install it first.")
  }

  p_value <- numeric(p)
  result <- character(p)

  for (j in 1:p) {
    test <- tseries::adf.test(x[, j])
    p_value[j] <- test$p.value

    if (p_value[j] < alpha) {
      result[j] <- "stationary"
    } else {
      result[j] <- "non-stationary"
    }
  }

  result_table <- data.frame(
    variable = if (is.null(colnames(x))) paste0("X", 1:p) else colnames(x),
    p_value = p_value,
    result = result
  )

  non_stationary_num <- sum(result == "non-stationary")

  cat("sample size:", n, "\n")
  cat("dimension:", p, "\n")
  cat("non-stationary:", non_stationary_num, "\n")

  return(
    list(
      non_stationary = non_stationary_num,
      table = result_table
    )
  )
}
