
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
   fitted_values = fitted(fitted.lm)
   std_res = rstandard(fitted.lm)

   df = data.frame(std_res, fitted_values)
   names(df) = c("sqrt(std_res)", "fitted_values")
   return (ggplot(data = df, aes(x = fitted_values, y = sqrt(abs(std_res)))) +
              geom_point(size = scale.factor) +
              geom_smooth(method = method, se = se, size = scale.factor, color = "indianred3") +
              ggtitle("Scale-Location Plot") +
              labs(x="Fitted Values", y = "Sqrt(Standardized Residuals)"))
}
