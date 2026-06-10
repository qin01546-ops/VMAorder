#' Plot VMA Statistic Curves
#'
#' Plots mean statistic curves from repeated VMA simulations.
#'
#' @param order A numeric vector of VMA orders.
#' @param settings A data frame with columns `p`, `n`, and optionally `label`.
#' @param R Number of replications.
#' @param lag A numeric vector of lags.
#' @param seed An optional random seed.
#' @param nonzero_ratio Proportion of non-zero entries in each coefficient matrix.
#' @param min Lower bound for generated non-zero coefficients.
#' @param max Upper bound for generated non-zero coefficients.
#' @param same_lag_matrix Logical. If `TRUE`, use the same coefficient matrix for all lags.
#'
#' @return A list with plot data, order frequencies, and the plot object.
#' @importFrom rlang .data
#' @export
#'
#' @examples
#' \dontrun{
#' settings <- data.frame(p = c(5, 8), n = c(80, 100))
#' out <- plotVMA(order = c(2, 3), settings = settings, R = 5, lag = 1:6)
#' out$plot
#' }
plotVMA <- function(order = c(2, 5), settings = NULL, R = 100, lag = 1:10, seed = 123,
                    nonzero_ratio = 1 / 60, min = -0.4, max = 0.6, same_lag_matrix = FALSE) {
  if (!requireNamespace("ggplot2", quietly = TRUE)) {
    stop("Package 'ggplot2' is required. Please install it first.")
  }

  all_curve <- data.frame()
  all_order <- data.frame()

  if (!is.null(seed)) {
    set.seed(seed)
  }

  vma_mean_curve <- function(order) {
    if (is.null(settings)) {
      settings <- data.frame(
        p = c(10, 10, 10, 30, 50),
        n = c(30, 50, 500, 30, 50),
        label = c(
          "p=10, n=30", "p=10, n=50", "p=10, n=500",
          "p=n=30", "p=n=50"
        )
      )
    }
    if (!all(c("p", "n") %in% names(settings))) {
      stop("settings must contain columns 'p' and 'n'.")
    }
    if (!"label" %in% names(settings)) {
      settings$label <- paste0("p=", settings$p, ", n=", settings$n)
    }

    out <- data.frame()
    order_table <- data.frame()

    for (i in seq_len(nrow(settings))) {
      p <- settings$p[i]
      n <- settings$n[i]
      label <- settings$label[i]

      coeff <- simVMAcoef(
        p = p, order = order, nonzero_ratio = nonzero_ratio,
        min = min, max = max, same_lag_matrix = same_lag_matrix
      )

      stat_mat <- matrix(NA_real_, nrow = R, ncol = length(lag))
      q_hat <- numeric(R)

      for (r in seq_len(R)) {
        x <- simVMA(n = n, p = p, order = order, coeff = coeff)$x
        stat <- statVMA(x = x, lag = lag, center = FALSE)
        stat_mat[r, ] <- stat$Sn
        q_hat[r] <- orderVMA(x = x, lag = lag, center = FALSE, draw = FALSE)$order
      }

      curve <- data.frame(
        model = paste0("VMA(", order, ")"),
        order = order,
        p = p,
        n = n,
        setting = label,
        tau = lag,
        mean_Sn = colMeans(stat_mat),
        row.names = NULL
      )
      out <- rbind(out, curve)

      q_tab <- as.data.frame(table(q_hat))
      colnames(q_tab) <- c("q_hat", "freq")
      q_tab$model <- paste0("VMA(", order, ")")
      q_tab$order <- order
      q_tab$p <- p
      q_tab$n <- n
      q_tab$setting <- label
      q_tab$rate <- q_tab$freq / R
      order_table <- rbind(order_table, q_tab)
    }

    list(
      curve = out,
      order_table = order_table
    )
  }

  for (q in order) {
    fit <- vma_mean_curve(order = q)
    all_curve <- rbind(all_curve, fit$curve)
    all_order <- rbind(all_order, fit$order_table)
  }

  settings_levels <- unique(all_curve$setting)
  all_curve$setting <- factor(all_curve$setting, levels = settings_levels)

  colors <- c("black", "grey70", "blue", "darkgreen", "brown")
  plot <- ggplot2::ggplot(
    all_curve,
    ggplot2::aes(x = .data[["tau"]],
                 y = .data[["mean_Sn"]],
                 color = .data[["setting"]],
                 group = .data[["setting"]]
    )
  ) +
    ggplot2::geom_line(linewidth = 0.7) +
    ggplot2::geom_point(size = 1.8) +
    ggplot2::scale_x_continuous(breaks = lag) +
    ggplot2::scale_color_manual(values = colors[seq_along(settings_levels)]) +
    ggplot2::labs(x = "Tau", y = expression(S[n](tau)), color = NULL) +
    ggplot2::theme_minimal() +
    ggplot2::theme(
      legend.position = "bottom",
      legend.title = ggplot2::element_blank(),
      axis.title = ggplot2::element_text(face = "bold"),
      panel.grid.minor = ggplot2::element_line(color = "grey92"),
      panel.grid.major = ggplot2::element_line(color = "grey88")
    )

  if (length(unique(all_curve$model)) > 1) {
    plot <- plot + ggplot2::facet_wrap(~model, nrow = 1)
  } else {
    plot <- plot + ggplot2::ggtitle(unique(all_curve$model))
  }

  list(
    data = all_curve,
    order_table = all_order,
    plot = plot
  )
}
