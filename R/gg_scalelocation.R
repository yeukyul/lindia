
#' Plot scale-location (also called spread-location plot) in ggplot.
#'
#' @param fitted.lm a fitted linear model (i.e. lm, glm) that contains fitted regression
#' @param method smoothing method of fitted line on scale-location plot.
#'          eg. "lm", "glm", "gam", "loess", "rlm". See \url{http://docs.ggplot2.org/current/geom_smooth.html}
#'          for more details.
#' @param se logical; determines whether se belt should be plotted on plot
#' @param scale.factor numeric; scales the point size and linewidth to allow customized viewing. Defaults to 1.
#' @return A ggplot object that contains scale-location graph
#' @examples library(MASS)
#' data(Cars93)
#' cars_lm <- lm(Price ~ Passengers + Length + RPM, data = Cars93)
#' gg_scalelocation(cars_lm)
#' @export
#'
gg_scalelocation <- function(fitted.lm, method = 'loess', scale.factor = 1, se = FALSE) {

   handle_exception(fitted.lm, "gg_scalelocation")

   #obtain stardardized residual and fitted values from fitted.lm
   fitted_values <- fitted(fitted.lm)
   std_res <- rstandard(fitted.lm)
   n <- length(std_res)
   std_res_th <- rnorm(n)

   df <- data.frame(
      sqrt_abs_std_res = sqrt(abs(c(std_res, std_res_th))),
      fitted_values = rep(fitted_values, times = 2),
      type = rep(c("Observed Distribution", "Theoretical Distribution"), each = n)
   )

   ggplot(data = df, aes(x = fitted_values, y = sqrt_abs_std_res, col = type)) +
      geom_point(size = scale.factor) +
      geom_smooth(method = method, se = se, size = scale.factor, color = "indianred3") +
      labs(
         title = "Scale-Location Plot",
         x = "Fitted Values",
         y = "Sqrt(Standardized Residuals)"
      ) +
      facet_grid(cols = vars(type)) +
      theme_bw() +
      theme(legend.position = "none") +
      scale_color_viridis_d(option = "cividis")
}
